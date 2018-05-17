//
//  RightMenuViewController.h
//  Yammy
//
//  Created by Alex on 2/16/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  ReportRow = 0,
  ClearChatRow,
  BlockUserRow,
} RightMenuRow;

typedef enum : NSUInteger {
  StickerMenuRow = 0,
  TranslateMenuRow,
  GiftMenuRow,
  GalleryMenuRow,
  CameraMenuRow
} AttachMenuRow;

@protocol RightMenuViewControllerDelegate <NSObject>

@optional

- (void)selectRightMenuByRow:(RightMenuRow)rightMenuRow;

- (void)selectAttachMenuByRow:(AttachMenuRow)attachMenuRow isTranslateChats:(BOOL)isTranslateChats;

@end

@interface RightMenuViewController : UIViewController

@property (weak, nonatomic) id<RightMenuViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL isRightMenu;

@property (strong, nonatomic) ProfileMapping *profileMapping;

@end

