//
//  AugmentOverlayView.h
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/20/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@protocol AccelarometerUpdatesProtocol <NSObject>

- (void) accelarometerData:(CMAccelerometerData*)data error:(NSError*)error;

@end
@interface AugmentOverlayView : UIView

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CMMotionManager* motionManger;

@property (nonatomic,weak) id<AccelarometerUpdatesProtocol> accelDelegate;

- (void) goToUserLocation;
- (void) startMotionManager;

@end
