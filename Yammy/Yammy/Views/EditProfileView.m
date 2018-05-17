//
//  EditProfileView.m
//  Yammy
//
//  Created by Alex on 9/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "EditProfileView.h"
#import "OrientationRegisterTableViewCell.h"
#import "AnswerEditProfileTableViewCell.h"
#import "AddImageProfileTableViewCell.h"
#import "OtherEditProfileTableViewCell.h"

typedef enum : NSUInteger {
  TotalInfoSection = 0,
  PrivateInterestsSection,
} EditProfileSections;

typedef enum : NSUInteger {
  FirstSexEditProfileRow = 1,
  WhenSexEditProfileRow,
  WhereSexEditProfileRow,
} EditProfileRow;

static CGFloat const kTopAndButtonsHeight = 43.f;
static CGFloat const kCellHeight = 44.f;

@interface EditProfileView()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConatinerHeight;

@property (strong, nonatomic) NSArray *items;

@property (strong, nonatomic) NSString *answer;

@end

@implementation EditProfileView

+ (EditProfileView *)createEditProfileView {
  EditProfileView *editProfileView = (EditProfileView *)[[[NSBundle mainBundle] loadNibNamed:@"EditProfileView" owner:self options:nil] firstObject];
  editProfileView.frame = [UIScreen mainScreen].bounds;
  [editProfileView setupTableView];
  return editProfileView;
}

