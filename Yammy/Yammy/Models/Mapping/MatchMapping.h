//
//  MatchMapping.h
//  Yammy
//
//  Created by Alex on 12/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileMapping.h"

@interface MatchMapping : NSObject

@property (strong, nonatomic) NSNumber *IdMatch;
@property (strong, nonatomic) NSNumber *FromUserId;
@property (strong, nonatomic) NSNumber *ToUserId;
@property (strong, nonatomic) NSNumber *Status;
@property (strong, nonatomic) NSNumber *EventDate;
@property (strong, nonatomic) ProfileMapping *ToUser;
@property (strong, nonatomic) ProfileMapping *FromUser;
@property (strong, nonatomic) NSNumber *EventStatusTyped;
@property (strong, nonatomic) NSNumber *EventTypeTyped;
@property (strong, nonatomic) NSArray *PrivatePreferences;
@property (strong, nonatomic) NSString *SubTitle;
@property (strong, nonatomic) NSString *Title;

+ (RKObjectMapping *)objectMapping;

@end

