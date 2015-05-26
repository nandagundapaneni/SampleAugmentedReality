//
//  AugmentViewController.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/20/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//


#import "AugmentViewController.h"
#import "AugmentOverlayView.h"
#import "PlacesDataController.h"
#import "Place.h"


static const double Radius = 1000;

@interface AugmentViewController ()<CLLocationManagerDelegate,OverlayProtocol>

@property (nonatomic,strong) AugmentOverlayView* overlayView;
@property (nonatomic, assign) CLLocationDirection currentHeading;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) Places* currentPlacesData;
@property (nonatomic, strong) NSMutableArray* annotationsArray;

@end

@implementation AugmentViewController


- (id) init
{
    self = [super init];
    
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.showsCameraControls = NO;
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
            self.cameraViewTransform = translate;
            
            CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
            self.cameraViewTransform = scale;
            
        }
        
        
        self.annotationsArray = [NSMutableArray new];

    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.cameraOverlayView = self.overlayView;
    }
    
    [self.view insertSubview:self.overlayView atIndex:0];
    
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.overlayView goToUserLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (AugmentOverlayView*) overlayView
{
    if (_overlayView == nil) {
        _overlayView = [[AugmentOverlayView alloc] initWithFrame:[UIScreen mainScreen].nativeBounds];
        _overlayView.locationManager.delegate = self;
        _overlayView.overlayDelegate = self;
    }
    
    return _overlayView;
}

#pragma mark - CLLocationManagerDelegate Methods


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        self.currentLocation = newLocation;
        
        [[PlacesDataController manager] retrievePlacesOfInterestForLocation:currentLocation inRadius:Radius onCompletion:^(Places *placesData, NSError *error) {
            
            self.currentPlacesData = placesData;
            
            [self.overlayView setPlaces:self.currentPlacesData];
        }];
        
        
        
        [self.overlayView.locationManager stopUpdatingLocation];
        [self.overlayView.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0)
    {return;}
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    self.currentHeading = theHeading;
    
}

#pragma mark - Overlay Delegate

- (void) showMessage:(NSString *)message
{
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"Details" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [ac dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [ac addAction:cancel];
    
    [self presentViewController:ac animated:YES completion:nil];
}

@end
