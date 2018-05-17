//
//  ResKitClient.m
//  Chiroway
//
//  Created by applegod on 23.12.13.
//  Copyright (c) 2013 a.molchanovskiy. All rights reserved.
//

#import "RestKitClient.h"
#import "UIAlertHelper.h"
#import "ResponseStatusModel.h"


#define ACCEPT_KEY @"Accept"
#define ACCEPT_VALUE @"application/json"//@"application/vnd.getpack.co; version=3"
#define USER_ACCESS_TOKEN  @"UserAccessToken"
#define SUCCESS_STATUS_KEY @"200"
#define UNAUTHORIZED_STATUS_KEY @"401"

@implementation RestKitClient

+ (RestKitClient*)sharedClient
{
  static RestKitClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once( &onceToken, ^
                {
                  _sharedClient = [RestKitClient new];
                } );
  
  return _sharedClient;
}

#pragma mark - Restkit Setup Mappings Methods
- (void)setupRestKitMapping {
#ifdef RESTKIT_LOG
  RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#endif
  
  // Add our descriptors to the manager
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
  [RKObjectManager setSharedManager:manager];
  
  //Add adition http headers
  manager.HTTPClient.allowsInvalidSSLCertificate = YES;
  
  NSIndexSet * successStatusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  NSIndexSet * errorClientStatusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
  
  //Add adition http headers
  manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
  //  [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:ACCEPT_VALUE];
  //  [manager.HTTPClient setDefaultHeader:ACCEPT_KEY value:ACCEPT_VALUE];
  
  //Server Success Response Status
  RKResponseDescriptor * statusDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ResponseStatusModel objectMapping] method:RKRequestMethodAny  pathPattern:nil keyPath:nil statusCodes:successStatusCode];
  [manager addResponseDescriptor:statusDescriptor];
  
  //Server Error Response Status
  RKResponseDescriptor * errorStatusDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ResponseStatusModel objectMapping] method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:errorClientStatusCode];
  [manager addResponseDescriptor:errorStatusDescriptor];
}


- (void)requestWithMethod:(RKRequestMethod)method
            objectManager:(RKObjectManager*)objectManager
                   object:(id)object
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
          responseMapping:(RKMapping *)responseMapping
           requestMapping:(RKMapping *)requestMapping
          responseKeyPath:(NSString *)responseKeyPath
           requestKeyPath:(NSString *)requestKeyPath
                  success:(OnRequestSuccess)success
                  failure:(OnRequestFailed)failure {
  
  RKResponseDescriptor * responseDescriptor = nil;
  RKRequestDescriptor * requestDescriptor = nil;
  
  NSMutableDictionary * mutParams = [self getParamsFromPath:path];
  
  if(parameters) {
    [mutParams addEntriesFromDictionary:parameters];
  }
  
  if([mutParams allKeys].count == 0) {
    mutParams = nil;
  }
  
  NSString * pathPattern = [self getPathWithoutParams:path];
  
  if(responseMapping) {
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:method pathPattern:pathPattern keyPath:responseKeyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
  }
  
  if(requestMapping && object) {
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[object class] rootKeyPath:requestKeyPath method:method];
    [objectManager addRequestDescriptor:requestDescriptor];
  }
  
  RKObjectRequestOperation *operation = [objectManager appropriateObjectRequestOperationWithObject:object method:method path:pathPattern parameters:mutParams];
  [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [self removeResponseDescriptor:responseDescriptor andRequestDescriptor:requestDescriptor forRKObjectManager:objectManager];
    
    NSData *data = [operation.HTTPRequestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    id dataDict = [json objectForKey:@"data"];
    if ([dataDict isKindOfClass:[NSDictionary class]] && [dataDict objectForKey:@"code"] != nil) {
      NSNumber *code = [dataDict objectForKey:@"code"];
      if (code != nil && [code integerValue] == 401) {
        [[ServerManager sharedManager] signOutByIsEveryWhere:NO withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
          [Helpers resetValues];
        }];
      } else {
        if([self isSuccessStatusFromServer:operation]) {
          if(success) {
            success(operation);
          }
        }
      }
    } else {
      if([self isSuccessStatusFromServer:operation]) {
        if(success) {
          success(operation);
        }
      }
    }
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    [self removeResponseDescriptor:responseDescriptor andRequestDescriptor:requestDescriptor forRKObjectManager:objectManager];
    [self inspectErrorFromServerForOperation:operation];
    
    if(failure) {
      failure(operation, error);
    }
  }];
  [objectManager enqueueObjectRequestOperation:operation];
}

- (NSString*)getPathWithoutParams:(NSString*)path {
  
  NSArray * array = [path componentsSeparatedByString:@"?"];
  NSString * pathPattern = [array firstObject];
  
  if([pathPattern length] > 1 && [[pathPattern substringToIndex:1] isEqualToString:@"/"]) {
    pathPattern = [pathPattern substringFromIndex:1];
  }
  
  return pathPattern;
}

- (NSMutableDictionary*)getParamsFromPath:(NSString*)path {
  NSMutableDictionary * dict = [NSMutableDictionary new];
  NSArray * array = [path componentsSeparatedByString:@"?"];
  
  if([array count] == 2) {
    NSString * params = [array lastObject];
    NSArray * paramsArray = [params componentsSeparatedByString:@"&"];
    for (NSString * split in paramsArray) {
      NSArray * temp = [split componentsSeparatedByString:@"="];
      [dict setObject:[temp lastObject] forKey:[temp firstObject]];
    }
  }
  return dict;
}


#pragma mark - Error From Server Methods
- (void)inspectErrorFromServerForOperation:(RKObjectRequestOperation *) operation {
  //  [DELEGATE hideLoadingIndicator];
  MSLog(@"error: %@, status code: %li", operation.error, (long)operation.HTTPRequestOperation.response.statusCode);
  
  NSArray * errorArray =  [operation.error.userInfo objectForKey:RKObjectMapperErrorObjectsKey];
  if(errorArray && errorArray.firstObject) {
    ResponseStatusModel * errorModel = errorArray.firstObject;
    if(errorModel.errorMessage.length > 0) {
      //      [UIAlertHelper alert:errorModel.errorMessage title:NSLocalizedString(@"Error", nil)];
    }
  } else if(operation.HTTPRequestOperation.response.statusCode == 500) {
    [WToast showWithText:@"Communication error, please try again later."];
  } else if(operation.HTTPRequestOperation.response.statusCode == 404) {
    [WToast showWithText:@"Communication error, please try again later."];
  }
}

- (BOOL)isSuccessStatusFromServer:(RKObjectRequestOperation *)operation {
  MSLog(@"response from server: %@", operation.mappingResult);
  if([operation.mappingResult.dictionary allKeys].count > 0) {
    return YES;
  }
  //  [DELEGATE hideLoadingIndicator];
  return NO;
}

- (void)removeResponseDescriptor:(RKResponseDescriptor *)responseDescriptor andRequestDescriptor:(RKRequestDescriptor *)requestDescriptor forRKObjectManager:(RKObjectManager *)manager {
  if (responseDescriptor != nil) {
    [manager removeResponseDescriptor:responseDescriptor];
  }
  
  if (requestDescriptor != nil) {
    [manager removeRequestDescriptor:requestDescriptor];
  }
}

- (void)cancelAllRequestOperation {
  //  [DELEGATE hideLoadingIndicator];
  if(self.isOperationInProgress == NO) {
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
  }
}

@end

