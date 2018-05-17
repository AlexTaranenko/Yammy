//
//  ContactMapping.h
//  Yammy
//
//  Created by Alex on 12/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileMapping.h"

@interface ContactMapping : NSObject

@property (strong, nonatomic) NSNumber *IdContact;
@property (strong, nonatomic) NSNumber *UserId;
@property (strong, nonatomic) NSNumber *ContactUserId;
@property (strong, nonatomic) NSNumber *LinkedOn;
@property (strong, nonatomic) NSString *Note;
@property (strong, nonatomic) ProfileMapping *ContactUser;

+ (RKObjectMapping *)objectMapping;

@end

