//
//  GeoSearchViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "GeoSearchViewController.h"

@interface GeoSearchViewController ()

@end

@implementation GeoSearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"GEO SEARCH";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)searchDidTap:(UIButton *)sender {
  [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
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
