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

@interface AugmentViewController ()<CLLocationManagerDelegate,AccelarometerUpdatesProtocol>

@property (nonatomic,strong) AugmentOverlayView* overlayView;

@end

@implementation AugmentViewController


- (id) init
{
    self = [super init];
    
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.view.contentMode = UIViewContentModeScaleAspectFill;
        self.showsCameraControls = NO;
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
        self.cameraViewTransform = translate;
        
        CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
        self.cameraViewTransform = scale;

    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cameraOverlayView = self.overlayView;
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.overlayView goToUserLocation];
    [self.overlayView startMotionManager];
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
        _overlayView.accelDelegate = self;
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
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        [[PlacesDataController manager] retrievePlacesOfInterestForLocation:currentLocation inRadius:500 onCompletion:^(Places *placesData, NSError *error) {
            
            NSLog(@"RESPONSE %@\nERROR %@ HEADING %@",placesData,error,self.overlayView.locationManager.heading);
        }];
        
        [self.overlayView.locationManager stopUpdatingLocation];
        [self.overlayView.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
}
- (void) accelarometerData:(CMAccelerometerData *)data error:(NSError *)error
{
    NSLog(@"GYRO %@",data);
}

@end
