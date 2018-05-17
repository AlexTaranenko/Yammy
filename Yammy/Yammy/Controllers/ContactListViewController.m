//
//  ContactListViewController.m
//  Yammy
//
//  Created by Alex on 06.10.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactListTableViewCell.h"
#import "ProfileViewController.h"

@interface ContactListViewController ()<UITableViewDelegate, UITableViewDataSource, ContactListTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *contactsArray;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self loadContactsFromServer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)loadContactsFromServer {
  if (self.contactsArray.count == 0) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] getContactsWitchCompletion:^(NSArray *contactsArray, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (contactsArray) {
        self.contactsArray = contactsArray;
        [self.tableView reloadData];
      }
    }];
  }
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ContactListTableViewCell *contactListCell = [tableView dequeueReusableCellWithIdentifier:kContactListCellIdentifier];
  contactListCell.delegate = self;
  ContactMapping *contactMapping = [self.contactsArray objectAtIndex:indexPath.row];
  contactListCell.contactMapping = contactMapping;
  [contactListCell prepareContactCellByContactMapping:contactMapping];
  
  return contactListCell;
}

#pragma mark - Delegate

- (void)updateTableViewCell:(UITableViewCell *)cell {
  [self.tableView beginUpdates];
  [self.tableView endUpdates];
}

- (void)editContactByContactMapping:(ContactMapping *)contactMapping {
  [self updateContactByMapping:contactMapping];
}

- (void)deleteContactByContactMapping:(ContactMapping *)contactMapping {
  [UIAlertHelper alert:@"Вы точно хотите удалить пользователя из контакт-листа?" title:@"Сообщение" cancelButton:@"Отменить" successButton:@"Удалить" successCompletion:^(UIAlertAction *action) {
    NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                             @"UserContactId" : contactMapping.IdContact
                             };
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] removeContactWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (status) {
        [self loadContactsFromServer];
      }
    }];
  }];
}

- (void)openProfileByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  ContactMapping *contactMapping = [self.contactsArray objectAtIndex:indexPath.row];
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = contactMapping.ContactUser;
  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark - Other methods

- (void)updateContactByMapping:(ContactMapping *)mapping {
  if (mapping.Note.length > 0 && mapping != nil) {
    NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                             @"UserContactId" : mapping.IdContact,
                             @"Note" : mapping.Note
                             };
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] updateContactWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (status) {
        [self loadContactsFromServer];
      }
    }];
  }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

