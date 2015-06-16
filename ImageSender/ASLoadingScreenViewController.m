//
//  ViewController.m
//  ImageSender
//
//  Created by Alexander Sergienko on 29.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASLoadingScreenViewController.h"
#import "ASDraftsAndMesagesViewController.h"
#import "ASProjectConstants.h"
#import "NSNumber+DefiniteDelayInSeconds.h"

@interface ASLoadingScreenViewController ()

@end

@implementation ASLoadingScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    NSInteger delayInSeconds = [NSNumber generateLoadingScreenDelay];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        ASDraftsAndMesagesViewController *mainVC = [self.storyboard
        instantiateViewControllerWithIdentifier:ASIdentifierForASDraftsAndMesagesViewController];
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.viewControllers = @[mainVC];
    });
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
