//
//  ProfileContainerViewController.h
//  Yammy
//
//  Created by Alex on 17.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMapping.h"

@protocol ProfileContainerViewControllerDelegate <NSObject>

@optional

- (void)presentOtherPrivateProfile;

@end

@interface ProfileContainerViewController : UIViewController

@property (weak, nonatomic) id<ProfileContainerViewControllerDelegate> delegate;
@property (strong, nonatomic) ProfileMapping *profileMapping;
@property (assign, nonatomic) BOOL isShowProfile;

- (void)segueIdentifierReceivedFromParent:(NSString*)segueIdentifier;

@end

