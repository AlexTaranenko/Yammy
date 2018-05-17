//
//  CalendarRegisterViewController.m
//  Yammy
//
//  Created by Alex on 8/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CalendarRegisterViewController.h"
#import "FSCalendar.h"
#import "YearCalendarCollectionViewCell.h"

static int kMinimumYear = 18;

@interface CalendarRegisterViewController ()<FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UICollectionView *yearCollectionView;

@property (assign, nonatomic) BOOL isHide;
@property (strong, nonatomic) NSArray *yearsArray;
@property (strong, nonatomic) NSNumber *selectedYear;

@end

@implementation CalendarRegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.isHide = YES;
  self.yearCollectionView.hidden = self.isHide;
  [self setupYearsArray];
  [self prepareCalendar];
  [self prepareStackView];
  
  if (self.registerModel.birthdayUser) {
    [self.calendar selectDate:self.registerModel.birthdayUser scrollToDate:YES];
    [self prepareLabelsByDate:self.registerModel.birthdayUser];
    self.selectedYear = [self setupYearFromDate:self.registerModel.birthdayUser];
    [self.yearButton setTitle:[self.selectedYear stringValue] forState:UIControlStateNormal];
  } else {
    [self.yearButton setTitle:@"Выберите год" forState:UIControlStateNormal];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareStackView {
  self.containerView.layer.cornerRadius = 5.0f;
  self.containerView.clipsToBounds = YES;
}

- (void)prepareCalendar {
  self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
  self.calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase | FSCalendarCaseOptionsWeekdayUsesUpperCase;
//  self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
  self.calendar.locale = [NSLocale currentLocale];
  self.calendar.appearance.headerDateFormat = @"MMMM yyyy";
  self.calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
  self.calendar.scrollEnabled = NO;
}

- (NSDate *)setupMaximumDate {
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
  [components setYear:[components year] - kMinimumYear];
  NSDate *dateFromComponents = [[NSCalendar currentCalendar] dateFromComponents:components];
  return dateFromComponents;
}

- (NSNumber *)setupYearFromDate:(NSDate *)date {
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date];
  return @([components year]);
}

- (NSNumber *)setupMonthFromDate:(NSDate *)date {
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date];
  return @([components month]);
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
  return [self setupMaximumDate];
}

- (void)setupYearsArray {
  NSDateFormatter* formatter = [NSDateFormatter new];
  [formatter setDateFormat:@"yyyy"];
  int minimumYears = [[formatter stringFromDate:[self.calendar minimumDate]] intValue];
  int maximumYear  = [[formatter stringFromDate:[NSDate date]] intValue] - kMinimumYear;
  
  NSMutableArray *years = [[NSMutableArray alloc] init];
  for (int i = minimumYears; i <= maximumYear; i++) {
    [years addObject:[NSNumber numberWithInteger:i]];
  }
  
  self.yearsArray = [years sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    return [(NSNumber *)obj1 compare:(NSNumber *)obj2] == NSOrderedAscending;
  }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.yearsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  YearCalendarCollectionViewCell *yearCalendarCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"yearCalendarCollectionCell" forIndexPath:indexPath];
  NSNumber *year = [self.yearsArray objectAtIndex:indexPath.row];
  yearCalendarCollectionViewCell.yearNumber = year;
  [yearCalendarCollectionViewCell prepareBackgroundColor:self.selectedYear == year ? YES : NO];
  return yearCalendarCollectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *year = [self.yearsArray objectAtIndex:indexPath.row];
  self.selectedYear = year;
  [collectionView reloadData];
  
  [self setupCurrentPage];
  [self presentCollectionView:YES];
  [self.yearButton setTitle:[self.selectedYear stringValue] forState:UIControlStateNormal];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  CGFloat cellSizeWidth = 70.0;
  CGFloat collectionEdgeInsets = collectionView.frame.size.width / 2.0;
  CGFloat cellEdgeInsets = cellSizeWidth / 2.0;
  CGFloat offset = collectionEdgeInsets - cellEdgeInsets;
  return UIEdgeInsetsMake(5.0, offset, 5.0, offset);
}

