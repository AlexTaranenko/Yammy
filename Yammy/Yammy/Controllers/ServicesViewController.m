//
//  ServicesViewController.m
//  Yammy
//
//  Created by Alex on 10/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ServicesViewController.h"
#import "ServicesTableViewCell.h"

typedef enum : NSUInteger {
  ServicesControlTag = 10,
  PackageControlTag,
} ControlTag;

@interface ServicesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *linesArray;
@property (strong, nonatomic) IBOutletCollection(UIControl) NSArray *arrayControls;

@property (strong, nonatomic) NSArray *giftsArray;
@property (strong, nonatomic) NSArray *servicesArray;
@property (strong, nonatomic) NSArray *userServicesArray;

@property (assign, nonatomic) BOOL isActivated;

@property (assign, nonatomic) ControlTag selectControlTag;

@end

@implementation ServicesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Биллинг и платежи";
  
  self.selectControlTag = ServicesControlTag;
  [self prepareButtonBySelectTag:self.selectControlTag];
  
  [self prepareBackBarButtonItem];
  
  self.balanceLabel.text = [NSString stringWithFormat:@"%ld", (long)[[ServerManager sharedManager].myProfileMapping.Balance integerValue]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadServicesFromServer];
}

#pragma mark - Private

- (void)prepareButtonBySelectTag:(ControlTag)controlTag {
  for (UIControl *control in self.arrayControls) {
    NSInteger index = [self.arrayControls indexOfObject:control];
    UIView *line = [self.linesArray objectAtIndex:index];
    control.tag = 10 + index;
    if (control.tag == controlTag) {
      line.backgroundColor = RGB(249, 0, 64);
    } else {
      line.backgroundColor = [UIColor clearColor];
    }
  }
}

- (void)loadServicesFromServer {
  dispatch_group_t group = dispatch_group_create();
  [Helpers showSpinner];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getUserServicesWithCompletion:^(NSArray *servicesArray, NSString *errorMessage) {
    self.userServicesArray = servicesArray;
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getServicesWithCompletion:^(NSArray *servicesArray, NSString *errorMessage) {
    self.servicesArray = servicesArray;
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getAllGiftsWithType:CoinsType WithCompletion:^(NSArray *giftsArray, NSString *errorMessage) {
    self.giftsArray = giftsArray;
    dispatch_group_leave(group);
  }];
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    [Helpers hideSpinner];
  });
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.selectControlTag == ServicesControlTag) {
    return self.servicesArray.count;
  } else {
    return self.giftsArray.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ServicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServicesCellIdentifier];
  
  if (self.selectControlTag == ServicesControlTag) {
    ServicesMapping *mapping = [self.servicesArray objectAtIndex:indexPath.row];
    if ([self filterUserServicesByMapping:mapping]) {
      [cell prepareServicesCellByServicesMapping:mapping isSelected:YES];
    } else {
      [cell prepareServicesCellByServicesMapping:mapping isSelected:NO];
    }
  } else {
    GiftMapping *giftMapping = [self.giftsArray objectAtIndex:indexPath.row];
    [cell prepareServicesCellByGiftMapping:giftMapping];
  }
  
  return cell;
}

- (BOOL)filterUserServicesByMapping:(ServicesMapping *)mapping {
  BOOL success = NO;
  
  for (UserServicesMapping *userServicesMapping in self.userServicesArray) {
    if ([mapping.ServiceId integerValue] == [userServicesMapping.ServiceId integerValue]) {
      success = YES;
      break;
    }
  }
  
  return  success;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectControlTag == ServicesControlTag) {
    ServicesMapping *mapping = [self.servicesArray objectAtIndex:indexPath.row];
    if ([self filterUserServicesByMapping:mapping]) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] disableServicesByServiceId:mapping.ServiceId withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (responseStatusModel.localized != nil) {
          [UIAlertHelper alert:responseStatusModel.localized title:responseStatusModel.errorMessage];
        } else {
          [self loadServicesFromServer];
        }
      }];
    } else {
      [Helpers showSpinner];
      [[ServerManager sharedManager] enableServicesByServiceId:mapping.ServiceId withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (responseStatusModel.localized != nil) {
          [UIAlertHelper alert:responseStatusModel.localized title:responseStatusModel.errorMessage];
        } else {
          [self loadServicesFromServer];
        }
      }];
    }
  } else {
    
  }
}

#pragma mark - Delegate

- (void)reloadAllServices {
  [self loadServicesFromServer];
  self.isActivated = YES;
}

#pragma mark - Action

- (IBAction)controlDidTap:(UIControl *)sender {
  self.selectControlTag = sender.tag;
  [self prepareButtonBySelectTag:self.selectControlTag];
  [self.tableView reloadData];
}

- (void)backButtonDidTap:(UIButton *)sender {
  if (self.isActivated) {
    if (self.delegate != nil) {
      [self.delegate reloadMyPublicProfileServices];
    }
  }
  
  [self.navigationController popViewControllerAnimated:YES];
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

