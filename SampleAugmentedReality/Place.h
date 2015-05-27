//
//  Place.h
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/22/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kResults @"results"
#define kPlace_id @"place_id"
#define kName @"name"
#define kGeometry @"geometry"
#define kLocation @"location"

#define kLat @"lat"
#define kLng @"lng"
#define kVicinity @"vicinity"
#define kTypes @"types"

typedef NS_ENUM(NSInteger, HEADINGQUADARANT)
{
    HEADINGQUADARANT_UNKNOWN,
    HEADINGQUADARANT_NE = 1,
    HEADINGQUADARANT_NW,
    HEADINGQUADARANT_SE,
    HEADINGQUADARANT_SW,
};

typedef NS_ENUM(NSInteger, MAGNETIC_)
{
    MAGNETIC_NORTH = 0,
    MAGNETIC_EAST = 90,
    MAGNETIC_SOUTH = 180,
    MAGNETIC_WEST = 270
};

static const double defaultLng = 151.218237;
static const double defaultLat = -33.88471;

@interface Place : NSObject

@property (nonatomic,strong) NSString* placeId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSArray* types;
@property (nonatomic,strong) NSString* vicinityAddress;
@property (nonatomic,strong) CLLocation* placeLocation;
@property (nonatomic,assign) MAGNETIC_ magenticDirectionLat;
@property (nonatomic,assign) MAGNETIC_ magenticDirectionLng;

- (void) fillFromDictionay:(NSDictionary*)dataDict;

@end


@interface Places : NSObject

@property (nonatomic, strong) NSArray* places;
- (void) fillFromDictionay:(NSDictionary*)dataDict;
@end