//
//  StickerCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 2/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kStickerCollectionCellIdentifier = @"stickerCollectionCell";

@interface StickerCollectionViewCell : UICollectionViewCell

- (void)prepareStickerCollectionCellByDictionaryMapping:(DictionaryMapping *)dictionaryMapping;

@end

