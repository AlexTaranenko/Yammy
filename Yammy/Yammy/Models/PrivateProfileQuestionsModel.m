//
//  PrivateProfileQuestionsModel.m
//  Yammy
//
//  Created by Alex on 16.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PrivateProfileQuestionsModel.h"

@implementation PrivateProfileQuestionsModel

- (instancetype)initWithQuestion:(NSString *)question andAnswer:(NSString *)answer {
  self = [super init];
  
  if (self) {
    self.question = question;
    self.answer = answer;
  }
  
  return self;
}

+ (NSArray *)prepareGeneralInfoByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping withProfileMapping:(ProfileMapping *)profileMapping {
  NSMutableArray *mutArray = [NSMutableArray new];
  
  if (privateProfileMapping.FirstSexWith != nil) {
    NSString *question = [NSString stringWithFormat:@"Первый секс у меня был %@", privateProfileMapping.FirstSexWith];
    PrivateProfileQuestionsModel *model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:privateProfileMapping.FirstSexWith];
    [mutArray addObject:model];
  }
  
  if (privateProfileMapping.FirstSexWhen != nil) {
    NSString *question = [NSString stringWithFormat:@"Первый секс был в %@.", privateProfileMapping.FirstSexWhen];
    PrivateProfileQuestionsModel *model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:privateProfileMapping.FirstSexWhen];
    [mutArray addObject:model];
  }
  
  if (privateProfileMapping.FirstSexWhere != nil) {
    NSString *question = [NSString stringWithFormat:@"Первый секс у меня был в %@", privateProfileMapping.FirstSexWhere];
    PrivateProfileQuestionsModel *model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:privateProfileMapping.FirstSexWhere];
    [mutArray addObject:model];
  }
  
  if (privateProfileMapping.ReadyToNewSexHorizons != nil) {
    NSString *question;
    PrivateProfileQuestionsModel *model = nil;
    if ([privateProfileMapping.ReadyToNewSexHorizons isEqualToString:@"нет"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Не готов открывать для себя новые сексуальные горизонты!"];
        model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Не готов открывать"];
      } else {
        question = [NSString stringWithFormat:@"Не готова открывать для себя новые сексуальные горизонты!"];
        model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Не готова открывать"];
      }
    } else if ([privateProfileMapping.ReadyToNewSexHorizons isEqualToString:@"да"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов открывать для себя новые сексуальные горизонты!"];
        model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Готов открывать"];
      } else {
        question = [NSString stringWithFormat:@"Готова открывать для себя новые сексуальные горизонты!"];
        model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Готова открывать"];
      }
    } else {
      question = [NSString stringWithFormat:@"Возможно открою для себя новые сексуальные горизонты!"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Возможно открою"];
    }
    [mutArray addObject:model];
  }
  
  if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
    if (privateProfileMapping.PenisLengthOrBreastSize != nil) {
      NSString *question = [NSString stringWithFormat:@"У меня %@ размер члена", privateProfileMapping.PenisLengthOrBreastSize];
      PrivateProfileQuestionsModel *model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:privateProfileMapping.PenisLengthOrBreastSize];
      [mutArray addObject:model];
    }
  } else {
    if (privateProfileMapping.PenisLengthOrBreastSize != nil) {
      NSString *question = [NSString stringWithFormat:@"У меня %@ размер груди", privateProfileMapping.PenisLengthOrBreastSize];
      PrivateProfileQuestionsModel *model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:privateProfileMapping.PenisLengthOrBreastSize];
      [mutArray addObject:model];
    }
  }
  
  return mutArray;
}

