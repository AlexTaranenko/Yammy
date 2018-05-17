//
//  TwitterUser.h
//  Yammy
//
//  Created by Alex on 10.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *profileURL;
@property (strong, nonatomic) NSString *hometown;

- (instancetype)initWithDictionary:(NSDictionary *)user;

@end
