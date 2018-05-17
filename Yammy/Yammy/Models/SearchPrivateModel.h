//
//  SearchPrivateModel.h
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  MaximumCoincidenceUsers = 10,
  AnyCoincidenceUsers,
} CoincidenceUsersEnum;

@interface SearchPrivateModel : NSObject

@property (strong, nonatomic) NSNumber *coincidenceUsers;

@property (strong, nonatomic) NSNumber *minAge;

@property (strong, nonatomic) NSNumber *maxAge;

@property (strong, nonatomic) NSNumber *genderId;

@property (strong, nonatomic) NSMutableArray *countriesArray;

@property (strong, nonatomic) NSMutableArray *preferencesArray;

- (instancetype)init;

- (void)saveParamsWithSearchPrivateModel:(SearchPrivateModel *)searchPrivateModel;

- (SearchPrivateModel *)savedSearchPrivateModel;

- (void)selectOrientationByIndexPath:(NSIndexPath *)indexPath;

- (void)selectCountryByIdLocation:(NSNumber *)locationId;

- (NSArray *)filteredCountriesArrayByIdLocation:(NSNumber *)locationId;

@end

