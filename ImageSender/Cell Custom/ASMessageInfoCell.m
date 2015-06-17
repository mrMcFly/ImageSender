//
//  ASMessageInfoCell.m
//  ImageSender
//
//  Created by Alexander Sergienko on 30.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASMessageInfoCell.h"

@implementation ASMessageInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}


-(void)addInfoFromMessage:(ASMessage*)message {
    
    self.adressLabel.text  = message.email;
    self.subjectLabel.text = message.subject;
    self.photoImg.image = [UIImage imageWithData:message.image];
}


@end
