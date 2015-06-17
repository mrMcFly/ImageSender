//
//  ASMessage.h
//  ImageSender
//
//  Created by Alexander Sergienko on 30.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ASMessage : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * subject;

@end
