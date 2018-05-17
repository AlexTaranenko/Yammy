//
//  MyPrivateProfileQuestionModel.m
//  Yammy
//
//  Created by Alex on 9/20/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MyPrivateProfileQuestionModel.h"

@implementation MyPrivateProfileQuestionModel

- (instancetype)initWithQuestion:(NSString *)question withAnswer:(NSString *)answer withAnswers:(NSArray *)answers withAnswerType:(AnswerType)answerType {
  self = [super init];
  
  if (self) {
    self.question = question;
    self.answer = answer;
    self.answers = answers;
    self.answerType = answerType;
  }
  
  return self;
}

+ (NSArray *)totalInformationQuestionsArrayByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  
  NSMutableArray *mutArray = [NSMutableArray arrayWithArray:@[
                                                              @{@"question" : @"С кем у Вас был первый секс?", @"answers" : @[], @"answerType" : @(0)},
                                                              @{@"question" : @"Когда у Вас был первый секс?", @"answers" : @[], @"answerType" : @(0)},
                                                              @{@"question" : @"Где у Вас был первый секс?", @"answers" : @[], @"answerType" : @(0)},
                                                              @{@"question" : @"Готовы ли открывать для себя новые сексуальные горизонты?", @"answers" : @[], @"answerType" : @(1)}]];
  
  if ([ServerManager sharedManager].myProfileMapping.SexId != nil) {
    if ([ServerManager sharedManager].myProfileMapping.SexId != nil && [[ServerManager sharedManager].myProfileMapping.SexId integerValue] == 1) {
      [mutArray addObject:@{@"question" : @"Длина полового члена", @"answers" : @[@"15"], @"answerType" : @(2)}];
    } else {
      [mutArray addObject:@{@"question" : @"Размер груди", @"answers" : @[@"2"], @"answerType" : @(2)}];
    }
  }
  
  return mutArray;
}

+ (NSArray *)privateInterestQuestionsArray {
  return @[@{@"question" : @"Снимали ли свое домашнее видео?", @"answers" : @[], @"answerType" : @(1)},
           @{@"question" : @"Когда Вы готовы к первому сексу?", @"answers" : @[], @"answerType" : @(0)},
           @{@"question" : @"Есть ли у Вас особые пристрастия в сексе?", @"answers" : @[], @"answerType" : @(1)},
           @{@"question" : @"Как часто готовы заниматься сексом?", @"answers" : @[], @"answerType" : @(0)},
           @{@"question" : @"Отношение к виртуальному сексу?", @"answers" : @[], @"answerType" : @(1)}
           ];
}

- (NSString *)answerTotalInfoByNumberOfBlock:(NSInteger)numberOfBlock withPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  switch (numberOfBlock) {
    case WithWhomFirstSex:
      return privateProfileMapping.FirstSexWith; break;
      
    case WhenFirstSex:
      return privateProfileMapping.FirstSexWhen; break;
      
    case WhereWasFirstSex:
      return privateProfileMapping.FirstSexWhere; break;
      
    case NewSexualHorizons:
      return privateProfileMapping.ReadyToNewSexHorizons; break;
      
    case PenisOrBreasSize:
      return privateProfileMapping.PenisLengthOrBreastSize; break;
      
    default: return nil; break;
  }
}

- (NSString *)answerPrivateInterestsByNumberOfBlock:(NSInteger)numberOfBlock withPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  switch (numberOfBlock) {
    case HomeVideo:
      return privateProfileMapping.HaveFilmedHomeSex; break;
      
    case WhenReadyFirstSex:
      return privateProfileMapping.ReadyToFirstSex; break;
      
    case SpecialPassionsSex:
      return privateProfileMapping.SexPassions; break;
      
    case OftenReadyHaveSex:
      return privateProfileMapping.SexFrequency; break;
      
    case RelationshipVirtualSex:
      return privateProfileMapping.VirtualSex; break;
      
    default: return nil; break;
  }
}

@end

