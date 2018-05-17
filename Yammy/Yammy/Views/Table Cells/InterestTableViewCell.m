//
//  InterestTableViewCell.m
//  Yammy
//
//  Created by Alex on 29.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "InterestTableViewCell.h"

@interface InterestTableViewCell()

@property (weak, nonatomic) IBOutlet JCTagListView *tagListView;

@end

@implementation InterestTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareTagsByArray:(NSArray *)tags {
  self.tagListView.tags = nil;
  [self.tagListView.collectionView reloadData];
  
  self.tagListView.tagCornerRadius = 7.0;
  self.tagListView.tagTextColor = RGB(128, 128, 128);
  self.tagListView.tagStrokeColor = [UIColor clearColor];
  self.tagListView.tagTextFont = [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14.0];
  self.tagListView.tagBackgroundColor = RGB(237, 237, 237);
  self.tagListView.tags = [NSMutableArray arrayWithArray:tags];
  [self.tagListView.collectionView reloadData];
}

@end

