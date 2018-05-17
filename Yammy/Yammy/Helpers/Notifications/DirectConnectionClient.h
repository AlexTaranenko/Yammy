//
//  DirectConnectionClient.h
//  Yammy
//
//  Created by Paul Yevchenko on 16/12/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalR.h"

@interface DirectConnectionClient : NSObject<SRConnectionDelegate>

+ (instancetype)shared;

- (void)connect;

- (void)disconnect;

@end

