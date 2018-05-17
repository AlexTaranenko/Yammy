//
//  AboutViewController.m
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *textImageView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = self.navTitle;
  
  [self prepareBackBarButtonItem];
  
  self.textImageView.image = [self.textImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)oneButtonViewDidTap:(UITapGestureRecognizer *)sender {
  
}

- (IBAction)twoButtonViewDidTap:(UITapGestureRecognizer *)sender {
  
}

- (IBAction)threeButtonViewDidTap:(UITapGestureRecognizer *)sender {
  
}

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
