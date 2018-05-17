//
//  StringMapping.h
//  Yammy
//
//  Created by Alex on 24.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringMapping : NSObject

@property (strong, nonatomic) NSString *text;

+ (RKObjectMapping *)objectMapping;

@end
