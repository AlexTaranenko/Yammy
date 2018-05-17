//
//  ServerManager.m
//  Yammy
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ServerManager.h"
#import "NotificationsHelper.h"

@implementation ServerManager

+ (ServerManager *)sharedManager {
  
  static ServerManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [ServerManager new];
  });
  
  return sharedInstance;
}

- (ResponseStatusModel *)errorStatusModelByOperation:(RKObjectRequestOperation *)operation {
  NSArray * errorArray =  [operation.error.userInfo objectForKey:RKObjectMapperErrorObjectsKey];
  ResponseStatusModel *errorModel = errorArray.firstObject;
  return errorModel;
}

// Register user
- (void)registerUserWithParams:(NSDictionary *)params withFileData:(NSData *)fileData withCompletion:(RegisterUserBlock)completion {
  
  RKObjectManager *manager = [RKObjectManager sharedManager];
  NSMutableURLRequest *request = [manager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:REGISTER parameters:params constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
    if (fileData != nil) {
      [formData appendPartWithFileData:fileData name:@"PrimaryPhoto" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
    }
  }];
  
  RKResponseDescriptor * descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RegisterMapping objectMapping] method:RKRequestMethodPOST pathPattern:REGISTER keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [manager addResponseDescriptor:descriptor];
  
  RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [manager removeResponseDescriptor:descriptor];
    RegisterMapping *registerMapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    [[NotificationsHelper shared] checkSubscription];
    completion(registerMapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    [errorModel setupRegisterErrorsByResponse:operation.HTTPRequestOperation.responseData];
    completion(nil, errorModel);
  }];
  
  [manager enqueueObjectRequestOperation:operation];
}

