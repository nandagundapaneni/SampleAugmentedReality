//
//  AugmentOverlayView.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/20/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "AugmentOverlayView.h"
#import "Place.h"
#import "AnnotationView.h"


@interface AugmentOverlayView ()

@property (nonatomic) CGRect fieldOfView;


@end

@implementation AugmentOverlayView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        
        //[self addSubview:self.locationLabel];
    }
    
    return self;
}

- (CLLocationManager*)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [CLLocationManager new];
    }
    
    return _locationManager;
}

- (CMMotionManager*)motionManger
{
    if (_motionManger == nil) {
        _motionManger = [CMMotionManager new];
    }
    
    return _motionManger;
}

- (void) calculateFieldOfView
{
    
}

- (void) goToUserLocation
{
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager setDistanceFilter:10.0];
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager setHeadingFilter:5];
    [self.locationManager startUpdatingHeading];
}

- (void) startMotionManager
{
    if([self.motionManger isAccelerometerAvailable])
    {
        if([self.motionManger isAccelerometerActive] == NO)
        {

            [self.motionManger setAccelerometerUpdateInterval:5.0f];
            

            [self.motionManger startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                [self.overlayDelegate accelarometerData:accelerometerData error:error];
            }];
             
    }
    else
    {
        NSLog(@"Accelerometer not Available!");
    }
    
    }

}

@end
