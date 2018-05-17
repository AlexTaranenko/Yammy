//
//  MotivationPopupView.h
//  Yammy
//
//  Created by Alex on 5/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotivationModel.h"

@protocol MotivationPopupViewDelegate <NSObject>

@optional

- (void)closeMotivationPopup;

- (void)presentMotivationServicesScreen;

@end

@interface MotivationPopupView : UIView

@property (weak, nonatomic) id<MotivationPopupViewDelegate> delegate;

+ (MotivationPopupView *)createMotivationPopupView;

- (void)prepareMotivationInterfaceBy:(MotivationPage)motivationPage;

@end
