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

@interface ASShareViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIAlertController   *alertController;
@property (weak, nonatomic) IBOutlet UIButton     *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField  *emailField;
@property (weak, nonatomic) IBOutlet UITextField  *subjectsField;
@property (weak, nonatomic) IBOutlet UITextView   *bodyTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ASShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.addPhotoButton.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.title = @"Share";
    
    [self registerForKeyboardNotifications];
    
    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"BackButton.png"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
    
    if (self.message) {
        //тут мне нужно как-то ставить изображение
        self.emailField.text = self.message.email;
        self.subjectsField.text = self.message.subject;
        self.bodyTextView.text = self.message.body;
        self.addPhotoButton.imageView.image = [UIImage imageWithData:self.message.image];
        self.addPhotoButton.hidden = YES;
    }

}


- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - Additional
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
    //camera is not available on simulator.
    self.alertController =
    [UIAlertController alertControllerWithTitle: @"Error"
                                        message:@"Camera is not available on the simulator"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.alertController addAction:okAction];
    
    [self presentViewController:self.alertController animated:YES completion:nil];
    
#elif TARGET_OS_IPHONE
    //some code for iPhone
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
#endif
}


- (void) handleImageGallery {
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#warning не нравится,что делегат устанавливается два раза (см. метод выше).+ каждый раз создается экземпляр UIImagePickerController, может через SINGLETON реализовать?
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


- (void) registerForKeyboardNotifications {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
}


- (void) keyboardWillShow:(NSNotification*) notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, kbSize.height , 0.0f);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
#warning что-то нужно с offsetom делавть, нужна реализация с автоматическим поднятием или опусканием contenta scrollView.
    //self.scrollView.contentOffset = CGPointMake(0, kbSize);
}



- (void) keyboardWillHide:(NSNotification*) notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#warning Нихрена не печатается в валидации почты!!!
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:email] == NO) {
        self.alertController =
        [UIAlertController alertControllerWithTitle:@"Email warning"
                                            message:@"You enter not valid email"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.alertController addAction:okAction];
        [self presentViewController:self.alertController animated:YES completion:nil];
    }
    
    return [emailTest evaluateWithObject:email];
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
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
        mailCompose.mailComposeDelegate = self;
        
        mailCompose.delegate = self;
        
        [mailCompose setToRecipients:@[self.emailField.text]];
        [mailCompose setSubject:self.subjectsField.text];
        [mailCompose setMessageBody:self.bodyTextView.text isHTML:NO];
        
        UIImage *defaultImage = [UIImage imageNamed:@"AddPhotoNew.png"];
        if (![self.addPhotoButton.currentBackgroundImage isEqual:defaultImage]) {
            NSData *data = UIImagePNGRepresentation(self.addPhotoButton.currentBackgroundImage);
            [mailCompose addAttachmentData:data mimeType:@"image/png" fileName:@"MyImage.png"];
        }
        
        [self presentViewController:mailCompose animated:YES completion:nil];
   
#warning Нужна ли блок кода ниже или оставить просто с if без else?
    }else {
        self.alertController = [UIAlertController alertControllerWithTitle:nil message:@"Sorry,but your device does not support email dispatch." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
        ASMessage *message = [NSEntityDescription insertNewObjectForEntityForName:@"ASMessage" inManagedObjectContext:self.managedObjectContext];
        message.email   = self.emailField.text;
        message.subject = self.subjectsField.text;
        message.body    = self.bodyTextView.text;
        message.image   = UIImagePNGRepresentation(self.addPhotoButton.currentBackgroundImage);
        [self.managedObjectContext save:nil];
#warning Как правильно записать обнуление строки?
        self.emailField.text    = nil; //либо нужно так: = @"";  ?
        self.subjectsField.text = nil;
        self.bodyTextView.text  = nil;
        [self.addPhotoButton setBackgroundImage:[UIImage imageNamed:  @"AddPhotoNew.png"]forState:UIControlStateNormal];
        self.addPhotoButton.titleLabel.layer.opacity = 1.0f;

        
    }else if (result == MFMailComposeResultCancelled || result == MFMailComposeResultSaved) {

        self.emailField.text    = nil; //либо нужно так: = @"";  ?
        self.subjectsField.text = nil;
        self.bodyTextView.text  = nil;
        [self.addPhotoButton setBackgroundImage:[UIImage imageNamed:  @"AddPhotoNew.png"]forState:UIControlStateNormal];
        self.addPhotoButton.titleLabel.layer.opacity = 1.0f;

    }
    
#warning Что сделать с остальными проверками result? Ведь в сдучае,если почта отправенна не была мы дожны все оставить как есть?
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.emailField]) {
        [self.subjectsField becomeFirstResponder];
    }else if ([textField isEqual:self.subjectsField]){
        [self.bodyTextView becomeFirstResponder];
    }
    return NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldRaplace = true;
    
//    if ([textField isEqual:self.emailField]){
//        shouldRaplace = [self validateEmailWithString:string];
//    }
    return shouldRaplace;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        //Return FALSE so that the final '\n' character doesn't get added.
        return NO;
    }
    //For any other character return TRUE so that the text gets added to the view
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSData *dataImage = UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
    UIImage *img = [[UIImage alloc]initWithData:dataImage];
    [self.addPhotoButton setBackgroundImage:img forState:UIControlStateNormal];
    self.addPhotoButton.titleLabel.layer.opacity = 0.0f;
    [self dismissViewControllerAnimated:YES completion:nil];
}








@end
