//
//  AugmentOverlayView.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/20/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "AugmentOverlayView.h"


@interface AugmentOverlayView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) CGRect fieldOfView;
@property (nonatomic, strong) NSMutableArray* annotationsArray;
@property (nonatomic, strong) NSMutableArray* visiblePlacesArray;
@property (nonatomic, strong) UITableView* placesTableView;

@end

@implementation AugmentOverlayView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        
        _annotationsArray = [NSMutableArray new];
        _visiblePlacesArray = [NSMutableArray new];
        _currentQuadrant = HEADINGQUADARANT_NE;
        
        [self addSubview:self.placesTableView];
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

- (UITableView*) placesTableView
{
    if (_placesTableView == nil) {
        _placesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-50) style:UITableViewStylePlain];
        [_placesTableView setBackgroundColor:[UIColor clearColor]];
        [_placesTableView setTableFooterView:[UIView new]];
        [_placesTableView setDataSource:self];
        [_placesTableView setDelegate:self];
        [_placesTableView setHidden:YES];
        [_placesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return _placesTableView;
}

#pragma mark - UITableView Datasource and Delegate Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.visiblePlacesArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const cellIdentifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [cell.textLabel setFont:[UIFont fontWithName:@"SanFranciscoRounded-Medium" size:16.0]];
    }
    
    Place* place = self.visiblePlacesArray[indexPath.row];
    
    [cell.textLabel setText:place.name];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place* place = self.visiblePlacesArray[indexPath.row];
    
    NSString* message = [NSString stringWithFormat:@"NAME:%@\nADDRESS:%@",place.name,place.vicinityAddress];
    
    [self.overlayDelegate showMessage:message];
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
    
    [self.placesTableView setHidden:NO];
    [self showAnnotationsForCurrentFieldOfView];

}

- (void) showAnnotationsForCurrentFieldOfView
{
    [self.visiblePlacesArray removeAllObjects];
    
    for (Place* place in self.places.places) {
        if (self.currentQuadrant == place.actualDirection) {
            [self.visiblePlacesArray addObject:place];
        }
    }
    
    [self.placesTableView reloadData];
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
