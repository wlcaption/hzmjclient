//
//  LocationService.h
//  Unity-iPhone
//
//  Created by wangyan on 17/6/8.
//
//
#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface LocationService : NSObject<AMapLocationManagerDelegate> {
    AMapLocationManager * locationManager;
}

// get instance
+ (LocationService*)instance;

// start location
- (void)startLocation;

// end location
- (void)endLocation;

// pay
@end
