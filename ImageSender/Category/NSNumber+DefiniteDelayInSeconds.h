//
//  NSNumber+DefiniteDelayInSeconds.h
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NSIntegerDefiniteDelayInSeconds)

+ (NSInteger) generateLoadingScreenDelay;

+ (NSInteger) generateDelayFrom:(NSInteger)firstArgument to:(NSInteger)secondArgument;

@end
