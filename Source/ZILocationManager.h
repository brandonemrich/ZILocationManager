/*
 *  ZILocationManager.m
 *  ZILocationManger
 *
 *  Created by Brandon Emrich on 6/18/12.
 *  Copyright (c) 2012 Zueos, Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void (^ZILocationManagerCallback)(CLLocation *);
typedef void (^ZILocationManagerRegionChangeCallback)(CLRegion *);
typedef void (^ZILocationManagerErrorCallback)(NSError *);

@interface ZILocationManager : NSObject <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, copy) ZILocationManagerCallback locationUpdatedBlock;
@property (nonatomic, copy) ZILocationManagerErrorCallback locationErrorBlock;
@property (nonatomic, copy) ZILocationManagerRegionChangeCallback regionChangeBlock;

@property (nonatomic, retain) CLLocationManager * locationManager;

@property (nonatomic, retain) CLLocation * currentLocation;
@property (nonatomic, retain) CLLocation * stubbedLocation;

- (id)initWithFakeLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

- (BOOL) startMonitoringRegionWithCenter:(CLLocationCoordinate2D)coordinate radius:(CLLocationDegrees)radius andIdentifier:(NSString*)identifier;

- (void)findLocation;

@end