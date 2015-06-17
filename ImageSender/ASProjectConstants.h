//
//  ASAdditionalAlertText.h
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------------------------------------------------------------------------
//*************************** String constants **********************************
//-----------------------------------------------------------------------------------

//------------------------------- Alerts ----------------------------------------

//Alert messages text.
extern NSString* const AS_Alert_Message_Text_For_Empty_Message_Storage;
extern NSString* const AS_Alert_Message_Text_For_Remove_All_Messages;
extern NSString* const AS_Alert_Message_Text_For_Remove_Certain_Message;
extern NSString* const AS_Alert_Message_Text_For_Not_Support_Email_Dispatch;
extern NSString* const AS_Alert_Message_Text_For_Not_Valid_Email;
extern NSString* const AS_Alert_Message_Text_For_Not_Available_Camera;

//Alert actions text.
extern NSString* const AS_Alert_Action_Text_For_Confirm_No;
extern NSString* const AS_Alert_Action_Text_For_Confirm_Yes;
extern NSString* const AS_Alert_Action_Text_For_Confirm_Ok;

//Alert title text.
extern NSString* const AS_Alert_Title_Text_For_Camera_Error;
extern NSString* const AS_Alert_Title_Text_For_Email_Warning;
extern NSString* const AS_Alert_Title_Text_For_Camera;
extern NSString* const AS_Alert_Title_Text_For_Photo_Gallery;
extern NSString* const AS_Alert_Title_Text_For_Cancel;

//----------------------------- ViewControllers ----------------------------------

//Identifiers for ViewControllers text.
extern NSString* const AS_Identifier_For_DraftsAndMesagesViewController;
extern NSString* const AS_Identifier_For_ShareViewController;

//NavigationItem titles for ViewControllers
extern NSString* const AS_NavigationItem_Title_For_DraftsAndMessagesViewController;
extern NSString* const AS_Navigation_Item_Title_For_ShareViewController;


//-------------------------------- Images -------------------------------------------

//Key name for image PNG representation.
extern NSString* const AS_Image_PNG_Representation_Key_Name;

//Image names.
extern NSString* const AS_Image_Default_Name_For_ShareViewController;


//-------------------------------- Additional ---------------------------------------

//Entitys names.
extern NSString* const AS_Entity_Message_Name;

//Regular expension format
extern NSString* const AS_Regular_Expension_Format_For_Email;

//String for resign first responder
extern NSString* const AS_TextView_String_For_Resign_First_Responder;

//MIME types
extern NSString* const AS_MIME_Type_Is_Image_PNG;


//-----------------------------------------------------------------------------------
//******************************* Numbers constants *********************************
//-----------------------------------------------------------------------------------

//Press time duration
extern double const AS_Minimum_Time_Press_Duration_For_Delete_Cell;

//Button label opacity
extern float const AS_Button_Title_Label_Opacity_Negatively;
extern float const AS_Button_Title_Label_Opacity_Affirmatively;

//ScrollView edge insets
extern float const AS_ScrollView_Edge_Insets_Equals_Nil;



@interface ASProjectConstants : NSObject

@end
