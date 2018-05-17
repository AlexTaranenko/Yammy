//
//  PrivateProfileAssociationsTableViewCell.h
//  Yammy
//
//  Created by Alex on 9/14/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kPrivateProfileAssociationsCellIdentifier = @"privateProfileAssociationsCell";

@protocol PrivateProfileAssociationsTableViewCellDelegate <NSObject>

@optional
- (void)pushToChat;

@end

@interface PrivateProfileAssociationsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PrivateProfileAssociationsTableViewCellDelegate> delegate;

- (void)prepareCollectionViewByPreferencesArray:(NSArray *)preferencesArray;

- (void)addMappingToCollectionView:(PrivateProfileMapping *)privateProfileMapping;

@end
