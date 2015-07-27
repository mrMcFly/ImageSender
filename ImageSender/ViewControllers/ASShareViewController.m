//
//  ASShareViewController.m
//  ImageSender
//
//  Created by Alexander Sergienko on 30.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASShareViewController.h"
#import "AppDelegate.h"
#import "ASMessage.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "ASProjectConstants.h"


@interface ASShareViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate,UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext  *managedObjectContext;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIAlertController   *alertController;
@property (weak, nonatomic) IBOutlet UIButton     *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField  *emailField;
@property (weak, nonatomic) IBOutlet UITextField  *subjectsField;
@property (weak, nonatomic) IBOutlet UITextView   *bodyTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) BOOL isReturnFromValidationEmailError;

@property (strong, nonatomic) UITextField *actionField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSData *chosenImageData;

@end


@implementation ASShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addPhotoButton.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.title = AS_Navigation_Item_Title_For_ShareViewController;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self registerForKeyboardNotifications];

    [self coreDataStartSettings];
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.isReturnFromValidationEmailError = NO;
}


- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


#pragma mark - Additional

- (void) coreDataStartSettings {
    
    AppDelegate *applicationDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.managedObjectContext = applicationDelegate.managedObjectContext;
    
    if (self.modelMessage) {
        
        self.emailField.text = self.modelMessage.email;
        self.subjectsField.text = self.modelMessage.subject;
        self.bodyTextView.text = self.modelMessage.body;
       
        UIImage *messageImage = nil;
        
        if (self.modelMessage.image) {
        
            messageImage = [[UIImage alloc]initWithData:self.modelMessage.image];
            self.addPhotoButton.titleLabel.layer.opacity = AS_Button_Title_Label_Opacity_Negatively;
        }else {
            
            messageImage = [UIImage imageNamed:AS_Image_Default_Name_For_ShareViewController];
        }
        [self.addPhotoButton setBackgroundImage:messageImage forState:UIControlStateNormal];
    }
}


- (void)setupAlertCtrl {
    
    self.alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction =
    [UIAlertAction actionWithTitle:AS_Alert_Title_Text_For_Camera
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
        [self handleCamera];
    }];
    
    UIAlertAction *imageGalleryAction =
    [UIAlertAction actionWithTitle:AS_Alert_Title_Text_For_Photo_Gallery
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
        [self handleImageGallery];
    }];
    
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:AS_Alert_Title_Text_For_Cancel
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.alertController addAction:cameraAction];
    [self.alertController addAction:imageGalleryAction];
    [self.alertController addAction:cancelAction];
}


- (void) handleCamera {
    
#if TARGET_IPHONE_SIMULATOR
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        [[[UIAlertView alloc]initWithTitle:AS_Alert_Title_Text_For_Camera_Error
                                   message:AS_Alert_Message_Text_For_Not_Available_Camera
                                  delegate:self
                         cancelButtonTitle:AS_Alert_Action_Text_For_Confirm_Ok
                         otherButtonTitles:nil]show];
        
    }else {
        
    self.alertController =
    [UIAlertController alertControllerWithTitle: AS_Alert_Title_Text_For_Camera_Error
                                        message:AS_Alert_Message_Text_For_Not_Available_Camera
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:AS_Alert_Action_Text_For_Confirm_Ok
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.alertController addAction:okAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
    }
    
#elif TARGET_OS_IPHONE
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
#endif
}


- (void) handleImageGallery {
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


- (void) cleanAllFields {
    
    //without this code (dispatch_async) - crash "Only run on the main thread!"
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emailField.text    = nil;
        self.subjectsField.text = nil;
        self.bodyTextView.text  = nil;
        [self.addPhotoButton setBackgroundImage:[UIImage imageNamed:AS_Image_Default_Name_For_ShareViewController]forState:UIControlStateNormal];
        self.addPhotoButton.titleLabel.layer.opacity = AS_Button_Title_Label_Opacity_Affirmatively;
    });
}


- (BOOL)isValidEmailAdress:(NSString*) emailAdress
{
    NSString *emailRegExFormat = AS_Regular_Expension_Format_For_Email;
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegExFormat];
    
    return [emailPredicate evaluateWithObject:emailAdress];
}


