//
//  MyTitlePrivateProfileModel.m
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MyTitlePrivateProfileModel.h"

@implementation MyTitlePrivateProfileModel

- (instancetype)initWithTitle:(NSString *)title withIsShowInfo:(NSNumber *)isShowInfo {
  self = [super init];
  
  if (self) {
    self.title = title;
    self.isShowInfo = isShowInfo;
    self.titleButton = [isShowInfo integerValue] == HideInfoMyTitlePrivateProfile ? @"Скрыть" : @"Открыть";
  }
  
  return self;
}

- (NSNumber *)updateShowInfoByNumberOfBlock:(NSInteger)numberOfBlock andPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  switch (numberOfBlock) {
    case GallaryTitleBlock:
      return privateProfileMapping.IsHidden; break;
      
    case TotalInfoTitleBlock:
      return privateProfileMapping.GeneralInfoHidden; break;
      
    case PrivateInterestTitleBlock:
      return privateProfileMapping.PrivateInterestsHidden; break;
      
    case PrivateAssociationTitleBlock:
      return privateProfileMapping.PrivatePreferencesHidden; break;
      
    default: return @(0); break;
  }
}

- (void)updateTitleButtonByIsShowInfo:(NSNumber *)isShowInfo {
  self.titleButton = [isShowInfo integerValue] == HideInfoMyTitlePrivateProfile ? @"Скрыть" : @"Открыть";
}

@end