- (void)setupTableView {
  [self.tableView registerNib:[UINib nibWithNibName:@"OrientationRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:@"orientationRegisterTableCell"];
  [self.tableView registerNib:[UINib nibWithNibName:@"AnswerEditProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kAnswerEditProfileCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AddImageProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kAddImageProfileCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"OtherEditProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kOtherEditProfileCellIdentifier];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupItemsArray {
  if (self.selectedIndexPath != nil) {
    if (self.selectedIndexPath.section == TotalInfoSection) {
      if (self.selectedIndexPath.row == FirstSexEditProfileRow) {
        self.items = [self setupOrientationsArrayByModel:self.myPrivateProfileQuestionModel];
      } else {
        self.items = self.myPrivateProfileQuestionModel.answers;
      }
    } else {
      self.items = self.myPrivateProfileQuestionModel.answers;
    }
  } else {
    self.items = [self setupCarouselItems];
  }
  
  self.answer = self.myPrivateProfileQuestionModel.answer;
  
  if (self.selectedIndexPath.row == WhereSexEditProfileRow) {
    self.layoutConatinerHeight.constant = kTopAndButtonsHeight + kCellHeight * (self.items.count + 1);
  } else {
    self.layoutConatinerHeight.constant = kTopAndButtonsHeight + kCellHeight * self.items.count;
  }
}

- (NSArray *)setupOrientationsArrayByModel:(MyPrivateProfileQuestionModel *)model {
  NSMutableArray *mutArray = [NSMutableArray new];
  for (DictionaryMapping *dictionaryMapping in model.answers) {
    [mutArray addObject:@{@"title" : dictionaryMapping.Title, @"image" : dictionaryMapping.Icon != nil ? dictionaryMapping.Icon.Url : @""}];
  }
  return mutArray;
}

- (NSArray *)setupCarouselItems {
  return @[@{@"title" : @"Сделать фото", @"image" : @"photo_camera_icon"},
           @{@"title" : @"Бумеранг", @"image" : @"boomerang_icon"},
           @{@"title" : @"Загрузить из галлереи", @"image" : @"photo_library_icon"}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.selectedIndexPath.section == section) {
    if (self.selectedIndexPath.row == WhereSexEditProfileRow) {
      return self.items.count > 0 ? self.items.count + 1 : 1;
    } else {
      return self.items.count;
    }
  } else {
    return self.items.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedIndexPath != nil) {
    if (self.selectedIndexPath.section == TotalInfoSection) {
      if (self.selectedIndexPath.row == FirstSexEditProfileRow) {
        return [self prepareOrientationRegisterTableViewCellByIndexPath:indexPath];
      } else if (self.selectedIndexPath.row == WhereSexEditProfileRow) {
        if (self.items.count > 0) {
          if (indexPath.row == self.items.count) {
            OtherEditProfileTableViewCell *otherEditProfileCell = [tableView dequeueReusableCellWithIdentifier:kOtherEditProfileCellIdentifier];
            return otherEditProfileCell;
          } else {
            return [self prepareAnswerEditProfileTableViewCellByIndexPath:indexPath];
          }
        } else {
          OtherEditProfileTableViewCell *otherEditProfileCell = [tableView dequeueReusableCellWithIdentifier:kOtherEditProfileCellIdentifier];
          return otherEditProfileCell;
        }
      } else {
        return [self prepareAnswerEditProfileTableViewCellByIndexPath:indexPath];
      }
    } else {
      return [self prepareAnswerEditProfileTableViewCellByIndexPath:indexPath];
    }
  } else {
    return [self prepareAddImageProfileTableViewCellByIndexPath:indexPath];
  }
}

- (OrientationRegisterTableViewCell *)prepareOrientationRegisterTableViewCellByIndexPath:(NSIndexPath *)indexPath {
  OrientationRegisterTableViewCell *orientationRegisterTableCell = [self.tableView dequeueReusableCellWithIdentifier:@"orientationRegisterTableCell"];
  NSDictionary *dictionary = [self.items objectAtIndex:indexPath.row];
  orientationRegisterTableCell.dictionary = dictionary;
  if (self.answer != nil) {
    if ([[dictionary objectForKey:@"title"] isEqualToString:self.answer]) {
      [orientationRegisterTableCell selectedCheckBoxImageView:YES];
    } else {
      [orientationRegisterTableCell selectedCheckBoxImageView:NO];
    }
  } else {
    [orientationRegisterTableCell selectedCheckBoxImageView:NO];
  }
  return orientationRegisterTableCell;
}

- (AnswerEditProfileTableViewCell *)prepareAnswerEditProfileTableViewCellByIndexPath:(NSIndexPath *)indexPath {
  AnswerEditProfileTableViewCell *answerEditProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kAnswerEditProfileCellIdentifier];
  
  DictionaryMapping *dictionaryMapping = [self.items objectAtIndex:indexPath.row];
  
  answerEditProfileCell.titleText = dictionaryMapping.Title;
  if (self.answer != nil) {
    if ([self.answer isEqualToString:dictionaryMapping.Title]) {
      [answerEditProfileCell selectedIconImageView:YES];
    } else {
      [answerEditProfileCell selectedIconImageView:NO];
    }
  } else {
    [answerEditProfileCell selectedIconImageView:NO];
  }
  return answerEditProfileCell;
}

- (AddImageProfileTableViewCell *)prepareAddImageProfileTableViewCellByIndexPath:(NSIndexPath *)indexPath {
  AddImageProfileTableViewCell *addImageProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kAddImageProfileCellIdentifier];
  NSDictionary *dict = [self.items objectAtIndex:indexPath.row];
  addImageProfileCell.dictionary = dict;
  return addImageProfileCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedIndexPath != nil) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self.selectedIndexPath.row == WhereSexEditProfileRow) {
        if (self.items.count > 0) {
          if (indexPath.row == self.items.count) {
            [self presentAlertWithTextField];
          } else {
            DictionaryMapping *dictionaryMapping = [self.items objectAtIndex:indexPath.row];
            self.answer = dictionaryMapping.Title;
            [self.tableView reloadData];
          }
        } else {
          [self presentAlertWithTextField];
        }
      } else {
        DictionaryMapping *dictionaryMapping = [self.myPrivateProfileQuestionModel.answers objectAtIndex:indexPath.row];
        self.answer = dictionaryMapping.Title;
        [self.tableView reloadData];
      }
    });
  } else {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self.delegate != nil) {
        [self.delegate presentImagePickerByIndexPath:indexPath];
      }
    });
  }
}

- (void)presentAlertWithTextField {
  [UIAlertHelper alertTextField:self.answer title:@"Другое" placehodelr:nil withOkButton:@"Ок" withCancelButton:@"Отмена" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction, UITextField *textField) {
    if (successAction) {
      self.answer = textField.text;
    } else {
      if (self.delegate != nil) {
        [self.delegate reloadTableViewByIndexPath:self.selectedIndexPath];
      }
    }
  }];
}

- (IBAction)cancelDidTap:(UIButton *)sender {
  if (self.selectedIndexPath != nil) {
    if (self.delegate != nil) {
      [self.delegate reloadTableViewByIndexPath:self.selectedIndexPath];
    }
  } else {
    [Helpers dismissCustomView:self];
  }
}

- (IBAction)okDidTap:(UIButton *)sender {
  if (self.selectedIndexPath != nil) {
    self.myPrivateProfileQuestionModel.answer = self.answer;
    if (self.delegate != nil) {
      [self.delegate reloadTableViewByIndexPath:self.selectedIndexPath];
    }
  } else {
    [Helpers dismissCustomView:self];
  }
}

@end

