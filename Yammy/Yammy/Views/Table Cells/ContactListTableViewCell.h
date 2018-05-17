//
//  ContactListTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/11/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kContactListCellIdentifier = @"contactListCell";

@protocol ContactListTableViewCellDelegate <NSObject>

- (void)updateTableViewCell:(UITableViewCell *)cell;

- (void)editContactByContactMapping:(ContactMapping *)contactMapping;

- (void)deleteContactByContactMapping:(ContactMapping *)contactMapping;

- (void)openProfileByCell:(UITableViewCell *)cell;

@end

@interface ContactListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ContactListTableViewCellDelegate> delegate;

@property (strong, nonatomic) ContactMapping *contactMapping;

- (void)prepareContactCellByContactMapping:(ContactMapping *)contactMapping;

@end

