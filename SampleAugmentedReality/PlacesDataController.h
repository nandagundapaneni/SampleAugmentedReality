//
//  PlacesDataController.h
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/21/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "Place.h"


@interface PlacesDataController : AFHTTPRequestOperationManager


- (void) retrievePlacesOfInterestForLocation:(CLLocation*)currentLocation inRadius:(double)radius onCompletion:(void (^)(Places *placesData, NSError *error))onCompletion;

@end
