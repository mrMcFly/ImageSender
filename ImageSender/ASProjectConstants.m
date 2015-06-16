//
//  ASAdditionalAlertText.m
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASProjectConstants.h"

//Alert messages text.
NSString* const ASAlertMessageTextForEmptyMessageStorage  = @"There is nothing to delete";
NSString* const ASAlertMessageTextForRemoveAllMessages    = @"Are you sure you want to remove all messages?";
NSString* const ASAlertMessageTextForRemoveCertainMessage = @"Are you sure you want to remove this message?";
NSString* const ASAlertMessageTextForNotSupportEmailDispatch = @"Sorry,but your device does not support email dispatch";
NSString* const ASAlertMessageTextForNotValidEmail = @"You enter not valid email";
NSString* const ASAlertMessageTextForNotAvailableCamera = @"Camera is not available on the simulator";

//Alert actions text.
NSString* const ASAlertActionTextForConfirmNo  = @"No";
NSString* const ASAlertActionTextForConfirmYes = @"Yes";
NSString* const ASAlertActionTextForConfirmOk  = @"Ok";

//Alert title text.
NSString* const ASAlertTitleTextForCameraError = @"Error";
NSString* const ASAlertTitleTextForEmailWarning = @"Email warning";

//Identifiers for Viewcontrollers text.
NSString* const ASIdentifierForASDraftsAndMesagesViewController = @"ASDraftsAndMesagesViewController";
NSString* const ASIdentifierForASShareViewController = @"ASShareViewController";

//Entitys names.
NSString* const ASEntityMessageName = @"ASMessage";

//Image names.
NSString* const ASImageDefaultNameForASShareViewController = @"AddPhotoButton.png";


@interface ASProjectConstants()

@end
