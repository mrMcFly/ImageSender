//
//  NSNumber+DefiniteDelayInSeconds.m
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "NSNumber+DefiniteDelayInSeconds.h"

@implementation NSNumber (NSIntegerDefiniteDelayInSeconds)

+ (NSInteger) generateLoadingScreenDelay {
    
    //will return 2 or 3 second for delay.
    NSInteger generateResult = [self generateDelayFrom:2 to:3];
    
    return generateResult;
}


+ (NSInteger) generateDelayFrom:(NSInteger)firstArgument to:(NSInteger)secondArgument {
    
    //convert to positive value because delay can't be negative.
    firstArgument = labs(firstArgument);
    secondArgument = labs(secondArgument);
    
    NSInteger argumentsDecrementResult = firstArgument - secondArgument;
    
    if (argumentsDecrementResult == 1) {
        
        return arc4random_uniform(1000) < 500 ? firstArgument : secondArgument;
        
    }else {
        
        return firstArgument + arc4random() % (secondArgument - firstArgument);
    }
    return 0;
}

@end
