//
//  OrientationRegisterTableViewCell.h
//  Yammy
//
//  Created by Alex on 8/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrientationRegisterTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dictionary;

- (void)prepareNameByGenderMapping:(DictionaryMapping *)mapping;

//- (void)prepareImageIconByImageName:(NSString *)imageName;

- (void)selectedCheckBoxImageView:(BOOL)select;

- (void)selectSquareCheckBox:(BOOL)select;

@end

