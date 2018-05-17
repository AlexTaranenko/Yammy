//
//  AdMapping.h
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  Default = 0,
  MotivationUploadYourPhoto,
  MotivationFillYourPublicProfile,
  MotivationFillYourPrivateProfile,
  MotivationBuyYaMax,
  MotivationBuyYaStar,
  MotivationBuyInvisibility,
  MotivationBuyTranslator,
  MotivationVerifyYourAccount,
  MotivationBecomeModerator
} AdTypes;

@interface AdMapping : NSObject

@property (strong, nonatomic) NSNumber *Type;

+ (RKObjectMapping *)objectMapping;

@end

