//
//  ActivityLineStatsMapping.h
//  Yammy
//
//  Created by Alex on 12/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityLineStatsMapping : NSObject

@property (strong, nonatomic) NSNumber *All;
@property (strong, nonatomic) NSNumber *Chats;
@property (strong, nonatomic) NSNumber *Likes;
@property (strong, nonatomic) NSNumber *Matches;

+ (RKObjectMapping *)objectMapping;

@end

