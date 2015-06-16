//
//  ASAdditionalAlertText.h
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

//Alert messages text.
extern NSString* const ASAlertMessageTextForEmptyMessageStorage;
extern NSString* const ASAlertMessageTextForRemoveAllMessages;
extern NSString* const ASAlertMessageTextForRemoveCertainMessage;
extern NSString* const ASAlertMessageTextForNotSupportEmailDispatch;
extern NSString* const ASAlertMessageTextForNotValidEmail;
extern NSString* const ASAlertMessageTextForNotAvailableCamera;

//Alert actions text.
extern NSString* const ASAlertActionTextForConfirmNo;
extern NSString* const ASAlertActionTextForConfirmYes;
extern NSString* const ASAlertActionTextForConfirmOk;

//Alert title text.
extern NSString* const ASAlertTitleTextForCameraError;
extern NSString* const ASAlertTitleTextForEmailWarning;

//Identifiers for Viewcontrollers text.
extern NSString* const ASIdentifierForASDraftsAndMesagesViewController;
extern NSString* const ASIdentifierForASShareViewController;

//Entitys names.
extern NSString* const ASEntityMessageName;

//Image names.
extern NSString* const ASImageDefaultNameForASShareViewController;


@interface ASProjectConstants : NSObject

@end
