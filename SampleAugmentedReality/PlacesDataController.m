//
//  PlacesDataController.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/21/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "PlacesDataController.h"
#import "Place.h"
#import <CoreLocation/CoreLocation.h>

static NSString * const API_KEY = @"AIzaSyCKfmw7eQx4at3bxcTtKhkL_6M1-LxqKt8";
static NSString * const BaseURLString = @"https://maps.googleapis.com/maps/api/place/search/json?sensor=true";

@implementation PlacesDataController


+ (instancetype)manager {
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
}


- (void) retrievePlacesOfInterestForLocation:(CLLocation*)currentLocation inRadius:(double)radius onCompletion:(void (^)(Places *placesData, NSError *error))onCompletion
{
    NSString* urlString = [NSString stringWithFormat:@"%@&location=%f,%f&radius=%f&key=%@",BaseURLString,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,fabs(radius),API_KEY];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Places *places = [Places new];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [places fillFromDictionay:responseObject];
        }
        
        onCompletion(places, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        onCompletion(nil, error);
        
    }];
    [op start];

}

@end
