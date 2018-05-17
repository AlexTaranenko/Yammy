//
//  AllActivityTableSectionView.h
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllActivityTableSectionView : UIView

+ (AllActivityTableSectionView *)setupAllActivityTableSectionView;

- (void)prepareTitleLabelByText:(NSString *)text;

@end

