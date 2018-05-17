//
//  MotivationModel.m
//  Yammy
//
//  Created by Alex on 5/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationModel.h"

@implementation MotivationModel

- (instancetype)initWithPage:(MotivationPage)motivationPage
                       title:(NSString *)title
                    subTitle:(NSString *)subTitle
           receiveYaMaxTitle:(NSString *)receiveYaMaxTitle
                   imageName:(NSString *)imageName
                   titleCell:(NSString *)titleCell {
  
  self = [super init];
  if (self) {
    self.motivationPage = motivationPage;
    self.titleMotivation = title;
    self.subTitleMotivation = subTitle;
    self.receiveYaMaxTitle = receiveYaMaxTitle;
    self.imageName = imageName;
    self.titleCell = titleCell;
  }
  return self;
}

+ (NSArray *)titlesMotivationArray {
  return @[
           [[MotivationModel alloc] initWithPage:YaMaxPage title:@"" subTitle:@"" receiveYaMaxTitle:@"Получить Ya Max бесплатно" imageName:@"ya_max_motivation" titleCell:@"Купи YaMax и получи доступ к открытым приватным данным"],
           [[MotivationModel alloc] initWithPage:InvisiblePage title:@"Никаких скрытых посетителей!" subTitle:@"Получи Ya Max и пользуйся сервисом антиневидимка" receiveYaMaxTitle:@"Получить Ya Max бесплатно" imageName:@"invisible_motivation" titleCell:@"Теперь никто не сможет скрыться от вас! Просматривайте скрытых посетителей"],
           [[MotivationModel alloc] initWithPage:KingLikePage title:@"Ограничение Кинг Лайков" subTitle:@"У вас установлен лимит 1 Кинг Лайк в сутки" receiveYaMaxTitle:@"Получить Ya Max бесплатно" imageName:@"king_likes_motivation" titleCell:@"Стань заметнее! Расширь лимит и ставь больше Кинг Лайков"],
           [[MotivationModel alloc] initWithPage:DialogsPage title:@"Ограничение диалогов" subTitle:@"У вас установлен лимит 10 диалогов в сутки" receiveYaMaxTitle:@"Получить Ya Max бесплатно" imageName:@"chats_motivation" titleCell:@"Не ограничивай себя в общении! Расширь лимит на новые диалоги"],
           [[MotivationModel alloc] initWithPage:LooksPage title:@"Больше запросов просмотра" subTitle:@"У вас установлен лимит запросов 5 в день" receiveYaMaxTitle:@"Активируй Ya Max бесплатно" imageName:@"visits_motivation" titleCell:@"Безлимитные запросы на открытие приватных данных!"],
           [[MotivationModel alloc] initWithPage:LikePage title:@"Лайки без ограничений" subTitle:@"У вас установлен лимит лайков 50 в день" receiveYaMaxTitle:@"Получить Ya Max бесплатно" imageName:@"likes_motivation" titleCell:@"Ставьте лайков, сколько хотите! Безлимитные лайки в Ya Max"]];
}

+ (MotivationModel *)getMotivationByPage:(MotivationPage)motivationPage {
  MotivationModel *motivationModel = nil;
  for (MotivationModel *motivationModelFromArray in [[self class] titlesMotivationArray]) {
    if (motivationModelFromArray.motivationPage == motivationPage) {
      motivationModel = motivationModelFromArray;
      break;
    }
  }
  return motivationModel;
}

@end
