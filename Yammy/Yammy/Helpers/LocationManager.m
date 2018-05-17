//
//  LocationManager.m
//  Yammy
//
//  Created by Alex on 01.12.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LocationManager.h"

static NSInteger kSecondsToUpdateLocation = 60;

@interface LocationManager()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationManager
{
    BOOL _locationUpdated;
}

+ (LocationManager *)sharedManager {
    static LocationManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [LocationManager new];
        manager->_locationUpdated = NO;
    });
    
    return manager;
}

- (void)setupLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    } else {
        // TODO: Alert please enable locations
    }
    
    [NSTimer scheduledTimerWithTimeInterval:kSecondsToUpdateLocation repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (!_locationUpdated && self.location != nil && [Helpers getAccessToken] != nil) {
            [[ServerManager sharedManager] updateProfileWithParams:@{@"Token" : [Helpers getAccessToken], @"Latitude" : @(self.location.coordinate.latitude), @"Longitude" : @(self.location.coordinate.longitude)}
                                                    withCompletion:^(BOOL status, NSString *errorMessage) {
                                                        _locationUpdated = status;
                                                    }];
        }
    }];
}

- (void)startUpdateLocations {
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdateLocations {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      [UIAlertHelper alert:@"Пожалуйста, включите службы на основе местоположения для получения лучших результатов!" title:@"Геолокация отключена." cancelButton:@"Отмена" successButton:@"Настройки" successCompletion:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
          [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
          
        }
      }];
    });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: break;
        case kCLAuthorizationStatusRestricted: break;
        case kCLAuthorizationStatusDenied: break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            [self startUpdateLocations];
        } break;
            
        default:
            
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.location = [locations lastObject];
    _locationUpdated = NO;
    NSLog(@"Latitude: %f", self.location.coordinate.latitude);
    NSLog(@"Longitude: %f", self.location.coordinate.longitude);
}

@end

