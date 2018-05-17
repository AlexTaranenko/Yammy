//
//  TutorialCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 2/28/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "TutorialCollectionViewCell.h"

@interface TutorialCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation TutorialCollectionViewCell

- (void)prepareImageByName:(NSString *)imageName {
  self.photoImageView.image = [UIImage imageNamed:imageName];
}

@end
