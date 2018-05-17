//
//  CarouselViewCell.m
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CarouselViewCell.h"

@interface CarouselViewCell()

@property (weak, nonatomic) IBOutlet CircularImageView *photoImageView;

@end

@implementation CarouselViewCell

+ (CarouselViewCell *)prepareCarouselViewCell {
  return (CarouselViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CarouselViewCell" owner:self options:nil] firstObject];
}

- (void)prepareBorderPhotoImageView {
  self.photoImageView.layer.borderWidth = 2.f;
  self.photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
  self.photoImageView.clipsToBounds = YES;
}

- (void)prepareCornerRadiusForPhotoImageView {
  self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.height / 2.f;
  self.photoImageView.clipsToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
