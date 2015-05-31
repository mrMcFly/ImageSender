//
//  ViewController.m
//  ImageSender
//
//  Created by Alexander Sergienko on 29.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASLoadingScreenViewController.h"
#import "ASDraftsAndMesagesViewController.h"

@interface ASLoadingScreenViewController ()

@end

@implementation ASLoadingScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    NSInteger delayInSeconds = arc4random_uniform(1000) < 500 ? 3 : 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        ASDraftsAndMesagesViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASDraftsAndMesagesViewController"];
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.viewControllers = @[mainVC];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
