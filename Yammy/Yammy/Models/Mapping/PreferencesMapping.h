//
//  PreferencesMapping.h
//  Yammy
//
//  Created by Alex on 11/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMapping.h"

@interface PreferencesMapping : NSObject

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSNumber *IdPreferences;
@property (strong, nonatomic) ImageMapping *Icon;

+ (RKObjectMapping *)objectMapping;

@end

