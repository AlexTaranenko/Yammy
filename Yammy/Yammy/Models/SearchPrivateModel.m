//
//  SearchPrivateModel.m
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SearchPrivateModel.h"

@implementation SearchPrivateModel

- (instancetype)init {
  self = [super init];
  
  if (self) {
    self.coincidenceUsers = @(MaximumCoincidenceUsers);
    self.minAge = @(18);
    self.maxAge = @(22);
    self.genderId = nil;
    self.countriesArray = [NSMutableArray new];
    self.preferencesArray = [NSMutableArray new];
    [self saveParamsWithSearchPrivateModel:self];
  }
  
  return self;
}

- (void)saveParamsWithSearchPrivateModel:(SearchPrivateModel *)searchPrivateModel {
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:searchPrivateModel];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SearchPrivateModel"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SearchPrivateModel *)savedSearchPrivateModel {
  NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchPrivateModel"];
  SearchPrivateModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  return model;
}

- (void)selectOrientationByIndexPath:(NSIndexPath *)indexPath {
  self.genderId = @(indexPath.row);
}

- (void)selectCountryByIdLocation:(NSNumber *)locationId {
  if ([locationId integerValue] == 1) {
    [self.countriesArray removeAllObjects];
    [self.countriesArray addObject:locationId];
  } else {
    NSArray *filteredNoLocationArray = [self.countriesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", @(1)]];
    if (filteredNoLocationArray.count > 0) {
      [self.countriesArray removeAllObjects];
      [self.countriesArray addObject:locationId];
    } else {
      NSArray *filteredArray = [self.countriesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", locationId]];
      [self setupMutableArray:self.countriesArray withFilteredArray:filteredArray andLocation:locationId];
    }
  }
}

- (NSArray *)filteredCountriesArrayByIdLocation:(NSNumber *)locationId {
  NSArray *filteredArray = [self.countriesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", locationId]];
  return filteredArray;
}

- (void)setupMutableArray:(NSMutableArray *)mutableArray withFilteredArray:(NSArray *)filteredArray andLocation:(NSNumber *)locationId {
  if (filteredArray.count > 0) {
    NSNumber *number = (NSNumber *)[filteredArray lastObject];
    NSInteger index = [mutableArray indexOfObject:number];
    [mutableArray removeObjectAtIndex:index];
  } else {
    [mutableArray addObject:locationId];
  }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.coincidenceUsers forKey:@"coincidenceUsers"];
  [aCoder encodeObject:self.preferencesArray forKey:@"preferencesArray"];
  [aCoder encodeObject:self.minAge forKey:@"minAge"];
  [aCoder encodeObject:self.maxAge forKey:@"maxAge"];
  [aCoder encodeObject:self.countriesArray forKey:@"countriesArray"];
  [aCoder encodeObject:self.genderId forKey:@"genderId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self.coincidenceUsers = [aDecoder decodeObjectForKey:@"coincidenceUsers"];
    self.preferencesArray = [aDecoder decodeObjectForKey:@"preferencesArray"];
    self.minAge = [aDecoder decodeObjectForKey:@"minAge"];
    self.maxAge = [aDecoder decodeObjectForKey:@"maxAge"];
    self.countriesArray = [aDecoder decodeObjectForKey:@"countriesArray"];
    self.genderId = [aDecoder decodeObjectForKey:@"genderId"];
  }
  return self;
}

@end

