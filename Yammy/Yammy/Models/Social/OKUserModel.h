//
//  OKUserModel.h
//  Yammy
//
//  Created by Alex on 16.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OKUserModel : NSObject

@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSNumber *uid;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
