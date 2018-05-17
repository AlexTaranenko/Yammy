//
//  MotivationModel.h
//  Yammy
//
//  Created by Alex on 5/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  YaMaxPage = 0,
  InvisiblePage,
  KingLikePage,
  DialogsPage,
  LooksPage,
  LikePage
} MotivationPage;

@interface MotivationModel : NSObject

@property (assign, nonatomic) MotivationPage motivationPage;
@property (strong, nonatomic) NSString *titleMotivation;
@property (strong, nonatomic) NSString *subTitleMotivation;
@property (strong, nonatomic) NSString *receiveYaMaxTitle;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *titleCell;

- (instancetype)initWithPage:(MotivationPage)motivationPage
                       title:(NSString *)title
                    subTitle:(NSString *)subTitle
           receiveYaMaxTitle:(NSString *)receiveYaMaxTitle
                   imageName:(NSString *)imageName
                   titleCell:(NSString *)titleCell;

+ (NSArray *)titlesMotivationArray;

+ (MotivationModel *)getMotivationByPage:(MotivationPage)motivationPage;

@end
