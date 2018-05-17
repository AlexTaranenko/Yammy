//
//  AllMoreTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kAllMoreCellIdentifier = @"allMoreCell";

@interface AllMoreTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dictionary;

- (void)hiddenLabel:(BOOL)hidden;

- (void)preparePhotoImageBorder;

@end

