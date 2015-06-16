//
//  ASAdditionalAlertText.h
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

//Alert messages text.
extern NSString* const AlertMessageTextForEmptyMessageStorage;
extern NSString* const AlertMessageTextForRemoveAllMessages;
extern NSString* const AlertMessageTextForRemoveCertainMessage;
extern NSString* const AlertMessageTextForNotSupportEmailDispatch;
extern NSString* const AlertMessageTextForNotValidEmail;
extern NSString* const AlertMessageTextForNotAvailableCamera;

//Alert actions text.
extern NSString* const AlertActionTextForConfirmNo;
extern NSString* const AlertActionTextForConfirmYes;
extern NSString* const AlertActionTextForConfirmOk;

//Alert title text.
extern NSString* const AlertTitleTextForCameraError;
extern NSString* const AlertTitleTextForEmailWarning;

//Identifiers for Viewcontrollers text.
extern NSString* const IdentifierForASDraftsAndMesagesViewController;
extern NSString* const IdentifierForASShareViewController;

//Entitys names.
extern NSString* const EntityMessageName;

//Image names.
extern NSString* const ImageDefaultNameForASShareViewController;


@interface ASProjectConstants : NSObject

@end
