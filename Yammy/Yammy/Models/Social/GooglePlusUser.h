//
//  GooglePlusUser.h
//  Yammy
//
//  Created by Alex on 12.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface GooglePlusUser : NSObject

@property (strong, nonatomic) GIDGoogleUser *user;

@property (strong, nonatomic) NSString *picture;
@property (strong, nonatomic) NSString *gender;


@end
