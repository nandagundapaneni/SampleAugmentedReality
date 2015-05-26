//
//  AnnotationView.h
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/22/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface AnnotationView : UIView

@property (nonatomic,strong) Place* place;
@property (nonatomic, copy) void (^showAlert)(NSString* message);
@end
