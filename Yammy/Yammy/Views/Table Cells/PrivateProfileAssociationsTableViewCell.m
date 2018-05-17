//
//  PrivateProfileAssociationsTableViewCell.m
//  Yammy
//
//  Created by Alex on 9/14/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PrivateProfileAssociationsTableViewCell.h"
#import "MZSelectableLabel.h"
#import "UICollectionView+AssociationCollectionView.h"

@interface PrivateProfileAssociationsTableViewCell()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet MZSelectableLabel *titleLabel;

@end

@implementation PrivateProfileAssociationsTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [self prepareTitleLabel];
  [self.collectionView prepareAssociationCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Private

- (void)prepareCollectionViewByPreferencesArray:(NSArray *)preferencesArray {
  self.collectionView.preferencesArray = preferencesArray;
  [self.collectionView reloadData];
}

- (void)addMappingToCollectionView:(PrivateProfileMapping *)privateProfileMapping {
  self.collectionView.privateProfileMapping = privateProfileMapping;
}

- (void)prepareTitleLabel {
  [self.titleLabel setSelectableRange:[[self.titleLabel.attributedText string] rangeOfString:@"начать общение"] hightlightedBackgroundColor:[UIColor clearColor]];
  self.titleLabel.selectionHandler = ^(NSRange range, NSString *string) {
    if (self.delegate != nil) {
      [self.delegate pushToChat];
    }
  };
}

@end
