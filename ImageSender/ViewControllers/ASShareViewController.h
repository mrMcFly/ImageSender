//
//  ASShareViewController.h
//  ImageSender
//
//  Created by Alexander Sergienko on 30.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMessage.h"

@interface ASShareViewController : UIViewController 

@property (strong, nonatomic) ASMessage *modelMessage;

- (IBAction)actionAddPhoto:(UIButton *)sender;
- (IBAction)actionShareByEmail:(UIButton*)sender;

@end
