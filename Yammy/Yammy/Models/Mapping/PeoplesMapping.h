//
//  PeoplesMapping.h
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdMapping.h"

@interface PeoplesMapping : NSObject

@property (strong, nonatomic) NSArray *Profiles;
@property (strong, nonatomic) MatchMapping *Match;
@property (strong, nonatomic) AdMapping *Ad;

+ (RKObjectMapping *)objectMapping;

@end
