//
//  ArticleModel.m
//  Yammy
//
//  Created by Alex on 2/22/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

- (instancetype)initWithArticleMapping:(ArticleMapping *)articleMapping {
  self = [super init];
  
  if (self) {
    self.articleMapping = articleMapping;
    self.isShowContent = NO;
  }
  
  return self;
}

@end
