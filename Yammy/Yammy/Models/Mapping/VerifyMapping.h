//
//  VerifyMapping.h
//  Yammy
//
//  Created by Alex on 5/14/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyMapping : NSObject

@property (strong, nonatomic) NSNumber *IdVerify;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) ImageMapping *Image;

+ (RKObjectMapping *)objectMapping;

@end
