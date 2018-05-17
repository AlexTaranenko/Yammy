//
//  AssociationModel.m
//  Yammy
//
//  Created by Alex on 06.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AssociationModel.h"

@implementation AssociationModel

- (instancetype)init {
  self = [super init];
  
  if (self) {
    
  }
  
  return self;
}

- (void)prepareCirclesArray:(NSArray *)array {
  [self.circlesArray removeAllObjects];
  [self.circlesArray addObjectsFromArray:array];
}

- (void)prepareAddedCirclesArrayByArray:(NSArray *)addedArray {
  [self.addedCirclesArray removeAllObjects];
  [self.addedCirclesArray addObjectsFromArray:addedArray];
}

- (void)filteredCirclesArray {
  for (PreferencesMapping *mapping in self.addedCirclesArray) {
    NSArray *filteredArray = [self.circlesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdPreferences == %@", mapping.IdPreferences]];
    if (filteredArray.count > 0) {
      PreferencesMapping *filteredMapping = (PreferencesMapping *)[filteredArray firstObject];
      NSInteger index = [self.circlesArray indexOfObject:filteredMapping];
      [self.circlesArray removeObjectAtIndex:index];
    }
  }
}

- (NSMutableArray *)circlesArray {
  if (_circlesArray == nil) {
    _circlesArray = [NSMutableArray new];
  }
  return _circlesArray;
}

- (NSMutableArray *)addedCirclesArray {
  if (_addedCirclesArray == nil) {
    _addedCirclesArray = [NSMutableArray new];
  }
  return _addedCirclesArray;
}


@end

