//
//  HelpMapping.h
//  Yammy
//
//  Created by Alex on 2/22/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMapping.h"

@interface HelpMapping : NSObject

@property (strong, nonatomic) NSNumber *IdHelp;
@property (strong, nonatomic) NSString *Title;

+ (RKObjectMapping *)objectMapping;

@end

@interface ArticleMapping: NSObject

@property (strong, nonatomic) NSNumber *IdArticle;
@property (strong, nonatomic) NSNumber *HelpTopicId;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Content;
@property (strong, nonatomic) ImageMapping *Image;

+ (RKObjectMapping *)objectMapping;

@end
