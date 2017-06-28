//
//  LocationService.mm
//  Unity-iPhone
//
//  Created by wangyan on 17/6/8.
//
//

#import "LocationService.h"
#import "JSONKit.h"


extern "C" void _StartLocation() {
    [[LocationService instance] startLocation];
}

extern "C" void _EndLocation() {
    [[LocationService instance] endLocation];
}

static LocationService* instance_ = nil;

@interface LocationService ()
@end

@implementation LocationService

// get instance
+ (LocationService*)instance {
    if (!instance_) {
        instance_ = [[self alloc] init];
        [AMapServices sharedServices].apiKey =@"732ceb79366470152563c70a2016f255";
        instance_->locationManager = [[AMapLocationManager alloc] init];
        instance_->locationManager.delegate = self;
        [instance_->locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        instance_->locationManager.locationTimeout =2;
        instance_->locationManager.reGeocodeTimeout = 2;
        instance_->locationManager.locatingWithReGeocode = YES;
    }
    return instance_;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"status"];
    [self onLocationChanged:[json JSONString]];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode) {
        NSLog(@"reGeocode:%@", reGeocode);
    }
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"status"];
    [json setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
    [json setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
    [json setObject:reGeocode.formattedAddress forKey:@"address"];
    [self onLocationChanged:[json JSONString]];
}

- (void)startLocation {
    //[locationManager setLocatingWithReGeocode:YES];
    //[locationManager startUpdatingLocation];
    
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                NSMutableDictionary* json = [NSMutableDictionary dictionary];
                [json setObject:[NSString stringWithFormat:@"%d",0] forKey:@"status"];
                [self onLocationChanged:[json JSONString]];
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            NSMutableDictionary* json = [NSMutableDictionary dictionary];
            [json setObject:[NSString stringWithFormat:@"%d",1] forKey:@"status"];
            [json setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
            [json setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
            [json setObject:regeocode.formattedAddress forKey:@"address"];
            [self onLocationChanged:[json JSONString]];
        }
    }];
}

- (void)endLocation {
    [locationManager stopUpdatingLocation];
}

// on location changed
- (void)onLocationChanged:(NSString*)message {
    UnitySendMessage([@"Canvas" cStringUsingEncoding:NSASCIIStringEncoding],
                     [@"OnLocationChanged" cStringUsingEncoding:NSASCIIStringEncoding],
                     [message cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end