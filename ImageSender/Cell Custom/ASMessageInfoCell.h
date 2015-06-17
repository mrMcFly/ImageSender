//
//  ASMessageInfoCell.h
//  ImageSender
//
//  Created by Alexander Sergienko on 30.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMessage.h"

@interface ASMessageInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImg;

-(void)addInfoFromMessage:(ASMessage*)message;

@end