- (void) setAndShowActionSheetForAddNewImage {
    
    self.actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:AS_Alert_Title_Text_For_Cancel
                  destructiveButtonTitle:nil
                       otherButtonTitles:AS_Alert_Title_Text_For_Camera,AS_Alert_Title_Text_For_Photo_Gallery,nil];
    self.actionSheet.tag = 1;
    [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - Additional Notifications

- (void) registerForKeyboardNotifications {
    
    NSNotificationCenter *notificationCenterObject = [NSNotificationCenter defaultCenter];
    [notificationCenterObject addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardDidShowNotification
             object:nil];
    
    [notificationCenterObject addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
}


- (void) keyboardWillShow:(NSNotification*) notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets =
    UIEdgeInsetsMake(AS_ScrollView_Edge_Insets_Equals_Nil,
                     AS_ScrollView_Edge_Insets_Equals_Nil,
                     keyboardSize.height,
                     AS_ScrollView_Edge_Insets_Equals_Nil);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
        
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, self.actionField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, self.actionField.frame.origin.y + keyboardSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}



- (void) keyboardWillHide:(NSNotification*) notification {
    
    UIEdgeInsets contentInsets   = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Actions

- (IBAction)actionAddPhoto:(UIButton *)sender {
    [self setupAlertCtrl];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        [self setAndShowActionSheetForAddNewImage];
        
    }else {
        
    [self presentViewController:self.alertController
                       animated:YES
                     completion:nil];
    }
}


- (IBAction)actionShareByEmail:(UIButton*)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        if ([self isValidEmailAdress:self.emailField.text]) {
            
            MFMailComposeViewController *mailComposeController = [[MFMailComposeViewController alloc]init];
            mailComposeController.mailComposeDelegate = self;
            mailComposeController.delegate = self;
            
            [mailComposeController setToRecipients:@[self.emailField.text]];
            [mailComposeController setSubject:self.subjectsField.text];
            [mailComposeController setMessageBody:self.bodyTextView.text isHTML:NO];
        
            if (self.chosenImageData) {
                [mailComposeController addAttachmentData:self.chosenImageData mimeType:AS_MIME_Type_Is_Image_PNG fileName:AS_Image_File_Name_Assosiated_With_The_Data];
            }
            
                [self presentViewController:mailComposeController animated:YES completion:nil];
            
        }else{
            //...if email NOT valid
            self.alertController =
            [UIAlertController alertControllerWithTitle:AS_Alert_Title_Text_For_Email_Warning
                                                message:AS_Alert_Message_Text_For_Not_Valid_Email
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction =
            [UIAlertAction actionWithTitle:AS_Alert_Action_Text_For_Confirm_Ok
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
            [self.alertController addAction:okAction];
            self.isReturnFromValidationEmailError = YES;
            [self.emailField becomeFirstResponder];
            
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
    }else{
        //If device can't send email.
        self.alertController = [UIAlertController alertControllerWithTitle:nil
                                                                   message:AS_Alert_Message_Text_For_Not_Support_Email_Dispatch
                                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:AS_Alert_Action_Text_For_Confirm_Ok
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
        [self.alertController addAction:okAction];
        [self presentViewController:self.alertController animated:YES
                         completion:nil];
    }
}



#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (result == MFMailComposeResultSent) {
        ASMessage *modelMessage = [NSEntityDescription insertNewObjectForEntityForName:AS_Entity_Message_Name inManagedObjectContext:self.managedObjectContext];
        modelMessage.email   = self.emailField.text;
        modelMessage.subject = self.subjectsField.text;
        modelMessage.body    = self.bodyTextView.text;
        modelMessage.image   = self.chosenImageData;
        
        [self.managedObjectContext save:nil];
        
        [self cleanAllFields];
        
    }else if (result == MFMailComposeResultCancelled ||
              result == MFMailComposeResultSaved) {
        
        [self cleanAllFields];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.actionField = textField;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.actionField = nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.emailField]) {
        
        if (self.isReturnFromValidationEmailError) {
            [self.emailField resignFirstResponder];
        }else{
            [self.subjectsField becomeFirstResponder];
        }
        
    }else if ([textField isEqual:self.subjectsField]){
        [textField resignFirstResponder];
        [self.bodyTextView becomeFirstResponder];
    }
    return NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldRaplace = true;
    
    return shouldRaplace;
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:AS_TextView_String_For_Resign_First_Responder]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSData *dataImage = UIImagePNGRepresentation([info objectForKey:AS_Image_PNG_Representation_Key_Name]);
    
    UIImage *imageFromData = [[UIImage alloc]initWithData:dataImage];
    [self.addPhotoButton setBackgroundImage:imageFromData forState:UIControlStateNormal];
    self.addPhotoButton.titleLabel.layer.opacity = AS_Button_Title_Label_Opacity_Negatively;

    self.chosenImageData = dataImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *sheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

    if ([sheetTitle isEqualToString:AS_Alert_Title_Text_For_Camera]) {
        
        [self handleCamera];
        
    }else if ([sheetTitle isEqualToString:AS_Alert_Title_Text_For_Photo_Gallery]) {
        
        [self handleImageGallery];
    }
}

@end
