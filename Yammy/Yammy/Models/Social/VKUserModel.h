//
//  VKUser.h
//  Yammy
//
//  Created by Alex on 8/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKUserModel : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *bdate;
@property (strong, nonatomic) NSNumber *idUser;
@property (strong, nonatomic) NSString *homePhone;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong, nonatomic) NSString *photo_100;
@property (strong, nonatomic) NSString *photo_200_orig;
@property (strong, nonatomic) NSString *photo_max;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
