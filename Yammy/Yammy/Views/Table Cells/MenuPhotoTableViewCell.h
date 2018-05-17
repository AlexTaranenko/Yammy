//
//  MenuPhotoTableViewCell.h
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kMenuPhotoCellIdentifier = @"menuPhotoCell";

@interface MenuPhotoTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dictionary;

@end
