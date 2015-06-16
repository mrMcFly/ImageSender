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

@interface ASShareViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext  *managedObjectContext;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIAlertController   *alertController;
@property (weak, nonatomic) IBOutlet UIButton     *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField  *emailField;
@property (weak, nonatomic) IBOutlet UITextField  *subjectsField;
@property (weak, nonatomic) IBOutlet UITextView   *bodyTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) BOOL isReturnFromValidationEmailError;

@end


@implementation ASShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addPhotoButton.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.title = @"Share";
    
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
            self.addPhotoButton.titleLabel.layer.opacity = 0.0f;
        }else {
            
            messageImage = [UIImage imageNamed:ImageDefaultNameForASShareViewController];
        }
        [self.addPhotoButton setBackgroundImage:messageImage forState:UIControlStateNormal];
    }
}


- (void)setupAlertCtrl {
    
    self.alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction =
    [UIAlertAction actionWithTitle:@"Camera"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
        [self handleCamera];
    }];
    
    UIAlertAction *imageGalleryAction =
    [UIAlertAction actionWithTitle:@"Photo Gallery"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
        [self handleImageGallery];
    }];
    
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel"
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
    
    self.alertController =
    [UIAlertController alertControllerWithTitle: AlertTitleTextForCameraError
                                        message:AlertMessageTextForNotAvailableCamera
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:AlertActionTextForConfirmOk
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.alertController addAction:okAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
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


- (void) registerForKeyboardNotifications {
    
    NSNotificationCenter *notificationCenterObject = [NSNotificationCenter defaultCenter];
    [notificationCenterObject addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    [notificationCenterObject addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
}


- (void) keyboardWillShow:(NSNotification*) notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, keyboardSize.height , 0.0f);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



- (void) keyboardWillHide:(NSNotification*) notification {
    
    UIEdgeInsets contentInsets   = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (BOOL)isValidEmailAdress:(NSString*) emailAdress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailPredicate evaluateWithObject:emailAdress];
}


- (void) cleanAllFields {
    self.emailField.text    = nil;
    self.subjectsField.text = nil;
    self.bodyTextView.text  = nil;
    [self.addPhotoButton setBackgroundImage:[UIImage imageNamed:ImageDefaultNameForASShareViewController]forState:UIControlStateNormal];
    self.addPhotoButton.titleLabel.layer.opacity = 1.0f;
}


#pragma mark - Actions

- (IBAction)actionAddPhoto:(UIButton *)sender {
    [self setupAlertCtrl];
    [self presentViewController:self.alertController
                       animated:YES
                     completion:nil];
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
            
            UIImage *defaultImage = [UIImage imageNamed:ImageDefaultNameForASShareViewController];
  
            //Define attach or not (image can be default for button) image to email message.
            if (![self.addPhotoButton.currentBackgroundImage isEqual:defaultImage]) {
                
                NSData *imageData = UIImagePNGRepresentation(self.addPhotoButton.currentBackgroundImage);
                [mailComposeController addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyImage.png"];
            }
            
            [self presentViewController:mailComposeController animated:YES completion:nil];
            
        }else{
            //...if email NOT valid
            self.alertController =
            [UIAlertController alertControllerWithTitle:AlertTitleTextForEmailWarning
                                                message:AlertMessageTextForNotValidEmail
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction =
            [UIAlertAction actionWithTitle:AlertActionTextForConfirmOk
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
                                                                   message:AlertMessageTextForNotSupportEmailDispatch
                                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:AlertActionTextForConfirmOk
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
        ASMessage *modelMessage = [NSEntityDescription insertNewObjectForEntityForName:EntityMessageName inManagedObjectContext:self.managedObjectContext];
        modelMessage.email   = self.emailField.text;
        modelMessage.subject = self.subjectsField.text;
        modelMessage.body    = self.bodyTextView.text;
        
        UIImage *defaultImage = [UIImage imageNamed:ImageDefaultNameForASShareViewController];
        
        //Save to message if image is not default background for button.
        if (![self.addPhotoButton.currentBackgroundImage isEqual:defaultImage]) {
            modelMessage.image = UIImagePNGRepresentation(self.addPhotoButton.currentBackgroundImage);
        }else{
            modelMessage.image = nil;
        }
        [self.managedObjectContext save:nil];
        
        [self cleanAllFields];
        
    }else if (result == MFMailComposeResultCancelled || result == MFMailComposeResultSaved) {
        
        [self cleanAllFields];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.emailField]) {
        
        if (self.isReturnFromValidationEmailError) {
            [self.emailField resignFirstResponder];
        }else{
            [self.subjectsField becomeFirstResponder];
        }
        
    }else if ([textField isEqual:self.subjectsField]){
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
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSData *dataImage = UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
    UIImage *imageFromData = [[UIImage alloc]initWithData:dataImage];
    [self.addPhotoButton setBackgroundImage:imageFromData forState:UIControlStateNormal];
    self.addPhotoButton.titleLabel.layer.opacity = 0.0f;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
