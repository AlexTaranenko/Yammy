//
//  LanguageMapping.h
//  Yammy
//
//  Created by Alex on 01.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageMapping : NSObject

@property (strong, nonatomic) NSNumber *IdLanguage;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSNumber *LCID;
@property (strong, nonatomic) NSString *EnglishName;
@property (strong, nonatomic) NSString *NativeName;
@property (strong, nonatomic) NSNumber *Rank;
@property (strong, nonatomic) NSNumber *ParentLanguageId;
@property (strong, nonatomic) NSNumber *Enabled;

+ (RKObjectMapping *)objectMapping;

@end
