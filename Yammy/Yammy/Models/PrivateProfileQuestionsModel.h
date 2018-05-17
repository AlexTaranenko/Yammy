//
//  PrivateProfileQuestionsModel.h
//  Yammy
//
//  Created by Alex on 16.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrivateProfileMapping.h"

@interface PrivateProfileQuestionsModel : NSObject

@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *answer;

- (instancetype)initWithQuestion:(NSString *)question andAnswer:(NSString *)answer;

+ (NSArray *)prepareGeneralInfoByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping withProfileMapping:(ProfileMapping *)profileMapping;

+ (NSArray *)preparePrivateInterestsByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping withProfileMapping:(ProfileMapping *)profileMapping;

@end
