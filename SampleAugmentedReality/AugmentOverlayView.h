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

@class Places;


@protocol OverlayProtocol <NSObject>

- (void) accelarometerData:(CMAccelerometerData*)data error:(NSError*)error;
- (void) showMessage:(NSString*)message;

@end
@interface AugmentOverlayView : UIView

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CMMotionManager* motionManger;
@property (nonatomic, strong) Places* places;
@property (nonatomic,weak) id<OverlayProtocol> overlayDelegate;

- (void) goToUserLocation;
- (void) startMotionManager;

@end
