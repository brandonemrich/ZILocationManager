/*
 *  ZILocationManager.m
 *  ZILocationManger
 *
 *  Created by Brandon Emrich on 6/18/12.
 *  Copyright (c) 2012 Zueos, Inc. All rights reserved.
 *
 *  
 *
 *
 *
*/

#import "ZILocationManager.h"

@implementation ZILocationManager

@synthesize locationManager, currentLocation, locationUpdatedBlock,locationErrorBlock, regionChangeBlock, stubbedLocation;

- (id)init {
    
    if ((self = [super init])) {
        
        // Setup the location manager 
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter = kCLDistanceFilterNone; // or whatever
        
    }
    
    return self;
    
}

- (id)initWithFakeLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    
    if ((self = [self init])) {
        stubbedLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    }
    
    return self;
    
}


- (void)findLocation {
    
    if (self.stubbedLocation) {
        [self locationManager:self.locationManager didUpdateToLocation:self.stubbedLocation fromLocation:nil];
    } else {
        [self.locationManager startUpdatingLocation];
    }
    
}

- (BOOL) startMonitoringRegionWithCenter:(CLLocationCoordinate2D)coordinate radius:(CLLocationDegrees)radius andIdentifier:(NSString*)identifier {
    // Do not create regions if support is unavailable or disabled.
    if ( ![CLLocationManager regionMonitoringAvailable] || ![CLLocationManager regionMonitoringEnabled] )
        return NO;
    
    CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter:coordinate radius:radius identifier:identifier];
    [self.locationManager startMonitoringForRegion:region
                              desiredAccuracy:kCLLocationAccuracyBest];
    
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // Test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 10.0) return;
    
    // Test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
//    if ([self.currentLocation distanceFromLocation:newLocation] >= 1.0) {
//        self.regionChangeBlock(newLocation);
//        self.currentLocation = newLocation;
//        return;
//    }
    
    // Store the new location
    self.currentLocation = newLocation;
    
    // Call the location updated block
    if (self.locationUpdatedBlock)
        self.locationUpdatedBlock(newLocation);
    
    // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
    //[self.locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    // Call the location error block
    if (self.locationErrorBlock) {
        self.locationErrorBlock(error);
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    self.regionChangeBlock(region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
   NSLog(@"Exited Region"); 
}

@end
