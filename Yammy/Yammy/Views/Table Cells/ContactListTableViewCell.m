//
//  ContactListTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/11/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ContactListTableViewCell.h"
#import "UITextView+Placeholder.h"

@interface ContactListTableViewCell()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation ContactListTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareContactCellByContactMapping:(ContactMapping *)contactMapping {
  NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14.0],
                               NSForegroundColorAttributeName : RGB(204, 204, 204)};
  self.textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Добавьте заметку" attributes:attributes];
  self.textView.delegate = self;
  self.textView.text = contactMapping.Note;
  self.nameLabel.text = contactMapping.ContactUser.FirstName;//[NSString stringWithFormat:@"%@, %ld", contactMapping.ContactUser.FirstName, (long)[self calculateYearByTimeStamp:contactMapping.ContactUser.BirthDate]];
  [self preparePhotoImageByImageMapping:contactMapping.ContactUser.PrimaryPhoto];
  [self prepareGestureOfLabel];
  [self.editButton setImage:[UIImage imageNamed:@"contact_list_pencil_icon"] forState:UIControlStateNormal];
}

- (void)prepareGestureOfLabel {
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [self.nameLabel addGestureRecognizer:tapGestureRecognizer];
  self.nameLabel.userInteractionEnabled = YES;
}

- (NSInteger)calculateYearByTimeStamp:(NSNumber *)timeStamp {
  NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:fromDate toDate:[NSDate date] options:0];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  return [components year];
}

- (void)preparePhotoImageByImageMapping:(ImageMapping *)imageMapping {
  NSString *urlPath = imageMapping.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *url = [NSURL URLWithString:urlString];
  if (url) {
    [self.photoImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)textViewDidChange:(UITextView *)textView {
  self.contactMapping.Note = textView.text;
  
  if (self.delegate != nil) {
    [self.delegate updateTableViewCell:self];
  }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  [self.editButton setImage:[UIImage imageNamed:@"accept_edit_contact_icon"] forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  [self.editButton setImage:[UIImage imageNamed:@"contact_list_pencil_icon"] forState:UIControlStateNormal];
}

#pragma mark - Action

- (void)labelTapped {
  if (self.delegate != nil) {
    [self.delegate openProfileByCell:self];
  }
}

- (IBAction)editDidTap:(UIButton *)sender {
  if ([self.textView isFirstResponder]) {
    [self.textView resignFirstResponder];
    if (self.delegate != nil) {
      [self.delegate editContactByContactMapping:self.contactMapping];
    }
  } else {
    [self.textView becomeFirstResponder];
  }
}

- (IBAction)deleteDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate deleteContactByContactMapping:self.contactMapping];
  }
}

- (IBAction)openProfileDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openProfileByCell:self];
  }
}

@end

