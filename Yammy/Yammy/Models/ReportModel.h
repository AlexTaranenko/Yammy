//
//  ReportModel.h
//  Yammy
//
//  Created by Alex on 1/18/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  NoneType,
  AnotherPhotoType,
  SpamType,
  OtherType
} TypeReport;

@interface ReportModel : NSObject

@property (strong, nonatomic) NSString *titleReport;

@property (strong, nonatomic) NSString *messageReport;

@property (assign, nonatomic) TypeReport typeReport;

- (instancetype)initWithTitle:(NSString *)title withTypeReport:(TypeReport)typeReport withMessage:(NSString *)message;

@end

