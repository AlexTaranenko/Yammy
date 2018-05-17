//
//  AllCoincidenceTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLineMapping.h"

static NSString *const kAllCoincidenceCellOneIdentifier = @"allCoincidenceCellOne";
static NSString *const kAllCoincidenceCellTwoIdentifier = @"allCoincidenceCellTwo";
static NSString *const kAllCoincidenceCellThreeIdentifier = @"allCoincidenceCellThree";
static NSString *const kAllCoincidenceCellMoreIdentifier = @"allCoincidenceCellMore";

typedef enum : NSUInteger {
  OnePreference = 1,
  TwoPreference,
  ThreePreference,
  MorePreference
} PreferencesArrayCount;

@protocol AllCoincidenceTableViewCellDelegate <NSObject>

@optional

- (void)openChatByCell:(UITableViewCell *)cell;

@end

@interface AllCoincidenceTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AllCoincidenceTableViewCellDelegate> delegate;

- (void)prepareAllCoincidenceCellByMatchMapping:(MatchMapping *)matchMapping;

@end

