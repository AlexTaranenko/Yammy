//
//  SearchModel.m
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

- (instancetype)init {
  self = [super init];
  
  if (self) {
    self.orientationsArray = [NSMutableArray new];
    self.minAge = @(18);
    self.maxAge = @(22);
    self.genderId = nil;
    self.showingUsers = @(AllShowingUsers);
    self.Latitude = nil;
    self.Longitude = nil;
    self.City = nil;
    self.searchType = nil;
    self.preferencesArray = [NSMutableArray new];
    [self saveParamsWithSearchModel:self];
  }
  
  return self;
}

- (void)saveParamsWithSearchModel:(SearchModel *)searchModel {
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:searchModel];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SearchModel"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SearchModel *)savedSearchModel {
  NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchModel"];
  SearchModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  return model;
}

- (void)selectOrientationByIndexPath:(NSIndexPath *)indexPath {
  self.genderId = @(indexPath.row);
}

- (NSArray *)filteredOrientationsArrayByIndexPath:(NSIndexPath *)indexPath {
  NSArray *filteredArray = [self.orientationsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %d", indexPath.row]];
  return filteredArray;
}

- (NSArray *)filteredOrientationsArrayById:(NSNumber *)idDictionary {
  NSArray *filteredArray = [self.orientationsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", idDictionary]];
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
  [aCoder encodeObject:self.orientationsArray forKey:@"orientationsArray"];
  [aCoder encodeObject:self.minAge forKey:@"minAge"];
  [aCoder encodeObject:self.maxAge forKey:@"maxAge"];
  [aCoder encodeObject:self.genderId forKey:@"genderId"];
  [aCoder encodeObject:self.showingUsers forKey:@"showingUsers"];
  [aCoder encodeObject:self.Latitude forKey:@"Latitude"];
  [aCoder encodeObject:self.Longitude forKey:@"Longitude"];
  [aCoder encodeObject:self.City forKey:@"City"];
  [aCoder encodeObject:self.preferencesArray forKey:@"preferencesArray"];
  [aCoder encodeObject:self.searchType forKey:@"searchType"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self.orientationsArray = [aDecoder decodeObjectForKey:@"orientationsArray"];
    self.minAge = [aDecoder decodeObjectForKey:@"minAge"];
    self.maxAge = [aDecoder decodeObjectForKey:@"maxAge"];
    self.showingUsers = [aDecoder decodeObjectForKey:@"showingUsers"];
    self.genderId = [aDecoder decodeObjectForKey:@"genderId"];
    self.Latitude = [aDecoder decodeObjectForKey:@"Latitude"];
    self.Longitude = [aDecoder decodeObjectForKey:@"Longitude"];
    self.City = [aDecoder decodeObjectForKey:@"City"];
    self.preferencesArray = [aDecoder decodeObjectForKey:@"preferencesArray"];
    self.searchType = [aDecoder decodeObjectForKey:@"searchType"];
  }
  return self;
}

@end

