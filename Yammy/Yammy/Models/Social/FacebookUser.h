//
//  FacebookUser.h
//  Yammy
//
//  Created by Alex on 09.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *profileURL;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

- (id)initWithDictionary:(NSDictionary *)infos;

@end
