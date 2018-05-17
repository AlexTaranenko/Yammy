//
//  ServicesTableViewCell.h
//  Yammy
//
//  Created by Alex on 4/17/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kServicesCellIdentifier = @"servicesCell";

@interface ServicesTableViewCell : UITableViewCell

- (void)prepareServicesCellByServicesMapping:(ServicesMapping *)mapping isSelected:(BOOL)isSelected;

- (void)prepareServicesCellByGiftMapping:(GiftMapping *)mapping;

@end
