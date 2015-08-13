//
//  ASDraftsAndMesagesViewController.m
//  ImageSender
//
//  Created by Alexander Sergienko on 30.05.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASDraftsAndMesagesViewController.h"
#import "ASShareViewController.h"
#import "ASMessageInfoCell.h"
#import "ASMessage.h"
#import "AppDelegate.h"
#import "ASProjectConstants.h"

typedef enum {
    ASAlertTypeDeleteCell,
    ASAlertTypeRemoveAll
}ASAlertType;

@interface ASDraftsAndMesagesViewController ()  <UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) NSIndexPath *indexPathForCell;

//CoreData
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end


@implementation ASDraftsAndMesagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = AS_NavigationItem_Title_For_DraftsAndMessagesViewController;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *addNewMessageButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNewMessage)];
    
    self.navigationItem.rightBarButtonItem = addNewMessageButton;

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.opaque = YES;
    
    [self coreDataStartSettings];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


- (void) coreDataStartSettings {
    
    AppDelegate *applicationDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext= applicationDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:AS_Entity_Message_Name];
    
    NSSortDescriptor *emailDescriptor = [[NSSortDescriptor alloc]initWithKey:@"email" ascending:YES];
    [fetchRequest setSortDescriptors:@[emailDescriptor]];
  
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
}


#pragma mark - Actions

- (void) actionAddNewMessage {
    
    ASShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:AS_Identifier_For_ShareViewController];
    [self.navigationController pushViewController:shareVC animated:YES];
}


- (IBAction)actionRemoveAll:(UIButton*)sender {
    
    if (![self isRipositoryHaveSavedMessages]) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            
            self.alertView = [[UIAlertView alloc]initWithTitle:nil
                                       message:AS_Alert_Message_Text_For_Empty_Message_Storage
                                      delegate:self
                             cancelButtonTitle:AS_Alert_Action_Text_For_Confirm_Ok
                             otherButtonTitles:nil];
           
            [self.alertView show];
            
                        
        }else {
            
            self.alertController =
            [UIAlertController alertControllerWithTitle:nil
                                                message:AS_Alert_Message_Text_For_Empty_Message_Storage
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
        
    }else if ([self isRipositoryHaveSavedMessages]){
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            
            self.alertView = [[UIAlertView alloc]initWithTitle:nil
                                       message:AS_Alert_Message_Text_For_Remove_All_Messages
                                      delegate:self
                             cancelButtonTitle:AS_Alert_Action_Text_For_Confirm_Yes
                             otherButtonTitles:AS_Alert_Action_Text_For_Confirm_No
              ,nil];
            
            self.alertView.tag = ASAlertTypeRemoveAll;
            [self.alertView show];
            
        }else{
            
            self.alertController =
            [UIAlertController alertControllerWithTitle:nil
                                                message:AS_Alert_Message_Text_For_Remove_All_Messages
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *noAction =
            [UIAlertAction actionWithTitle:AS_Alert_Action_Text_For_Confirm_No
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
            
            UIAlertAction *yesAction =
            [UIAlertAction actionWithTitle:AS_Alert_Action_Text_For_Confirm_Yes
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       
                                       [self deleteAllDataObjects];
                                   }];
            
            [self.alertController addAction:yesAction];
            [self.alertController addAction:noAction];
            
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
    }
}


- (BOOL) isRipositoryHaveSavedMessages {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *messageEntityDescription = [NSEntityDescription entityForName:AS_Entity_Message_Name inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:messageEntityDescription];
    
    NSArray *fetchedObjectsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    BOOL returnResult = [fetchedObjectsArray count] > 0 ? YES : NO;
    return returnResult;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ASMessageInfoCell";
    
    ASMessageInfoCell *messageInfoCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    ASMessage *modelMessage = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [messageInfoCell addInfoFromMessage:modelMessage];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDeleteCell:)];
    longPressRecognizer.delegate = self;
    longPressRecognizer.minimumPressDuration = AS_Minimum_Time_Press_Duration_For_Delete_Cell;
    [messageInfoCell addGestureRecognizer:longPressRecognizer];
    
    return messageInfoCell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ASShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:AS_Identifier_For_ShareViewController];
    ASMessage *modelMessage = [self.fetchedResultsController objectAtIndexPath:indexPath];
    shareVC.modelMessage = modelMessage;
    [self.navigationController pushViewController:shareVC animated:YES];
}


#pragma mark - Gesture

- (void) handleDeleteCell: (UILongPressGestureRecognizer*) longGesture {
    
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint longTapPoint = [longGesture locationInView:self.tableView];
        self.indexPathForCell = [self.tableView indexPathForRowAtPoint:longTapPoint];
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            
            [[[UIAlertView alloc]initWithTitle:AS_Alert_Action_Text_For_Confirm_No
                                       message:AS_Alert_Message_Text_For_Remove_Certain_Message
                                      delegate:self
                             cancelButtonTitle:AS_Alert_Action_Text_For_Confirm_Yes
                             otherButtonTitles:AS_Alert_Action_Text_For_Confirm_No, nil]show];
            
            self.actionSheet.tag = ASAlertTypeDeleteCell;
            
        }else {
            
            self.alertController =
            [UIAlertController alertControllerWithTitle:nil
                                                message:AS_Alert_Message_Text_For_Remove_Certain_Message
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *noAction =
            [UIAlertAction actionWithTitle:AS_Alert_Action_Text_For_Confirm_No
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
            
            UIAlertAction *yesAction =
            [UIAlertAction actionWithTitle:AS_Alert_Action_Text_For_Confirm_Yes
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       
                                       [self deleteDefiniteDataObject];
                                   }];
            
            [self.alertController addAction:yesAction];
            [self.alertController addAction:noAction];
            
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *alertTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    NSLog(@"alet tag = %ld", (long)self.alertView.tag);
    
    if (buttonIndex == 0) {
        
        if (alertView.tag == ASAlertTypeDeleteCell) {
            [self deleteDefiniteDataObject];
        }else if (alertView.tag == ASAlertTypeRemoveAll){
            [self deleteAllDataObjects];
        }
    }
    
   
    
//    if (alertView.tag == ASAlertTypeDeleteCell) {
//        
//        if ([alertTitle isEqualToString:AS_Alert_Action_Text_For_Confirm_Yes]) {
//            [self deleteDefiniteDataObject];
//        }
//        }else if (alertView.tag == ASAlertTypeRemoveAll){
//            
//        if ([alertTitle isEqualToString:AS_Alert_Action_Text_For_Confirm_Yes]) {
//                [self deleteAllDataObjects];
//            }
//        }
    
}


#pragma mark - Data Object sending avay

- (void) deleteDefiniteDataObject {
    
    [self.managedObjectContext deleteObject:[self.fetchedResultsController.fetchedObjects objectAtIndex:self.indexPathForCell.row]];
    [self.managedObjectContext save:nil];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}


- (void) deleteAllDataObjects {
    
    NSArray *fetchedObjectsArray = self.fetchedResultsController.fetchedObjects;
    for (NSManagedObject *managedObject in fetchedObjectsArray) {
        [self.managedObjectContext deleteObject:managedObject];
    }
    [self.managedObjectContext save:nil];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

@end
