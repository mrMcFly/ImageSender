//
//  ASAdditionalAlertText.m
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASProjectConstants.h"

//Alert messages text.
NSString* const AlertMessageTextForEmptyMessageStorage  = @"There is nothing to delete";
NSString* const AlertMessageTextForRemoveAllMessages    = @"Are you sure you want to remove all messages?";
NSString* const AlertMessageTextForRemoveCertainMessage = @"Are you sure you want to remove this message?";
NSString* const AlertMessageTextForNotSupportEmailDispatch = @"Sorry,but your device does not support email dispatch";
NSString* const AlertMessageTextForNotValidEmail = @"You enter not valid email";
NSString* const AlertMessageTextForNotAvailableCamera = @"Camera is not available on the simulator";

//Alert actions text.
NSString* const AlertActionTextForConfirmNo  = @"No";
NSString* const AlertActionTextForConfirmYes = @"Yes";
NSString* const AlertActionTextForConfirmOk  = @"Ok";

//Alert title text.
NSString* const AlertTitleTextForCameraError = @"Error";
NSString* const AlertTitleTextForEmailWarning = @"Email warning";

//Identifiers for Viewcontrollers text.
NSString* const IdentifierForASDraftsAndMesagesViewController = @"ASDraftsAndMesagesViewController";
NSString* const IdentifierForASShareViewController = @"ASShareViewController";

//Entitys names.
NSString* const EntityMessageName = @"ASMessage";

//Image names.
NSString* const ImageDefaultNameForASShareViewController = @"AddPhotoButton.png";


@interface ASProjectConstants()

@end
