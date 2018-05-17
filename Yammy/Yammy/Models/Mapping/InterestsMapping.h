//
//  InterestsMapping.h
//  Yammy
//
//  Created by Alex on 12.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterestMapping : NSObject

@property (strong, nonatomic) NSNumber *IdInterest;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Group;

+ (RKObjectMapping *)objectMapping;

@end



@interface InterestsMapping : NSObject

@property (strong, nonatomic) NSString *Group;
@property (strong, nonatomic) NSArray *Items;

+ (RKObjectMapping *)objectMapping;

@end
