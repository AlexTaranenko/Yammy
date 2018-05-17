//
//  ReportViewController.m
//  Yammy
//
//  Created by Alex on 1/18/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewCell.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "ReportModel.h"
#import "UITextView+Placeholder.h"

@interface ReportViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) ReportModel *selectReportModel;

@property (strong, nonatomic) NSMutableArray *titlesArray;

@end

@implementation ReportViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Пожаловаться";
  [self prepareTableView];
  
  self.textView.hidden = YES;
  
  [self prepareBackBarButtonItem];
  self.textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Введите суть обращения" attributes:@{NSForegroundColorAttributeName : RGB(204, 204, 204), NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:12.f]}];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareTableView {
  for (NSString *title in @[@"Чужая фотография", @"Спам", @"Другое"]) {
    ReportModel *reportModel = [[ReportModel alloc] initWithTitle:title withTypeReport:NoneType withMessage:nil];
    [self.titlesArray addObject:reportModel];
  }
  
  self.selectReportModel = (ReportModel *)[self.titlesArray firstObject];
  self.textView.text = self.selectReportModel.messageReport;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ReportTableViewCell *reportCell = [tableView dequeueReusableCellWithIdentifier:kReportTableViewCellIdentifier];
  ReportModel *reportModel = [self.titlesArray objectAtIndex:indexPath.row];
  
  if (self.selectReportModel.typeReport != NoneType) {
    if (self.selectReportModel.typeReport == indexPath.row + 1) {
      [reportCell prepareReportCellByModel:self.selectReportModel andSelect:YES];
    } else {
      [reportCell prepareReportCellByModel:reportModel andSelect:NO];
    }
  } else {
    [reportCell prepareReportCellByModel:reportModel andSelect:NO];
  }
  
  return reportCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.selectReportModel = [self.titlesArray objectAtIndex:indexPath.row];
  self.selectReportModel.typeReport = indexPath.row + 1;
  
  if (self.selectReportModel.typeReport == OtherType) {
    self.textView.hidden = NO;
  } else {
    self.textView.hidden = YES;
  }
  
  [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)textViewDidChange:(UITextView *)textView {
  self.selectReportModel.messageReport = textView.text;
}

- (void)backButtonDidTap:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)successDidTap:(UIButton *)sender {
  if (self.selectReportModel.typeReport == OtherType) {
    if (self.selectReportModel.messageReport.length > 0) {
      NSString *note = self.selectReportModel.typeReport == AnotherPhotoType ? @"Чужая фотография" : self.selectReportModel.typeReport == SpamType ? @"Спам" : self.textView.text;
      [self sendReportWithNote:note];
    } else {
      [WToast showWithText:@"Введите суть обращения" duration:5.0];
    }
  } else {
    if (self.selectReportModel.typeReport != NoneType) {
      NSString *note = self.selectReportModel.typeReport == AnotherPhotoType ? @"Чужая фотография" :  @"Спам";
      [self sendReportWithNote:note];
    } else {
      [WToast showWithText:@"Выберите жалобу" duration:5.0];
      [self.textView becomeFirstResponder];
    }
  }
}

- (void)sendReportWithNote:(NSString *)note {
  [self.textView resignFirstResponder];
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"Id" : self.profileMapping.UserId,
                           @"Note" : note};
  [Helpers showSpinner];
  [[ServerManager sharedManager] sendReportWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (status) {
      [WToast showWithText:@"Жалоба отправлена" duration:3.0];
      [self.navigationController popViewControllerAnimated:YES];
    }
  }];
}

- (NSMutableArray *)titlesArray {
  if (_titlesArray == nil) {
    _titlesArray = [NSMutableArray new];
  }
  return _titlesArray;
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

