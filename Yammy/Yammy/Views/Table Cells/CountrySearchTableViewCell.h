//
//  CountrySearchTableViewCell.h
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountrySearchTableViewCellDelegate <NSObject>

- (void)selectLocationByCell:(UITableViewCell *)cell;

@end

@interface CountrySearchTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CountrySearchTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSString *titleText;

- (void)selectedIconImageView:(BOOL)select;

@end

