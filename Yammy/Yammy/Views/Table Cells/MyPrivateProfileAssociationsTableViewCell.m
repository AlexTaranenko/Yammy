//
//  MyPrivateProfileAssociationsTableViewCell.m
//  Yammy
//
//  Created by Alex on 21.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MyPrivateProfileAssociationsTableViewCell.h"
#import "UICollectionView+AssociationCollectionView.h"
#import "Yammy-Swift.h"

@interface MyPrivateProfileAssociationsTableViewCell()<OnlyPicturesDataSource, OnlyPicturesDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerOnlyPictures;
@property (weak, nonatomic) IBOutlet UIButton *hideShowAssociationsButton;

@property (strong, nonatomic) NSArray *imagesArray;

@property (strong, nonatomic) OnlyHorizontalPictures *onlyPictures;

@end

@implementation MyPrivateProfileAssociationsTableViewCell

- (OnlyHorizontalPictures *)onlyPictures {
  if (_onlyPictures == nil) {
    _onlyPictures = [[OnlyHorizontalPictures alloc] initWithFrame:CGRectMake(0, 0, self.containerOnlyPictures.frame.size.width, self.containerOnlyPictures.frame.size.height)];
    _onlyPictures.dataSource = self;
    _onlyPictures.delegate = self;
    _onlyPictures.backgroundColor = [UIColor clearColor];
    _onlyPictures.spacingColor = RGB(250, 250, 250);
    _onlyPictures.spacing = 4.0;
    _onlyPictures.gap = 36;
    
    _onlyPictures.layer.cornerRadius = 20.0;
    _onlyPictures.layer.masksToBounds = YES;
  }
  
  return _onlyPictures;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [self.containerOnlyPictures addSubview:self.onlyPictures];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareCollectionViewByPreferencesArray:(NSArray *)preferencesArray {
  self.imagesArray = preferencesArray;
  [self.onlyPictures reloadData];
}

- (NSInteger)numberOfPictures {
  return self.imagesArray.count + 1;
}

- (NSInteger)visiblePictures {
  return self.imagesArray.count + 1;
}

- (void)pictureViews:(UIImageView *)imageView index:(NSInteger)index {
  if (self.imagesArray.count == index) {
    imageView.image = [UIImage imageNamed:@"edit_association_icon"];
  } else {
    if (self.imagesArray.count > 0) {
      PreferencesMapping *mapping = [self.imagesArray objectAtIndex:index];
      NSString *urlPath = mapping.Icon.Url;
      urlPath = [urlPath substringToIndex:[urlPath length] - 1];
      CGFloat width = imageView.frame.size.width * 1.5;
      NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
      
      NSURL *urlImage = [NSURL URLWithString:urlString];
      if (urlImage) {
        [[SDWebImageManager sharedManager] loadImageWithURL:urlImage options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
          
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
          dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
          });
        }];
      } else {
        imageView.image = [UIImage imageNamed:@"placeholder_image"];
      }
    }
  }
//  if (self.imagesArray.count > 0) {
//    PreferencesMapping *mapping = [self.imagesArray objectAtIndex:index];
//    NSString *urlPath = mapping.Icon.Url;
//    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
//    CGFloat width = imageView.frame.size.width * 1.5;
//    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
//
//    NSURL *urlImage = [NSURL URLWithString:urlString];
//    if (urlImage) {
//      [imageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//          imageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
//        });
//      }];
//    } else {
//      imageView.image = [UIImage imageNamed:@"placeholder_image"];
//    }
//  } else {
//    imageView.image = [UIImage imageNamed:@"placeholder_image"];
//  }
}

- (void)pictureView:(UIImageView *)imageView didSelectAt:(NSInteger)index {
  if (self.delegate != nil) {
    [self.delegate presentAssociationsVC];
  }
}

- (void)prepareHideShowButton:(MyTitlePrivateProfileModel *)myTitlePrivateProfileModel {
  [self.hideShowAssociationsButton setTitle:myTitlePrivateProfileModel.titleButton forState:UIControlStateNormal];
}

- (IBAction)selectAssociationsDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showHidePrivateAssociation:self];
  }
}

@end

