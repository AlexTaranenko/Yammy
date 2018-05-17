//
//  AllCoincidenceTableViewCell.m
//  Yammy
//
//  Created by Alex on 09.10.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllCoincidenceTableViewCell.h"
#import "Yammy-Swift.h"

@interface AllCoincidenceTableViewCell()<OnlyPicturesDataSource, OnlyPicturesDelegate>

@property (weak, nonatomic) IBOutlet CustomImageView *firstImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerMatchesView;

@property (strong, nonatomic) OnlyHorizontalPictures *onlyPictures;
@property (strong, nonatomic) NSArray *imagesArray;

@end

@implementation AllCoincidenceTableViewCell

- (OnlyHorizontalPictures *)onlyPictures {
  if (_onlyPictures == nil) {
    _onlyPictures = [[OnlyHorizontalPictures alloc] initWithFrame:CGRectMake(0, 0, self.containerMatchesView.frame.size.width, self.containerMatchesView.frame.size.height)];
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
  
  [self.containerMatchesView addSubview:self.onlyPictures];
  [self rotationImages];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)rotationImages {
  self.firstImageView.transform = CGAffineTransformMakeRotation(-15 * M_PI/180);
  self.secondImageView.transform = CGAffineTransformMakeRotation(15 * M_PI/180);
}

- (void)prepareAllCoincidenceCellByMatchMapping:(MatchMapping *)matchMapping {
  self.titleLabel.text = matchMapping.Title;
  self.subTitleLabel.text = matchMapping.SubTitle;
  [self prepareCollectionViewByPreferencesArray:matchMapping.PrivatePreferences];
  
  if (matchMapping.FromUser.PrimaryPhoto != nil) {
    [self prepareImageView:self.firstImageView urlPath:matchMapping.FromUser.PrimaryPhoto.Url width:self.firstImageView.frame.size.width * 1.5];
  } else {
    self.firstImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
  
  if (matchMapping.ToUser.PrimaryPhoto != nil) {
    [self prepareImageView:self.secondImageView urlPath:matchMapping.ToUser.PrimaryPhoto.Url width:10];
  } else {
    self.secondImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.containerMatchesView.frame.size.height, self.containerMatchesView.frame.size.height)];
    label.backgroundColor = RGB(249, 0, 64);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:20];
    label.text = self.imagesArray.count > 3 ?  @"+3" : [NSString stringWithFormat:@"%lu", (unsigned long)self.imagesArray.count];
    [imageView addSubview:label];
  } else {
    if (self.imagesArray.count > 0) {
      PreferencesMapping *mapping = [self.imagesArray objectAtIndex:index];
      [self prepareImageView:imageView urlPath:mapping.Icon.Url width:imageView.frame.size.width * 1.5];
    }
  }
}

- (void)prepareImageView:(UIImageView *)imageView urlPath:(NSString *)urlPath width:(CGFloat)width {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
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

- (void)pictureView:(UIImageView *)imageView didSelectAt:(NSInteger)index {
  
}

- (IBAction)openChatDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openChatByCell:self];
  }
}

@end