- (void)setupCurrentPage {
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self.registerModel.birthdayUser];
  [components setYear:[self.selectedYear integerValue]];
  [components setMonth:[components month]];
  [components setDay:[components day]];
  self.registerModel.birthdayUser = [[NSCalendar currentCalendar] dateFromComponents:components];
  [self.calendar selectDate:self.registerModel.birthdayUser scrollToDate:YES];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
  [self prepareLabelsByDate:date];
  self.registerModel.birthdayUser = date;
  self.selectedYear = [self setupYearFromDate:self.registerModel.birthdayUser];
  [self prepareLabelsByDate:self.registerModel.birthdayUser];
  [self.yearButton setTitle:[self.selectedYear stringValue] forState:UIControlStateNormal];
  [self.yearCollectionView reloadData];
}

- (void)prepareLabelsByDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"dd";
  self.dayLabel.text = [dateFormatter stringFromDate:date];
  dateFormatter.dateFormat = @"MMMM";
  self.monthLabel.text = [[dateFormatter stringFromDate:date] uppercaseString];
  dateFormatter.dateFormat = @"EEEE";
  self.weekDayLabel.text = [[dateFormatter stringFromDate:date] uppercaseString];
}

- (IBAction)yearDidTap:(UIButton *)sender {
  [self presentCollectionView:NO];
}

- (void)presentCollectionView:(BOOL)isHide {
  [UIView transitionWithView:self.yearCollectionView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    self.isHide = isHide;
    self.yearCollectionView.hidden = self.isHide;
  } completion:NULL];
}

- (IBAction)doneDidTap:(UIButton *)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    if (self.delegate != nil) {
      [self.delegate prepareBirthdayTableCell];
    }
  }];
}

- (IBAction)leftDidTap:(UIButton *)sender {
  NSDate *currentMonth = self.calendar.currentPage;
  NSDate *previousMonth = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
  
  NSNumber *minimumYear = [self setupYearFromDate:self.calendar.minimumDate];
  NSNumber *year = [self setupYearFromDate:previousMonth];
  
  if (year < minimumYear) {
    [self setupCalendarByDateMonth:self.calendar.minimumDate];
  } else {
    [self setupCalendarByDateMonth:previousMonth];
  }
}

- (IBAction)rightDidTap:(UIButton *)sender {
  NSDate *currentMonth = self.calendar.currentPage;
  NSDate *nextMonth = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
  
  NSNumber *maximumMonth = [self setupMonthFromDate:[self setupMaximumDate]];
  NSNumber *maximumYear = [self setupYearFromDate:[self setupMaximumDate]];
  NSNumber *year = [self setupYearFromDate:nextMonth];
  NSNumber *month = [self setupMonthFromDate:nextMonth];
  
  if ([year isEqualToNumber:maximumYear]) {
    if ([month integerValue] > [maximumMonth integerValue]) {
      [self setupCalendarByDateMonth:[self setupMaximumDate]];
    } else {
      [self setupCalendarByDateMonth:nextMonth];
    }
  } else if ([year integerValue] > [maximumYear integerValue]) {
    [self setupCalendarByDateMonth:[self setupMaximumDate]];
  } else {
    [self setupCalendarByDateMonth:nextMonth];
  }
}

- (void)setupCalendarByDateMonth:(NSDate *)dateOfMonth {
  NSDateComponents *componentsFromPreviousMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dateOfMonth];
  NSDateComponents *componentsFromBirthday = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self.registerModel.birthdayUser];
  
  [componentsFromPreviousMonth setYear:[componentsFromPreviousMonth year]];
  [componentsFromPreviousMonth setMonth:[componentsFromPreviousMonth month]];
  [componentsFromPreviousMonth setDay:[componentsFromBirthday day]];
  
  self.registerModel.birthdayUser = [[NSCalendar currentCalendar] dateFromComponents:componentsFromPreviousMonth];
  self.selectedYear = [self setupYearFromDate:self.registerModel.birthdayUser];
  [self.calendar setCurrentPage:self.registerModel.birthdayUser animated:YES];
  [self.yearCollectionView reloadData];
  [self.calendar selectDate:self.registerModel.birthdayUser scrollToDate:YES];
  [self prepareLabelsByDate:self.registerModel.birthdayUser];
  [self.yearButton setTitle:[self.selectedYear stringValue] forState:UIControlStateNormal];
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

