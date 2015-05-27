//
//  Place.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/22/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "Place.h"


/*
 
 #define kResults @"results"
 #define kPlace_id @"place_id"
 #define kName @"name"
 #define kGeometry @"geometry"
 #define kLocation @"location"
 
 #define kLat @"lat"
 #define kLng @"lng"
 #define kVicinity @"vicinity"
 #define kTypes @"types"
 */



@implementation Place

- (id) init
{
    self = [super init];
    
    if (self) {
        [self fillFromDictionay:nil];
    }
    
    return self;
}

- (void) fillFromDictionay:(NSDictionary *)dataDict
{
    if (dataDict == nil) {
        self.placeId = @"";
        self.name  = @"";
        self.vicinityAddress = @"";
        self.types = @[];
        self.placeLocation = [[CLLocation alloc] initWithLatitude:defaultLat longitude:defaultLng];
        self.magenticDirectionLat = MAGNETIC_NORTH;
        self.magenticDirectionLng = MAGNETIC_EAST;
        
        return;
    }
    
    if ([dataDict isKindOfClass:[NSDictionary class]]) {
        
        if (dataDict[kPlace_id] != nil) {
            [self setPlaceId:dataDict[kPlace_id]];
        }
        
        if (dataDict[kName] != nil) {
            [self setName:dataDict[kName]];
        }
        
        if (dataDict[kVicinity] != nil) {
            [self setVicinityAddress:dataDict[kVicinity]];
        }
        
        if (dataDict[kTypes] != nil && [dataDict[kTypes] isKindOfClass:[NSArray class]]) {
            [self setTypes:dataDict[kTypes]];
        }
        
        if ([dataDict[kGeometry] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary* geomtryDict = dataDict[kGeometry];
            if ([geomtryDict[kLocation] isKindOfClass:[NSDictionary class]]) {
                [self fillLocationFromDict:geomtryDict[kLocation]];
            }
            
        }
            
            
    }
    
    
}

- (void) fillLocationFromDict:(NSDictionary*)dict
{
    if (dict == nil) {
        self.placeLocation = [[CLLocation alloc] initWithLatitude:defaultLat longitude:defaultLng];
        self.magenticDirectionLat = MAGNETIC_NORTH;
        self.magenticDirectionLng = MAGNETIC_WEST;
    }
    else{
        self.placeLocation = [[CLLocation alloc] initWithLatitude:[dict[kLat] doubleValue] longitude:[dict[kLng] doubleValue]];
        
        self.magenticDirectionLat = (self.placeLocation.coordinate.latitude >=0)?MAGNETIC_NORTH:MAGNETIC_SOUTH;
        self.magenticDirectionLng = (self.placeLocation.coordinate.longitude >=0)?MAGNETIC_EAST:MAGNETIC_WEST;
    }
}
   
@end

@implementation Places

- (void) fillFromDictionay:(NSDictionary *)dataDict
{
    if (dataDict == nil) {
        self.places = @[];
        
        return;
    }
    
    
    if (dataDict[kResults] != nil) {
        if ([dataDict[kResults] isKindOfClass:[NSArray class]]) {
            NSMutableArray* dataArray = [NSMutableArray new];
            for (id obj in dataDict[kResults]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary* dataDict = (NSDictionary*)obj;
                    
                    Place* currentPlace = [Place new];
                    
                    [currentPlace fillFromDictionay:dataDict];
                    
                    [dataArray addObject:currentPlace];
                    
                }
            }
            
            self.places = [NSArray arrayWithArray:dataArray];
        }
    }
    else{self.places=@[];}
    
}

@end
