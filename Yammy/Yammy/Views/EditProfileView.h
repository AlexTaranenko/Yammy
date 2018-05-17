//
//  EditProfileView.h
//  Yammy
//
//  Created by Alex on 9/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrivateProfileQuestionModel.h"

@protocol EditProfileViewDelegate <NSObject>

@optional
- (void)reloadTableViewByIndexPath:(NSIndexPath *)indexPath;

- (void)presentImagePickerByIndexPath:(NSIndexPath *)indexPath;

@end

@interface EditProfileView : UIView

@property (strong, nonatomic) MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel;

@property (weak, nonatomic) id<EditProfileViewDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

+ (EditProfileView *)createEditProfileView;

- (void)setupItemsArray;

@end

