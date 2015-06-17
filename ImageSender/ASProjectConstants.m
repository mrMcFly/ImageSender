//
//  ASAdditionalAlertText.m
//  ImageSender
//
//  Created by Alexandr Sergienko on 6/16/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASProjectConstants.h"

//******************************* String constants *********************************

//-------------------------------- Alerts ----------------------------------------

//Alert messages text.
NSString* const AS_Alert_Message_Text_For_Empty_Message_Storage  = @"There is nothing to delete";
NSString* const AS_Alert_Message_Text_For_Remove_All_Messages    = @"Are you sure you want to remove all messages?";
NSString* const AS_Alert_Message_Text_For_Remove_Certain_Message = @"Are you sure you want to remove this message?";
NSString* const AS_Alert_Message_Text_For_Not_Support_Email_Dispatch = @"Sorry,but your device does not support email dispatch";
NSString* const AS_Alert_Message_Text_For_Not_Valid_Email = @"You enter not valid email";
NSString* const AS_Alert_Message_Text_For_Not_Available_Camera = @"Camera is not available on the simulator";

//Alert actions text.
NSString* const AS_Alert_Action_Text_For_Confirm_No  = @"No";
NSString* const AS_Alert_Action_Text_For_Confirm_Yes = @"Yes";
NSString* const AS_Alert_Action_Text_For_Confirm_Ok  = @"Ok";

//Alert title text.
NSString* const AS_Alert_Title_Text_For_Camera_Error = @"Error";
NSString* const AS_Alert_Title_Text_For_Email_Warning = @"Email warning";
NSString* const AS_Alert_Title_Text_For_Camera = @"Camera";
NSString* const AS_Alert_Title_Text_For_Photo_Gallery = @"Photo Gallery";
NSString* const AS_Alert_Title_Text_For_Cancel = @"Cancel";

//----------------------------- ViewControllers ----------------------------------

//Identifiers for ViewControllers text.
NSString* const AS_Identifier_For_DraftsAndMesagesViewController = @"ASDraftsAndMesagesViewController";
NSString* const AS_Identifier_For_ShareViewController = @"ASShareViewController";

//NavigationItem titles for ViewControllers
NSString* const AS_NavigationItem_Title_For_DraftsAndMessagesViewController = @"Drafts and sent messages";
NSString* const AS_Navigation_Item_Title_For_ShareViewController = @"Share";


//-------------------------------- Images -----------------------------------------

//Key name for image PNG representation.
NSString* const AS_Image_PNG_Representation_Key_Name = @"UIImagePickerControllerOriginalImage";

//Image names.
NSString* const AS_Image_Default_Name_For_ShareViewController = @"AddPhotoButton.png";

//------------------------------- Additional --------------------------------------

//Entitys names.
NSString* const AS_Entity_Message_Name = @"ASMessage";

//Regular extension format
NSString* const AS_Regular_Expension_Format_For_Email = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

//String for resign first responder
NSString* const AS_TextView_String_For_Resign_First_Responder = @"\n";

//MIME types
NSString* const AS_MIME_Type_Is_Image_PNG = @"image/png";


//******************************* Numbers constants *********************************

//Press time duration
double const AS_Minimum_Time_Press_Duration_For_Delete_Cell = 2.0;

//Button label opacity
float const AS_Button_Title_Label_Opacity_Negatively = 0.0f;
float const AS_Button_Title_Label_Opacity_Affirmatively = 1.0f;

//ScrollView edge insets
float const AS_ScrollView_Edge_Insets_Equals_Nil = 0.0f;


@interface ASProjectConstants()

@end