+ (NSArray *)preparePrivateInterestsByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping withProfileMapping:(ProfileMapping *)profileMapping {
  NSMutableArray *mutArray = [NSMutableArray new];
  
  if (privateProfileMapping.HaveFilmedHomeSex != nil) {
    NSString *question;
    PrivateProfileQuestionsModel *model;
    if ([privateProfileMapping.HaveFilmedHomeSex isEqualToString:@"нет"]) {
      question = [NSString stringWithFormat:@"Отсутствует опыт съемки домашнего видео"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Отсутствует опыт съемки"];
    } else {
      question = [NSString stringWithFormat:@"Есть опыт съемки домашнего видео"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Есть опыт съемки"];
    }
    [mutArray addObject:model];
  }
  
  if (privateProfileMapping.ReadyToFirstSex != nil) {
    NSString *question;
    PrivateProfileQuestionsModel *model;
    if ([privateProfileMapping.ReadyToFirstSex isEqualToString:@"в первый день знакомства"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов к сексу в первый день знакомства"];
      } else {
        question = [NSString stringWithFormat:@"Готова к сексу в первый день знакомства"];
      }
    } else if ([privateProfileMapping.ReadyToFirstSex isEqualToString:@"в первые три дня знакомства"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов к сексу в первые три дня знакомства"];
      } else {
        question = [NSString stringWithFormat:@"Готова к сексу в первые три дня знакомства"];
      }
    } else if ([privateProfileMapping.ReadyToFirstSex isEqualToString:@"в первую неделю знакомства"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов к сексу в первую неделю знакомства"];
      } else {
        question = [NSString stringWithFormat:@"Готова к сексу в первую неделю знакомства"];
      }
    } else {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов к сексу но все зависит от партнера"];
      } else {
        question = [NSString stringWithFormat:@"Готова к сексу но все зависит от партнера"];
      }
    }
    
    model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:privateProfileMapping.ReadyToFirstSex];
    [mutArray addObject:model];
  }
  
  if (privateProfileMapping.SexPassions != nil) {
    NSString *question;
    PrivateProfileQuestionsModel *model;
    
    if ([privateProfileMapping.SexPassions isEqualToString:@"нет"]) {
      question = [NSString stringWithFormat:@"Отсутствуют особые пристрастия в сексе"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Отсутствуют особые пристрастия"];
    } else if ([privateProfileMapping.SexPassions isEqualToString:@"да"]) {
      question = [NSString stringWithFormat:@"Есть особые пристрастия в сексе"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Есть особые пристрастия"];
    } else {
      question = [NSString stringWithFormat:@"Возможны особые пристрастия в сексе"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"Возможны особые пристрастия"];
    }
    [mutArray addObject:model];
  }
  
  if (privateProfileMapping.SexFrequency != nil) {
    NSString *question;
    PrivateProfileQuestionsModel *model;
    
    if ([privateProfileMapping.SexFrequency isEqualToString:@"все зависит от партнера"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов заниматься сексом но все зависит от партнера"];
      } else {
        question = [NSString stringWithFormat:@"Готова заниматься сексом но все зависит от партнера"];
      }
    } else if ([privateProfileMapping.SexFrequency isEqualToString:@"раз в три дня"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов раз в три дня заниматься сексом"];
      } else {
        question = [NSString stringWithFormat:@"Готова раз в три дня заниматься сексом"];
      }
    } else if ([privateProfileMapping.SexFrequency isEqualToString:@"раз в день"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов раз в день заниматься сексом"];
      } else {
        question = [NSString stringWithFormat:@"Готова раз в день заниматься сексом"];
      }
    } else if ([privateProfileMapping.SexFrequency isEqualToString:@"раз в неделю"]) {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов раз в неделю заниматься сексом"];
      } else {
        question = [NSString stringWithFormat:@"Готова раз в неделю заниматься сексом"];
      }
    } else {
      if (profileMapping.SexId != nil && [profileMapping.SexId integerValue] == 1) {
        question = [NSString stringWithFormat:@"Готов несколько раз в день заниматься сексом"];
      } else {
        question = [NSString stringWithFormat:@"Готова несколько раз в день заниматься сексом"];
      }
    }
    
    model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:privateProfileMapping.SexFrequency];
    [mutArray addObject:model];
  }
  
  if (privateProfileMapping.VirtualSex != nil) {
    NSString *question;
    PrivateProfileQuestionsModel *model;
    
    if ([privateProfileMapping.VirtualSex isEqualToString:@"отрицательное"]) {
      question = [NSString stringWithFormat:@"Отношусь к виртуальному сексу отрицательно"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"отрицательно"];
    } else if ([privateProfileMapping.VirtualSex isEqualToString:@"нейтральное"]) {
      question = [NSString stringWithFormat:@"Отношусь к виртуальному сексу нейтрально"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"нейтрально"];
    } else {
      question = [NSString stringWithFormat:@"Отношусь к виртуальному сексу положительно"];
      model = [[PrivateProfileQuestionsModel alloc] initWithQuestion:question andAnswer:@"положительно"];
    }
    [mutArray addObject:model];
  }
  
  return mutArray;
}

@end

