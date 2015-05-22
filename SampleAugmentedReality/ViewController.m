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
    
#if !TARGET_IPHONE_SIMULATOR
    AugmentViewController* augmentVC = [AugmentViewController new];
    
    [self presentViewController:augmentVC animated:YES completion:^{
        
    }];

#else
UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Not supported on Simulator!" preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [alertController dismissViewControllerAnimated:YES completion:nil];
}];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
#endif
}

@end
