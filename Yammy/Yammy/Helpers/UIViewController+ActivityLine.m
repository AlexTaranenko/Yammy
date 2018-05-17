//
//  UIViewController+ActivityLine.m
//  Yammy
//
//  Created by Alex on 12/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "UIViewController+ActivityLine.h"
#import <objc/runtime.h>
#import "LikesViewController.h"
#import "ConcurrencesViewController.h"
#import "AllActivityViewController.h"

static void *AssociationTopRefreshControl = &AssociationTopRefreshControl;

@implementation UIViewController (ActivityLine)

#pragma mark - Setters and Getters

- (UIRefreshControl *)topRefreshControl {
  return objc_getAssociatedObject(self, AssociationTopRefreshControl);
}

- (void)setTopRefreshControl:(UIRefreshControl *)topRefreshControl {
  objc_setAssociatedObject(self, &AssociationTopRefreshControl, topRefreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public

- (void)setupRefreshControlsByTableView:(UITableView *)tableView {
  self.topRefreshControl = [UIRefreshControl new];
  [self.topRefreshControl addTarget:self action:@selector(refreshTop) forControlEvents:UIControlEventValueChanged];
  [tableView addSubview:self.topRefreshControl];
  
  UIRefreshControl *bottomRefreshControl = [UIRefreshControl new];
  [bottomRefreshControl addTarget:self action:@selector(refreshBottom) forControlEvents:UIControlEventValueChanged];
  bottomRefreshControl.triggerVerticalOffset = 120;
  tableView.bottomRefreshControl = bottomRefreshControl;
}

#pragma mark - Actions

- (void)refreshTop {
  if ([self isKindOfClass:[LikesViewController class]]) {
    [(LikesViewController *)self loadMoreLikesByIsTopScroll:YES];
  } else if ([self isKindOfClass:[ConcurrencesViewController class]]) {
    [(ConcurrencesViewController *)self loadMoreMatchesByIsTopScroll:YES];
  } else if ([self isKindOfClass:[AllActivityViewController class]]) {
    [(AllActivityViewController *)self loadMoreActivityLinesByIsTopScroll:YES];
  }
}

- (void)refreshBottom {
  if ([self isKindOfClass:[LikesViewController class]]) {
    [(LikesViewController *)self loadMoreLikesByIsTopScroll:NO];
  } else if ([self isKindOfClass:[ConcurrencesViewController class]]) {
    [(ConcurrencesViewController *)self loadMoreMatchesByIsTopScroll:NO];
  } else if ([self isKindOfClass:[AllActivityViewController class]]) {
    [(AllActivityViewController *)self loadMoreActivityLinesByIsTopScroll:NO];
  }
}

@end