// Login user
- (void)loginUserWithParams:(NSDictionary *)params withCompletion:(LoginUserBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:LOGIN parameters:params responseMapping:[RegisterMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    RegisterMapping *registerMapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    [[NotificationsHelper shared] checkSubscription];
    completion(registerMapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}


// Subscribe Notifications
- (void)subscribeNotificationsWithParams:(NSDictionary *)params withCompletion:(SubscribeNotificationsBlock)completion
{
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil
                                             path:SUBSCRIBE_NOTIFICATIONS parameters:params
                                  responseMapping:[ResponseStatusModel objectMapping]
                                   requestMapping:nil responseKeyPath:nil requestKeyPath:nil
                                          success:^(RKObjectRequestOperation *operation)
   {
     ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
     completion([status.dataSuccess boolValue], nil);
   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
     completion(nil, errorModel.errorMessage);
   }];
}


// Get dictionary of list
- (void)getDictionaryOfListByPath:(NSString *)path withCompletion:(DictionaryBlock)completion {
  NSDictionary *params = nil;
  if ([Helpers getAccessToken].length > 0) {
    params = @{@"Token" : [Helpers getAccessToken]};
  }
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:path parameters:params responseMapping:[DictionaryMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get Gender List
- (void)getGenderListForInterestedIn:(BOOL)forInterestedIn withCompletion:(DictionaryBlock)completion {
  NSDictionary *params = nil;
  if ([Helpers getAccessToken].length > 0) {
    params = @{@"Token" : [Helpers getAccessToken], @"ForInterestedIn" : [NSNumber numberWithBool:forInterestedIn]};
  }

  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:GENDER_LIST parameters:params responseMapping:[DictionaryMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get profile
- (void)getProfileById:(NSNumber *)idProfile withCompletion:(ProfileBlock)completion {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken] ?: @"",
                           @"Id" : idProfile ?: @(0)
                           };
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:PROFILE_VIEW parameters:params responseMapping:[ProfileMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ProfileMapping *mapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(mapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}
// Get private profile
- (void)getPrivateProfileById:(NSNumber *)idProfile wirhCompletion:(PrivateProfileBlock)completion {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"Id" : idProfile ?: @(0)
                           };
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:PROFILE_PRIVATE_VIEW parameters:params responseMapping:[PrivateProfileMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    PrivateProfileMapping *privateProfileMapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(privateProfileMapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Update private profile
- (void)updatePrivateProfileWithParams:(NSDictionary *)params withCompletion:(UpdatePrivateProfileBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:UPDATE_PROFILE_PRIVATE_VIEW parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Upload photo
- (void)uploadImageToServerByData:(NSData *)fileData withPath:(NSString *)path withCompletion:(UploadPhotoBlock)completion {
  
  RKObjectManager *manager = [RKObjectManager sharedManager];
  NSMutableURLRequest *request = [manager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:path parameters:@{@"Token" : [Helpers getAccessToken]} constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
    [formData appendPartWithFileData:fileData name:@"Photos" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
  }];
  
  RKResponseDescriptor * descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ResponseStatusModel objectMapping] method:RKRequestMethodPOST pathPattern:path keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [manager addResponseDescriptor:descriptor];
  
  RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [manager removeResponseDescriptor:descriptor];
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    [manager removeResponseDescriptor:descriptor];
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [operation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
      float progress = ((float)totalBytesWritten / (float)totalBytesExpectedToWrite);
      if (progress < 1.f) {
        [Helpers showSpinnerWithProgress:((float)totalBytesWritten / (float)totalBytesExpectedToWrite)];
      } else {
        [Helpers hideSpinner];
      }
    }];
  });
  
  [manager enqueueObjectRequestOperation:operation];
}

// Get language list
- (void)getLanguageListWithCompletion:(LanguageListBlock)completion {
  NSDictionary *params = nil;
  if ([Helpers getAccessToken] != nil) {
    params = @{@"Token" : [Helpers getAccessToken]};
  }
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:LANGUAGE_LIST parameters:params responseMapping:[LanguageMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Update profile
- (void)updateProfileWithParams:(NSDictionary *)params withCompletion:(UpdateProfileBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:UPDATE_PROFILE_VIEW parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get interests
- (void)getInterestsWithCompletion:(InterestsBlock)completion {
  NSDictionary *params = nil;
  if ([Helpers getAccessToken] != nil) {
    params = @{@"Token" : [Helpers getAccessToken]};
  }
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:params path:INTEREST_LIST parameters:params responseMapping:[InterestsMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Avatar photo
- (void)setupAvatarPhotoWithParams:(NSDictionary *)params withCompletion:(AvatarPhotoBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:AVATAR_PHOTO parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Delete photo
- (void)deletePhotoWithParams:(NSDictionary *)params withCompletion:(DeletePhotoBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:DELETE_PHOTO parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Move photo
- (void)movePhotoToProfileWithParams:(NSDictionary *)params andPath:(NSString *)path withCompletion:(MovePhotoBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:path parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get my gifts
- (void)getMyGiftsWithParams:(NSDictionary *)params withCompletion:(GiftsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:MY_GIFTS parameters:params responseMapping:[MyGiftMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get contacts
- (void)getContactsWitchCompletion:(ContactsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:CONTACTS_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ContactMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// User circles
- (void)searchDefaultWithCompletion:(SearchDefaultBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:SEARCH_DEFAULT parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[PeoplesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *peoplesArray = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(peoplesArray, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Add contact
- (void)addContactToBookmarkByUserId:(NSNumber *)userId withCompletion:(ContactBlock)completion {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  if (userId != nil) {
    [mutDict setObject:userId forKey:@"UserId"];
  }
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CONTACTS_ADD parameters:mutDict responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Remove contact
- (void)removeContactWithParams:(NSDictionary *)params withCompletion:(ContactBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CONTACTS_REMOVE parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Update contact
- (void)updateContactWithParams:(NSDictionary *)params withCompletion:(ContactBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CONTACTS_UPDATE parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get preferences
- (void)getPreferenceswithCompletion:(PreferencesBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:PRIVATE_PREFERENCES_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[PreferencesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get likes
- (void)getLikesListWithParams:(NSDictionary *)params withCompletion:(LikesListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:LIKES_LIST parameters:params responseMapping:[LikeMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Send Like
- (void)sendLikeWithParams:(NSDictionary *)params withCompletion:(LikesSendBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:LIKES_SEND parameters:params responseMapping:[MatchMapping  objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    MatchMapping *mapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    if (mapping.IdMatch == nil) {
      NSData *data = [operation.HTTPRequestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      id dataDict = [json objectForKey:@"data"];
      if ([dataDict isKindOfClass:[NSNull class]]) {
        completion(mapping, nil, nil);
      } else {
        NSNumber *code = [dataDict objectForKey:@"code"];
        NSString *localized = [dataDict objectForKey:@"localized"];
        completion(mapping, code, localized);
      }
    } else {
      completion(mapping, nil, nil);
    }
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, nil, errorModel.errorMessage);
  }];
}

// Matches list
- (void)getMatchesWithParams:(NSDictionary *)params wihCompletion:(MatchesListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:MATCHES_LIST parameters:params responseMapping:[MatchMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get activity lines
- (void)getActivityLinesWithParams:(NSDictionary *)params withCompletion:(ActivityLinesListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:ACTIVITY_LINE_LIST parameters:params responseMapping:[ActivityLinesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get all gifts
- (void)getAllGiftsWithType:(GiftType)giftType WithCompletion:(GiftsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:GIFTS_LIST parameters:@{@"Token" : [Helpers getAccessToken], @"Type" : @(giftType)} responseMapping:[GiftMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Send Gift
- (void)sendGiftWithParams:(NSDictionary *)params withCompletion:(SendGiftBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:SEND_GIFT parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    if ([status.code integerValue] >= 500) {
      if ([status.code integerValue] == 530) {
        self.forbiddenBlock(status.localized);
      } else {
        completion(NO, status.localized);
      }
    } else {
      completion(YES, nil);
    }
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Search General
- (void)searchGeneralWithParams:(NSDictionary *)params withCompletion:(SearchDefaultBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:SEARCH_GENERAL parameters:params responseMapping:[PeoplesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Search Preferences
- (void)searchPreferencesWithParams:(NSDictionary *)params withCompletion:(SearchDefaultBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:SEARCH_PREFERENCES parameters:params responseMapping:[PeoplesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get locations list
- (void)getLocationListWithCompletion:(LocationListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:LOCATIONS_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[CountryMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get Hot Page list
- (void)getHotPageListWithCompletion:(HotPageListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:HOT_PAGE_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[PeoplesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    PeoplesMapping *peoplesMapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(peoplesMapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get Activity stats
- (void)getActivityLineStatsWithCompletion:(ActivityLineStatsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:ACTIVITY_LINE_STATS parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ActivityLineStatsMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ActivityLineStatsMapping *activityLineStatsMapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(activityLineStatsMapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get services
- (void)getServicesWithCompletion:(ServicesListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:SERVICES_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ServicesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get user services
- (void)getUserServicesWithCompletion:(ServicesListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:USER_SERVICES_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[UserServicesMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Enable services
- (void)enableServicesByServiceId:(NSNumber *)serviceId withCompletion:(ServicesEnableBlock)completion {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  if (serviceId != nil) {
    [mutDict setObject:serviceId forKey:@"ServiceId"];
  }
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:SERVICES_ENABLE parameters:mutDict responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Disable services
- (void)disableServicesByServiceId:(NSNumber *)serviceId withCompletion:(ServicesEnableBlock)completion {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  if (serviceId != nil) {
    [mutDict setObject:serviceId forKey:@"UserServiceId"];
  }
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:SERVICES_DISABLE parameters:mutDict responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Block user
- (void)blockUserByUserId:(NSNumber *)userId withCompletion:(BlockUserBlock)completion {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  if (userId != nil) {
    [mutDict setObject:userId forKey:@"Id"];
  }
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:PROFILES_BLOCK parameters:mutDict responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Confirm profile
- (void)confirmProfileWithParams:(NSDictionary *)params withCompletion:(ConfirmProfileBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:PROFILES_CONFIRM parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, [status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, nil, errorModel.errorMessage);
  }];
}

// Recover profile
- (void)recoverProfileWithParams:(NSDictionary *)params withCompletion:(RecoverProfileBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:PROFILES_RECOVER parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Change password
- (void)changePasswordWithParams:(NSDictionary *)params withCompletion:(ChangePasswordBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:PROFILES_NEW_PASSWORD parameters:params responseMapping:[RegisterMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    RegisterMapping *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel);
  }];
}

// Send report
- (void)sendReportWithParams:(NSDictionary *)params withCompletion:(ReportBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:PROFILES_REPORT parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Request private profile
- (void)requestPrivateProfileWithParams:(NSDictionary *)params withCompletion:(RequestPrivateProfileBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:REQUEST_PRIVATE_PROFILE parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Reply request
- (void)replyRequestWithParams:(NSDictionary *)params withCompletin:(ReplyRequestBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:REPLY_REQUEST parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Profile available
- (void)checkAvailableProfileWithParams:(NSDictionary *)params withCompletion:(ProfileAvailableBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:PROFILES_AVAILABLE parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Profile recover allowed
- (void)recoverAllowedProfileWithParams:(NSDictionary *)params withCompletion:(RecoverProfileBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:PROFILES_RECOVER_ALLOWED parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Sign Out
- (void)signOutByIsEveryWhere:(BOOL)everyWhere withCompletion:(SignOutBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:SIGN_OUT parameters:@{@"EveryWhere" : everyWhere ? @(1) : @(0)} responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Blocked profiles
- (void)getBlockedProfilesWithCompletion:(BlockedProfilesBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:BLOCKED_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ProfileMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Unblock user
- (void)unblockUserByIdUser:(NSNumber *)userId withCompletion:(UnBlockUserBlock)completion {
  NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"Token" : [Helpers getAccessToken]}];
  if (userId) {
    [mutDict setObject:userId forKey:@"Id"];
  }
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:UNBLOCK_USER parameters:mutDict responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Help topics
- (void)getHelpTopicsWithCompletion:(HelpTopicsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:HELP_TOPICS parameters:nil responseMapping:[HelpMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Help articles
- (void)getHelpArticlesByIdTopic:(NSNumber *)idTopic withCompletion:(HelpArticlesBlock)completion {
  if (idTopic) {
    [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:HELP_ARTICLES parameters:@{@"TopicId" : idTopic} responseMapping:[ArticleMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
      NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
      completion(items, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
      ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
      completion(nil, errorModel.errorMessage);
    }];
  }
}

// Group Stickers
- (void)getGroupStickersWithCompletion:(GroupStickersBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:GROUP_STICKERS parameters:nil responseMapping:[DictionaryMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Stickers
- (void)getStickersByDictionary:(DictionaryMapping *)dictionaryMapping withCompletion:(StickersBlock)completion {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"StickerGroupId" : dictionaryMapping.IdDictionary};
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:STICKERS_LIST parameters:params responseMapping:[DictionaryMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// User settings
- (void)getUserSettingsWithCompletion:(UserSettingsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:USER_SETTINGS parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[UserSettingsMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    UserSettingsMapping *mapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(mapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Set user settings
- (void)setUserSettingsWithParams:(NSDictionary *)params withCompletion:(SetUserSettingsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:USER_SETTINGS_SET parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *model = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion(model, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Clear profile data
- (void)clearProfileDataWithCompletion:(ClearBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CLEAR_DATA_PROFILE parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *model = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(model, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// User settings verifications
- (void)userSettingsVerifications {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:USER_SETTINGS_VERIFICATIONS parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:nil requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    
  }];
}

// User languages list
- (void)userLanguageListWithCompletion:(UserLanguagesBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:USER_LANGUAGES_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[LanguageMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// User language add
- (void)addUserLanguageWithParams:(NSDictionary *)params withCompletion:(UserLanguageBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:USER_LANGUAGES_ADD parameters:params responseMapping:nil requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    completion(YES, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(NO, errorModel.errorMessage);
  }];
}

// User language delete
- (void)deleteUserLanguageWithParams:(NSDictionary *)params withCompletion:(UserLanguageBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:USER_LANGUAGES_DELETE parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *model = [operation.mappingResult.dictionary objectForKey:@"data"];
    if (model.code != nil && [model.code integerValue] >= 500) {
      completion(NO, model.localized);
    } else {
      completion(YES, nil);
    }
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(NO, errorModel.errorMessage);
  }];
}

// Delete User
- (void)deleteUserWithCompletion:(UserDeleteBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:USER_DELETE parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    completion(YES, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(NO, errorModel.errorMessage);
  }];
}

// UnDelete User
- (void)unDeleteUserWithCompletion:(UserDeleteBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:USER_UNDELETE parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    completion(YES, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(NO, errorModel.errorMessage);
  }];
}

// Get Request Verifications
- (void)getRequestVerificationsWithCompletion:(VerifyBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:GET_REQUEST_VERIFICATIONS parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[VerifyMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    VerifyMapping *mapping = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(mapping, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);

  }];
}

// Verify Photo
- (void)verifyPhotoByImage:(UIImage *)image withMapping:(VerifyMapping *)verifyMapping withCompletion:(VerifyPhotoBlock)completion {
  NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"VerificationGestureId" : verifyMapping.IdVerify
                           };
  RKObjectManager *manager = [RKObjectManager sharedManager];
  NSMutableURLRequest *request = [manager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:VERIFY_PHOTO parameters:params constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:@"Image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
  }];
  RKResponseDescriptor * descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ResponseStatusModel objectMapping] method:RKRequestMethodPOST pathPattern:VERIFY_PHOTO keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [manager addResponseDescriptor:descriptor];
  
  RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [manager removeResponseDescriptor:descriptor];
    completion(YES, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    [manager removeResponseDescriptor:descriptor];
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(NO, errorModel.errorMessage);
  }];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [operation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
      float progress = ((float)totalBytesWritten / (float)totalBytesExpectedToWrite);
      if (progress < 1.f) {
        [Helpers showSpinnerWithProgress:((float)totalBytesWritten / (float)totalBytesExpectedToWrite)];
      } else {
        [Helpers hideSpinner];
      }
    }];
  });
  
  [manager enqueueObjectRequestOperation:operation];

}

/* Chat Block */

// Get chats
- (void)getChatsListWithCompletion:(ChatsBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:CHATS_LIST parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:[ChatListMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Get Messages
- (void)getMessagesWithParams:(NSDictionary *)params witnCompletion:(MessagesListBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:CHAT_ROOM parameters:params responseMapping:[MessageMapping objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSArray *items = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(items, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Send message
- (void)sendMessageWithParams:(NSDictionary *)params withCompletion:(SendMessageBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CHAT_SEND parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    [self completionMessageBlock:status withCompletion:completion];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Send image message
- (void)sendImageMessageWithParams:(NSDictionary *)params byImageData:(NSData *)imageData withCompletion:(SendMessageBlock)completion {
  
  RKObjectManager *manager = [RKObjectManager sharedManager];
  NSMutableURLRequest *request = [manager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:CHAT_SEND parameters:params constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:@"Image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
  }];
  RKResponseDescriptor * descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ResponseStatusModel objectMapping] method:RKRequestMethodPOST pathPattern:CHAT_SEND keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [manager addResponseDescriptor:descriptor];
  
  RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [manager removeResponseDescriptor:descriptor];
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    [self completionMessageBlock:status withCompletion:completion];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    [manager removeResponseDescriptor:descriptor];
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [operation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
      float progress = ((float)totalBytesWritten / (float)totalBytesExpectedToWrite);
      if (progress < 1.f) {
        [Helpers showSpinnerWithProgress:((float)totalBytesWritten / (float)totalBytesExpectedToWrite)];
      } else {
        [Helpers hideSpinner];
      }
    }];
  });
  
  [manager enqueueObjectRequestOperation:operation];
}

// Send gift message
- (void)sendGiftMessageWithParams:(NSDictionary *)params withCompletion:(SendMessageBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CHAT_SEND parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    [self completionMessageBlock:status withCompletion:completion];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Send audio message
- (void)sendAudioMessageWithParams:(NSDictionary *)params byFileData:(NSData *)fileData withCompletion:(SendMessageBlock)completion; {
  RKObjectManager *manager = [RKObjectManager sharedManager];
  NSMutableURLRequest *request = [manager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:CHAT_SEND parameters:params constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData) {
    [formData appendPartWithFileData:fileData name:@"Audio" fileName:@"Audio.aac" mimeType:@"audio/aac"];
  }];
  
  RKResponseDescriptor * descriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ResponseStatusModel objectMapping] method:RKRequestMethodPOST pathPattern:CHAT_SEND keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  [manager addResponseDescriptor:descriptor];
  
  RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [manager removeResponseDescriptor:descriptor];
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    [self completionMessageBlock:status withCompletion:completion];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    [manager removeResponseDescriptor:descriptor];
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [operation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
      float progress = ((float)totalBytesWritten / (float)totalBytesExpectedToWrite);
      if (progress < 1.f) {
        [Helpers showSpinnerWithProgress:((float)totalBytesWritten / (float)totalBytesExpectedToWrite)];
      } else {
        [Helpers hideSpinner];
      }
    }];
  });
  
  [manager enqueueObjectRequestOperation:operation];
}

// Clean chat
- (void)cleanChatByUserId:(NSNumber *)userId withCompletion:(CleanBlock)completion {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  if (userId != nil) {
    [mutDict setObject:userId forKey:@"WithUserId"];
  }
  
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CHATS_CLEAN parameters:mutDict responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:[NSNull null]];
    completion([status.dataSuccess boolValue], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

// Send Sticker
- (void)sendStickerWithParams:(NSDictionary *)params withCompletion:(SendStickerBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodPOST objectManager:[RKObjectManager sharedManager] object:nil path:CHAT_SEND parameters:params responseMapping:[ResponseStatusModel objectMapping] requestMapping:nil responseKeyPath:@"data" requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    ResponseStatusModel *status = [operation.mappingResult.dictionary objectForKey:@"data"];
    completion(status, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    ResponseStatusModel *errorModel = [self errorStatusModelByOperation:operation];
    completion(nil, errorModel.errorMessage);
  }];
}

- (void)completionMessageBlock:(ResponseStatusModel *)status withCompletion:(SendMessageBlock)completion {
  if ([status.code integerValue] >= 500) {
    if ([status.code integerValue] == 530) {
      self.forbiddenBlock(status.localized);
    } else if ([status.code integerValue] == 531) {
      self.chatMotivationBlock(@(531));
    } else {
      completion(NO, status.localized);
    }
  } else {
    completion(YES, nil);
  }
}

// Admin Chat Support
- (void)getUserAdminSupportWithCompletion:(AdminSupportBlock)completion {
  [[RestKitClient sharedClient] requestWithMethod:RKRequestMethodGET objectManager:[RKObjectManager sharedManager] object:nil path:CHAT_SUPPORT parameters:@{@"Token" : [Helpers getAccessToken]} responseMapping:nil requestMapping:nil responseKeyPath:nil requestKeyPath:nil success:^(RKObjectRequestOperation *operation) {
    NSData *data = [operation.HTTPRequestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"data"] != nil) {
      NSNumber *userId = [json objectForKey:@"data"];
      completion(userId, nil);
    } else {
      completion(nil, nil);
    }
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    completion(nil, error.localizedDescription);
  }];
}

/* Chat Block */

@end

