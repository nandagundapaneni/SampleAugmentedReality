//
//  AnnotationView.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/22/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "AnnotationView.h"
#import "Place.h"

@interface AnnotationView ()

@property (nonatomic,strong) UILabel* nameLabel;

@end

@implementation AnnotationView

- (id) init
{
    self = [super  initWithFrame:CGRectMake(0, 0, 200, 20)];
    
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.nameLabel setTextColor:[UIColor whiteColor]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.nameLabel setUserInteractionEnabled:YES];
        [self.nameLabel setFont:[UIFont fontWithName:@"SanFranciscoRounded-Medium" size:16.0]];
        [self addSubview:self.nameLabel];
        
        UITapGestureRecognizer* recongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(annotationTapped:)];
        [recongnizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:recongnizer];
        
        
    }
    return self;
}

- (void) setPlace:(Place *)place
{
    _place = place;
    
    [self.nameLabel setText:_place.name];
}

- (void) annotationTapped:(UITapGestureRecognizer*)recog
{
    NSString* message = [NSString stringWithFormat:@"NAME:%@\nADDRESS:%@",self.place.name,self.place.vicinityAddress];
    
    if (self.showAlert) {
        self.showAlert(message);
    }
    
}

@end
