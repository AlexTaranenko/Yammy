//
//  ResKitClient.h
//  Chiroway
//
//  Created by applegod on 23.12.13.
//  Copyright (c) 2013 a.molchanovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void ( ^OnRequestSuccess ) ( RKObjectRequestOperation *operation );

typedef void ( ^OnRequestFailed ) (RKObjectRequestOperation *operation, NSError *error );

@interface RestKitClient : NSObject

@property (nonatomic, assign) BOOL isOperationInProgress;

+ (RestKitClient*) sharedClient;

- (void)requestWithMethod:(RKRequestMethod)method
						objectManager:(RKObjectManager*)objectManager
									 object:(id)object
										 path:(NSString *)path
							 parameters:(NSDictionary *)parameters
					responseMapping:(RKMapping *)responseMapping
					 requestMapping:(RKMapping *)requestMapping
					responseKeyPath:(NSString*)responseKeyPath
					requestKeyPath:(NSString*)requestKeyPath
									success:(OnRequestSuccess)success
									failure:(OnRequestFailed)failure;

- (void)inspectErrorFromServerForOperation:(RKObjectRequestOperation *)operation;

- (BOOL)isSuccessStatusFromServer:(RKObjectRequestOperation *)operation;

- (void)setupRestKitMapping;

- (void)cancelAllRequestOperation;

@end
