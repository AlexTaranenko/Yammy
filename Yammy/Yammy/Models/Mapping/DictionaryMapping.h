//
//  GenderMapping.h
//  Yammy
//
//  Created by Alex on 11/21/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMapping.h"

@interface DictionaryMapping : NSObject

@property (strong, nonatomic) NSNumber *SexTyped;
@property (strong, nonatomic) NSNumber *IdDictionary;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *MaleFormatted;
@property (strong, nonatomic) NSString *FemaleFormatted;
@property (strong, nonatomic) ImageMapping *Icon;
@property (strong, nonatomic) ImageMapping *Image;
@property (strong, nonatomic) NSNumber *Cost;
@property (strong, nonatomic) NSNumber *Type;

+ (RKObjectMapping *)objectMapping;

@end

