//
//  DetailSettingsModel.m
//  Yammy
//
//  Created by Alex on 3/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "DetailSettingsModel.h"

@implementation DetailSettingsModel

- (instancetype)initWithTitle:(NSString *)title withDescription:(NSString *)description andIsOn:(BOOL)isOn andType:(DetailSettingsType)type {
  self = [super init];
  
  if (self) {
    self.titleDetailSettings = title;
    self.descriptionDetailSettings = description;
    self.isOnDetailSettings = isOn;
    self.type = type;
  }
  
  return self;
}

@end
