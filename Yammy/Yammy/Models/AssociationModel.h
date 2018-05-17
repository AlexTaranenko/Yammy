//
//  AssociationModel.h
//  Yammy
//
//  Created by Alex on 06.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssociationModel : NSObject

@property (strong, nonatomic) NSMutableArray *circlesArray;

@property (strong, nonatomic) NSMutableArray *addedCirclesArray;

- (instancetype)init;

- (void)prepareCirclesArray:(NSArray *)array;

- (void)prepareAddedCirclesArrayByArray:(NSArray *)addedArray;

- (void)filteredCirclesArray;

@end


