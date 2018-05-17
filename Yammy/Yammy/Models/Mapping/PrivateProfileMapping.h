//
//  PrivateProfileMapping.h
//  Yammy
//
//  Created by Alex on 11/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMapping.h"

@interface PrivateProfileMapping : NSObject

@property (strong, nonatomic) NSNumber *UserId;
@property (strong, nonatomic) NSNumber *IsHidden;
@property (strong, nonatomic) NSString *NickName;
@property (strong, nonatomic) NSNumber *GeneralInfoHidden;
@property (strong, nonatomic) NSString *FirstSexWith;
@property (strong, nonatomic) NSString *FirstSexWhen;
@property (strong, nonatomic) NSString *FirstSexWhere;
@property (strong, nonatomic) NSString *ReadyToNewSexHorizons;
@property (strong, nonatomic) NSString *PenisLengthOrBreastSize;
@property (strong, nonatomic) NSNumber *PrivateInterestsHidden;
@property (strong, nonatomic) NSString *HaveFilmedHomeSex;
@property (strong, nonatomic) NSString *ReadyToFirstSex;
@property (strong, nonatomic) NSString *SexPassions;
@property (strong, nonatomic) NSString *SexFrequency;
@property (strong, nonatomic) NSString *VirtualSex;
@property (strong, nonatomic) NSNumber *PrivatePreferencesHidden;
@property (strong, nonatomic) ImageMapping *PrimaryPhoto;
@property (strong, nonatomic) NSArray *Photos;
@property (strong, nonatomic) NSArray *PrivatePreferences;
@property (strong, nonatomic) NSNumber *IsBlocked;

+ (RKObjectMapping *)objectMapping;

@end

