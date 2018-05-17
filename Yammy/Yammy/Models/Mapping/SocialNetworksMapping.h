//
//  SocialNetworksMapping.h
//  Yammy
//
//  Created by Alex on 11/8/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialNetworksMapping : NSObject

@property (strong, nonatomic) NSNumber *facebookId;
@property (strong, nonatomic) NSNumber *googleId;
@property (strong, nonatomic) NSNumber *twitterId;

+ (RKObjectMapping *)objectMapping;

@end

