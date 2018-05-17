//
//  SexRegisterTableViewCell.m
//  Yammy
//
//  Created by Alex on 31.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SexRegisterTableViewCell.h"

typedef enum : NSUInteger {
  ManGenderTag = 1,
  WomanGenderTag,
} GenderTag;

@interface SexRegisterTableViewCell()

@property (weak, nonatomic) IBOutlet UIControl *manControl;
@property (weak, nonatomic) IBOutlet UIControl *womanControl;
@property (weak, nonatomic) IBOutlet UIImageView *manImageView;
@property (weak, nonatomic) IBOutlet UILabel *manLabel;
@property (weak, nonatomic) IBOutlet UIImageView *womanImageView;
@property (weak, nonatomic) IBOutlet UILabel *womanLabel;

@end

@implementation SexRegisterTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  //  self.manControl.tag = kManControlTag;
  //  self.womanControl.tag = kWomanControlTag;
  
  for (UIControl *control in @[self.manControl, self.womanControl]) {
    control.layer.borderWidth = 0.5f;
    control.layer.borderColor = RGB(235, 235, 235).CGColor;
    control.layer.cornerRadius = 3.0f;
    control.clipsToBounds = YES;
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareButtonsByArray:(NSArray *)array {
  NSArray *controls = @[self.manControl, self.womanControl];
  for (UIControl *control in controls) {
    NSInteger index = [controls indexOfObject:control];
    DictionaryMapping *mapping = [array objectAtIndex:index];
    control.tag = [mapping.IdDictionary integerValue];
    if ([mapping.IdDictionary integerValue] == ManGenderTag) {
      self.manLabel.text = mapping.Title;
    } else {
      self.womanLabel.text = mapping.Title;
    }
    
    [self prepareSexImageByMapping:mapping];
  }
}

- (void)prepareSexImageByMapping:(DictionaryMapping *)mapping {
  NSString *urlPath = mapping.Icon.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.manImageView.frame.size.width;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  NSURL *urlImage = [NSURL URLWithString:urlString];
  [self setupImageByUrlImage:urlImage withImageView:[mapping.IdDictionary integerValue] == ManGenderTag ? self.manImageView : self.womanImageView];
}

- (void)setupImageByUrlImage:(NSURL *)urlImage withImageView:(UIImageView *)imageView {
  if (urlImage) {
    [imageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    imageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)prepareSexRegisterByModel:(RegisterModel *)registerModel {
  [self changeColorByTag:registerModel.sexUser];
}

- (IBAction)sexDidTap:(UIControl *)sender {
  self.registerModel.sexUser = @(sender.tag);
  [self changeColorByTag:self.registerModel.sexUser];
}

- (void)changeColorByTag:(NSNumber *)tag {
  NSArray *controls = @[self.manControl, self.womanControl];
  for (UIControl *control in controls) {
    if (tag != nil) {
      if (control.tag == [tag integerValue]) {
        control.backgroundColor = RGB(214, 0, 65);
      } else {
        control.backgroundColor = [UIColor whiteColor];
      }
      
      if ([tag integerValue] == ManGenderTag) {
        [self changeManLabelColor:[UIColor whiteColor] andWomanLabelColor:RGB(51, 51, 51)];
      } else {
        [self changeManLabelColor:RGB(51, 51, 51) andWomanLabelColor:[UIColor whiteColor]];
      }
    } else {
      control.backgroundColor = [UIColor whiteColor];
    }
  }
}

- (void)changeManLabelColor:(UIColor *)manColor andWomanLabelColor:(UIColor *)womanColor {
  self.manLabel.textColor = manColor;
  self.womanLabel.textColor = womanColor;
}

- (void)changeControlColors:(UIColor *)manColor andWomanColor:(UIColor *)womanColor {
  self.manControl.backgroundColor = manColor;
  self.womanControl.backgroundColor = womanColor;
}

@end

