//
//  ViewController.m
//  SampleAugmentedReality
//
//  Created by Nanda Gundapaneni on 5/20/15.
//  Copyright (c) 2015 NandaKG. All rights reserved.
//

#import "ViewController.h"
#import "AugmentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showAugmentView:(id)sender {
    
    AugmentViewController* augmentVC = [AugmentViewController new];
    
    [self presentViewController:augmentVC animated:YES completion:^{
        
    }];

}

@end
