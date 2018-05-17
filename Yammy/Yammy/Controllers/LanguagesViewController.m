//
//  LanguagesViewController.m
//  Yammy
//
//  Created by Alex on 1/29/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "LanguagesViewController.h"
#import "ProfileFormTableViewCell.h"
#import "LanguageMapping.h"

@interface LanguagesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) LanguageMapping *languageMapping;

@property (strong, nonatomic) NSArray *languagesArray;

@end

@implementation LanguagesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Языки";
  
  [self prepareBackBarButtonItem];
  
  if (self.publicProfileAboutMeModel.languageArray.count > 0) {
    NSArray *filteredArray = [self.publicProfileAboutMeModel.languageArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdLanguage == %@", self.publicProfileAboutMeModel.LanguageId]];
    if (filteredArray.count > 0) {
      self.languageMapping = (LanguageMapping *)[filteredArray firstObject];
    }
  } else {
    [[ServerManager sharedManager] getLanguageListWithCompletion:^(NSArray *languageArray, NSString *errorMessage) {
      if (languageArray) {
        self.languagesArray = languageArray;
        self.languageMapping = self.userSettingsMapping.Language;
        [self.tableView reloadData];
      }
    }];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.userSettingsMapping != nil ? self.languagesArray.count : self.publicProfileAboutMeModel.languageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ProfileFormTableViewCell *profileFormCell = [tableView dequeueReusableCellWithIdentifier:kProfileFormCellIdentifier];
  
  LanguageMapping *languageMapping = [self setupLanguageMappingByIndexPath:indexPath];
  [self setupProfileFormObjectByMapping:languageMapping andCell:profileFormCell];
  
  if (self.userSettingsMapping != nil) {
    [profileFormCell prepareTitleLabelWithMapping:languageMapping];
    if (self.isChange == NO) {
      LanguageMapping *mapping = [self getLanguageMappingFromArrayById:languageMapping.IdLanguage];
      [profileFormCell checkboxCompareFirstId:languageMapping.IdLanguage toSecondId:mapping.IdLanguage];
    } else {
      [profileFormCell compareFirstId:languageMapping.IdLanguage toSecondId:self.languageMapping.IdLanguage];
    }
  } else {
    [profileFormCell prepareSelectedIconByPublicProfileAboutMeModel:self.publicProfileAboutMeModel];
    [profileFormCell compareFirstId:self.languageMapping.IdLanguage toSecondId:languageMapping.IdLanguage];
  }
  
  return profileFormCell;
}

- (LanguageMapping *)getLanguageMappingFromArrayById:(NSNumber *)languageId {
  NSArray *filteredArray = [self.addedLanguages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdLanguage == %@", languageId]];
  if (filteredArray.count > 0) {
    LanguageMapping *mapping = (LanguageMapping *)[filteredArray firstObject];
    return mapping;
  } else {
    return nil;
  }
}

- (LanguageMapping *)setupLanguageMappingByIndexPath:(NSIndexPath *)indexPath {
  if (self.userSettingsMapping != nil) {
    return (LanguageMapping *)[self.languagesArray objectAtIndex:indexPath.row];
  } else {
    return (LanguageMapping *)[self.publicProfileAboutMeModel.languageArray objectAtIndex:indexPath.row];
  }
}

- (void)setupProfileFormObjectByMapping:(LanguageMapping *)mapping andCell:(UITableViewCell *)cell {
  if (self.languageMapping != nil && [self.languageMapping.IdLanguage isEqualToNumber:mapping.IdLanguage]) {
    [(ProfileFormTableViewCell *)cell setObject:self.languageMapping];
  } else {
    [(ProfileFormTableViewCell *)cell setObject:mapping];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.userSettingsMapping != nil) {
    if (self.isChange) {
      self.languageMapping = [self.languagesArray objectAtIndex:indexPath.row];
    } else {
      LanguageMapping *languageMapping = [self.languagesArray objectAtIndex:indexPath.row];
      LanguageMapping *mapping = [self getLanguageMappingFromArrayById:languageMapping.IdLanguage];
      
      if (mapping) {
        if (self.delegate != nil) {
          [self.delegate deleteLanguageByMapping:mapping];
        }
        
        NSInteger index = [self.addedLanguages indexOfObject:mapping];
        [self.addedLanguages removeObjectAtIndex:index];
      } else {
        if (self.delegate != nil) {
          [self.delegate setupLanguageByMapping:languageMapping];
        }
        
        [self.addedLanguages addObject:languageMapping];
      }
    }
  } else {
    self.languageMapping = [self.publicProfileAboutMeModel.languageArray objectAtIndex:indexPath.row];
  }
  
  [self.tableView reloadData];
}

- (void)backButtonDidTap:(id)sender {
  if (self.userSettingsMapping == nil) {
    self.publicProfileAboutMeModel.LanguageId = self.languageMapping.IdLanguage;
  } else {
    if (self.isChange) {
      if (self.delegate != nil) {
        [self.delegate changeLanguageByMapping:self.languageMapping];
      }
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

