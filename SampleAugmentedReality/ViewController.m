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
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AugmentViewController* augmentVC = [AugmentViewController new];
        
        [self presentViewController:augmentVC animated:YES completion:^{
            
        }];

    }
    else{
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"No Fun!" message:@"Whats fun in augmented reality without the camera.\nPlease use a phone ;)" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [ac dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [ac addAction:cancel];
        
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}

@end
