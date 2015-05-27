//
//  AugmentOverlayView.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/20/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "AugmentOverlayView.h"
#import "AnnotationView.h"


@interface AugmentOverlayView ()

@property (nonatomic) CGRect fieldOfView;
@property (nonatomic, strong) NSMutableArray* annotationsArray;

@end

@implementation AugmentOverlayView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        
        _annotationsArray = [NSMutableArray new];
        _currentQuadrant = HEADINGQUADARANT_NE;
        
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

- (void) setPlaces:(Places *)places
{
    _places = places;
    
    [self drawAnnotations];
}

- (void) setHeading:(CLLocationDirection)heading
{
    _heading = heading;
    
    [self headingQuadFromHeading:_heading];
    
    [self showAnnotationsForCurrentFieldOfView];
}

- (void) headingQuadFromHeading:(CLLocationDirection)heading
{
    if (heading < MAGNETIC_NORTH) {
        self.currentQuadrant = HEADINGQUADARANT_UNKNOWN;
        return;
    }
    
    if (heading >= MAGNETIC_NORTH && heading <= MAGNETIC_EAST) {
        self.currentQuadrant = HEADINGQUADARANT_NE;
        return;
    }
    
    if (heading >= MAGNETIC_EAST && heading <= MAGNETIC_SOUTH) {
        self.currentQuadrant = HEADINGQUADARANT_SE;
        return;
    }
    
    if (heading >= MAGNETIC_SOUTH  && heading <= MAGNETIC_WEST) {
        self.currentQuadrant = HEADINGQUADARANT_SW;
        return;
    }
    
    if (heading >= MAGNETIC_WEST) {
        self.currentQuadrant = HEADINGQUADARANT_NW;
        return;
    }
    
    
}

- (HEADINGQUADARANT) headingQuadFromMagLocation:(MAGNETIC_)latLoc longLoc:(MAGNETIC_)longLoc
{
    if (latLoc == MAGNETIC_NORTH && longLoc == MAGNETIC_EAST) {
        return HEADINGQUADARANT_NE;
    }
    
    if (latLoc == MAGNETIC_NORTH && longLoc == MAGNETIC_WEST) {
        return HEADINGQUADARANT_NW;
    }
    
    if (latLoc == MAGNETIC_SOUTH && longLoc == MAGNETIC_EAST) {
        return HEADINGQUADARANT_SE;
    }
    
    if (latLoc == MAGNETIC_SOUTH && longLoc == MAGNETIC_WEST) {
        return HEADINGQUADARANT_SW;
    }
    
    
    return HEADINGQUADARANT_NE;
    
}
- (void) drawAnnotations
{
    
    for (UIView* sview in self.annotationsArray) {
        [sview removeFromSuperview];
    }
    
    [self.annotationsArray removeAllObjects];
    
    CGFloat aviewY = 20;
    
    for (Place* place in self.places.places) {
        AnnotationView* aView = [[AnnotationView alloc] initWithFrame:CGRectMake(40, aviewY, CGRectGetWidth(self.frame), 40)];
        [aView setPlace:place];
        [self addSubview:aView];
        
        [aView setHidden:YES];
        
        [self.annotationsArray addObject:aView];
        
        aviewY = CGRectGetMaxY(aView.frame);
        
        __weak AugmentOverlayView* weakself = self;
        [aView setShowAlert:^(NSString *showMessage) {
            [weakself.overlayDelegate showMessage:showMessage];
        }];
    }
    
    [self showAnnotationsForCurrentFieldOfView];

}

- (void) showAnnotationsForCurrentFieldOfView
{
    for (AnnotationView* aView in self.annotationsArray) {
        if (self.currentQuadrant == aView.place.actualDirection) {
            [aView setHidden:NO];
        }
        else{
            [aView setHidden:YES];
        }
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
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
@end
