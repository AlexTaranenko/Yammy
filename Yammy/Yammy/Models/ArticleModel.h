//
//  ArticleModel.h
//  Yammy
//
//  Created by Alex on 2/22/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpMapping.h"

@interface ArticleModel : NSObject

@property (strong, nonatomic) ArticleMapping *articleMapping;
@property (assign, nonatomic) BOOL isShowContent;

- (instancetype)initWithArticleMapping:(ArticleMapping *)articleMapping;

@end
