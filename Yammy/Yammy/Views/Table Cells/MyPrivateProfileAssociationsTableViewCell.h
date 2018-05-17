//
//  MyPrivateProfileAssociationsTableViewCell.h
//  Yammy
//
//  Created by Alex on 21.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTitlePrivateProfileModel.h"

static NSString *const kMyPrivateProfileAssociationsCellIdentifier = @"myPrivateProfileAssociationsCell";

@protocol MyPrivateProfileAssociationsTableViewCellDelegate <NSObject>

- (void)presentAssociationsVC;

- (void)showHidePrivateAssociation:(UITableViewCell *)cell;

@end

@interface MyPrivateProfileAssociationsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MyPrivateProfileAssociationsTableViewCellDelegate> delegate;

- (void)prepareCollectionViewByPreferencesArray:(NSArray *)preferencesArray;

- (void)prepareHideShowButton:(MyTitlePrivateProfileModel *)myTitlePrivateProfileModel;

@end
