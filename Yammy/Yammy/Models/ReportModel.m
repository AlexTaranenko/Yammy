//
//  ReportModel.m
//  Yammy
//
//  Created by Alex on 1/18/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ReportModel.h"

@implementation ReportModel

- (instancetype)initWithTitle:(NSString *)title withTypeReport:(TypeReport)typeReport withMessage:(NSString *)message {
  self = [super init];
  
  if (self) {
    self.titleReport = title;
    self.typeReport = typeReport;
    self.messageReport = message;
  }
  
  return self;
}

@end

