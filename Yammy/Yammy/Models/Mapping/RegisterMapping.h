//
//  RegisterMapping.h
//  Yammy
//
//  Created by Alex on 24.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterMapping : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSNumber *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *localized;

+ (RKObjectMapping *)objectMapping;

@end

