//
//  ImageMapping.h
//  Yammy
//
//  Created by Alex on 9/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMapping : NSObject

@property (strong, nonatomic) NSNumber *IdImage;
@property (strong, nonatomic) NSString *Url;

+ (RKObjectMapping *)objectMapping;

@end

