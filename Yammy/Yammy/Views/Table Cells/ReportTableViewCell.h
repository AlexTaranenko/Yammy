//
//  ReportTableViewCell.h
//  Yammy
//
//  Created by Alex on 1/18/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportModel.h"

static NSString *const kReportTableViewCellIdentifier = @"reportCell";

@interface ReportTableViewCell : UITableViewCell

- (void)prepareReportCellByModel:(ReportModel *)model andSelect:(BOOL)select;

@end

