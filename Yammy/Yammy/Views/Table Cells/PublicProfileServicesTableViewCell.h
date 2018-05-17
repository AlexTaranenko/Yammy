//
//  PublicProfileServicesTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kPublicProfileServicesCellIdentifier = @"publicProfileServicesCell";

@protocol PublicProfileServicesTableViewCellDelegate <NSObject>

- (void)reloadAllServices;

@end

@interface PublicProfileServicesTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PublicProfileServicesTableViewCellDelegate> delegate;

- (void)prepareTitleLabelByText:(NSString *)textForLabel;

- (void)setupCollectionViewTag:(NSInteger)tag;

- (void)prepareUserServicesByArray:(NSArray *)userServicesArray;

- (void)prepareServicesByArray:(NSArray *)servicesArray;

@end

