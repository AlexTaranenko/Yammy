//
//  MyPrivateProfileQuestionModel.h
//  Yammy
//
//  Created by Alex on 9/20/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  TextAnswerType = 0,
  SegmentAnswerType,
  SliderAnswerType,
} AnswerType;

typedef enum : NSUInteger {
  WithWhomFirstSex = 0,
  WhenFirstSex,
  WhereWasFirstSex,
  NewSexualHorizons,
  PenisOrBreasSize,
} TotalInfoBlock;

typedef enum : NSUInteger {
  HomeVideo = 0,
  WhenReadyFirstSex,
  SpecialPassionsSex,
  OftenReadyHaveSex,
  RelationshipVirtualSex
} PrivateInterestsBlock;

@interface MyPrivateProfileQuestionModel : NSObject

@property (strong, nonatomic) NSString *question;

@property (strong, nonatomic) NSString *answer;

@property (strong, nonatomic) NSArray *answers;

@property (assign, nonatomic) AnswerType answerType;

- (instancetype)initWithQuestion:(NSString *)question withAnswer:(NSString *)answer withAnswers:(NSArray *)answers withAnswerType:(AnswerType)answerType;

+ (NSArray *)totalInformationQuestionsArrayByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping;

+ (NSArray *)privateInterestQuestionsArray;

- (NSString *)answerTotalInfoByNumberOfBlock:(NSInteger)numberOfBlock withPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping;

- (NSString *)answerPrivateInterestsByNumberOfBlock:(NSInteger)numberOfBlock withPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping;

@end

