//
//  AugmentOverlayView.h
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/20/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Place.h"

@class Places;

@protocol OverlayProtocol <NSObject>

- (void) showMessage:(NSString*)message;
- (void) doneTapped;

@end


@interface AugmentOverlayView : UIView

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) Places* places;
@property (nonatomic) CLLocationDirection heading;
@property (nonatomic,weak) id<OverlayProtocol> overlayDelegate;
@property (nonatomic) HEADINGQUADARANT currentQuadrant;

- (void) goToUserLocation;


@end
