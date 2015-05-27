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
    [self directionToTarget:self.placeLocation.coordinate];
    [self distanceToLocation:self.placeLocation.coordinate];
}

- (void) directionToTarget:(CLLocationCoordinate2D)target
{
    //double dLat = degreesToRadians(target.latitude-self.originLocation.coordinate.latitude);
    double dLon = degreesToRadians(target.longitude-self.originLocation.coordinate.longitude);
    
    double lat1 = degreesToRadians(target.latitude);
    double lat2 = degreesToRadians(self.originLocation.coordinate.latitude);
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1)*sin(lat2) -
    sin(lat1)*cos(lat2)*cos(dLon);
    double brng = radiansToDegrees(atan2(y, x));
    
    // fix negative degrees
    if(brng<0) {
        brng=360-fabs(brng);
    }
    
    [self headingQuadFromHeading:brng];
}


- (void) headingQuadFromHeading:(CLLocationDirection)heading
{
    if (heading < MAGNETIC_NORTH) {
        self.actualDirection = HEADINGQUADARANT_UNKNOWN;
        return;
    }
    
    if (heading >= MAGNETIC_NORTH && heading <= MAGNETIC_EAST) {
        self.actualDirection = HEADINGQUADARANT_NE;
        return;
    }
    
    if (heading >= MAGNETIC_EAST && heading <= MAGNETIC_SOUTH) {
        self.actualDirection = HEADINGQUADARANT_SE;
        return;
    }
    
    if (heading >= MAGNETIC_SOUTH  && heading <= MAGNETIC_WEST) {
        self.actualDirection = HEADINGQUADARANT_SW;
        return;
    }
    
    if (heading >= MAGNETIC_WEST) {
        self.actualDirection = HEADINGQUADARANT_NW;
        return;
    }
    
    
}

- (void) distanceToLocation:(CLLocationCoordinate2D)target
{
    double dLat = degreesToRadians(target.latitude-self.originLocation.coordinate.latitude);
    double dLon = degreesToRadians(target.longitude-self.originLocation.coordinate.longitude);
    
    double lat1 = degreesToRadians(target.latitude);
    double lat2 = degreesToRadians(self.originLocation.coordinate.latitude);

    double a = pow(sin(dLat/2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon/2), 2);
    double c = 2 * atan2( sqrt(a), sqrt(1-a) );
    self.distanceToOrigin = R * c;
}

@end

@implementation Places

- (void) fillFromDictionay:(NSDictionary *)dataDict
{
    if (dataDict == nil) {
        self.places = @[];
        self.originLocation = [[CLLocation alloc] initWithLatitude:defaultLat longitude:defaultLng];
        return;
    }
    
    
    if (dataDict[kResults] != nil) {
        if ([dataDict[kResults] isKindOfClass:[NSArray class]]) {
            NSMutableArray* dataArray = [NSMutableArray new];
            NSInteger idx = 1;
            
            for (id obj in dataDict[kResults]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    if (idx == MAX_PLACES) {
                        break;
                    }
                    
                    NSDictionary* dataDict = (NSDictionary*)obj;
                    
                    Place* currentPlace = [Place new];
                    currentPlace.originLocation = self.originLocation;
                    [currentPlace fillFromDictionay:dataDict];

                    
                    [dataArray addObject:currentPlace];
                    idx += 1;
                    
                }
            }
            
            NSSortDescriptor* desc = [NSSortDescriptor sortDescriptorWithKey:@"distanceToOrigin" ascending:YES];
            [dataArray sortUsingDescriptors:@[desc]];
            
            self.places = [NSArray arrayWithArray:dataArray];
        }
    }
    else{self.places=@[];}
    
}

@end
