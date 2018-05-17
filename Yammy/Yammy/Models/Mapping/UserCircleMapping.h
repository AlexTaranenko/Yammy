//
//  UserCircleMapping.h
//  Yammy
//
//  Created by Alex on 13.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCircleMapping : NSObject

@property (strong, nonatomic) NSNumber *idUserCircle;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSNumber *circleType;
@property (strong, nonatomic) NSNumber *bezel;

+ (RKObjectMapping *)objectMapping;

@end
