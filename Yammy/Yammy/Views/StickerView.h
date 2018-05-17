//
//  StickerView.h
//  Yammy
//
//  Created by Alex on 2/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StickerViewDelegate <NSObject>

@optional

- (void)selectStickerByDictionaryMapping:(DictionaryMapping *)dictionaryMapping;

@end

@interface StickerView : UIView

@property (weak, nonatomic) id<StickerViewDelegate> delegate;

+ (StickerView *)setupStickerView;

- (void)loadStickerFromServerByDictionary:(DictionaryMapping *)dictionaryMapping;

@end

