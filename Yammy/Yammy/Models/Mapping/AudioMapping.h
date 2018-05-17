//
//  AudioMapping.h
//  Yammy
//
//  Created by Alex on 12/27/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioMapping : NSObject

@property (strong, nonatomic) NSNumber *IdAudio;
@property (strong, nonatomic) NSString *Url;

+ (RKObjectMapping *)objectMapping;

@end

