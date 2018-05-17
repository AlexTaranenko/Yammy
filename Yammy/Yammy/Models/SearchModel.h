//
//  SearchModel.h
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  AllShowingUsers = 0,
  OnlineShowingUsers,
  NewShowingUsers,
} ShowingUsersEnum;

@interface SearchModel : NSObject

@property (strong, nonatomic) NSMutableArray *orientationsArray;

@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;
@property (strong, nonatomic) NSNumber *genderId;

@property (strong, nonatomic) NSNumber *showingUsers;

//@property (strong, nonatomic) NSMutableArray *locationsArray;

@property (strong, nonatomic) NSNumber *Latitude;
@property (strong, nonatomic) NSNumber *Longitude;
@property (strong, nonatomic) NSString *City;

@property (strong, nonatomic) NSMutableArray *preferencesArray;

@property (strong, nonatomic) NSNumber *searchType;

- (instancetype)init;

- (void)saveParamsWithSearchModel:(SearchModel *)searchModel;

- (SearchModel *)savedSearchModel;

- (void)selectOrientationByIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)filteredOrientationsArrayByIndexPath:(NSIndexPath *)indexPath;

- (void)selectCountryByIdLocation:(NSNumber *)locationId;

- (NSArray *)filteredCountriesArrayByIdLocation:(NSNumber *)locationId;

- (NSArray *)filteredOrientationsArrayById:(NSNumber *)idDictionary;

@end

