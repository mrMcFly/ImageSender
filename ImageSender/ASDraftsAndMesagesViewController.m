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

@interface ASDraftsAndMesagesViewController ()  <UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIAlertController *alertController;

@end


@implementation ASDraftsAndMesagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Drafts and sent messages";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *addNewMessageButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNewMessage)];
    
    //[addButton setBackgroundImage:[UIImage imageNamed:@"AddMessageButton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:EntityMessageName];
    
    NSSortDescriptor *emailDescriptor = [[NSSortDescriptor alloc]initWithKey:@"email" ascending:YES];
    [fetchRequest setSortDescriptors:@[emailDescriptor]];
  
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
}


#pragma mark - Actions

- (void) actionAddNewMessage {
    
    ASShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:IdentifierForASShareViewController];
    [self.navigationController pushViewController:shareVC animated:YES];
}


- (IBAction)actionRemoveAll:(UIButton*)sender {
    
    NSString *alertMessageText = nil;
    
    if (![self isRipositoryHaveSavedMessages]) {
        
        alertMessageText = AlertMessageTextForEmptyMessageStorage;
        
        self.alertController = [UIAlertController alertControllerWithTitle:nil
                                                                   message:alertMessageText
                                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:AlertActionTextForConfirmOk style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.alertController addAction:okAction];
        [self presentViewController:self.alertController animated:YES completion:nil];
        
    }else{
        
        alertMessageText = AlertMessageTextForRemoveAllMessages;
        
        self.alertController = [UIAlertController alertControllerWithTitle:nil message:alertMessageText preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:AlertActionTextForConfirmNo style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:AlertActionTextForConfirmYes style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSArray *fetchedObjectsArray = self.fetchedResultsController.fetchedObjects;
            for (NSManagedObject *managedObject in fetchedObjectsArray) {
                [self.managedObjectContext deleteObject:managedObject];
            }
            [self.managedObjectContext save:nil];
            [self.fetchedResultsController performFetch:nil];
            [self.tableView reloadData];
        }];
        
        [self.alertController addAction:yesAction];
        [self.alertController addAction:noAction];
        
        [self presentViewController:self.alertController animated:YES completion:nil];
    }
}


- (BOOL) isRipositoryHaveSavedMessages {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *messageEntityDescription = [NSEntityDescription entityForName:EntityMessageName inManagedObjectContext:self.managedObjectContext];
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
    longPressRecognizer.minimumPressDuration = 2.0;
    [messageInfoCell addGestureRecognizer:longPressRecognizer];
    
    return messageInfoCell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ASShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:IdentifierForASShareViewController];
    ASMessage *modelMessage = [self.fetchedResultsController objectAtIndexPath:indexPath];
    shareVC.modelMessage = modelMessage;
    [self.navigationController pushViewController:shareVC animated:YES];
}


#pragma mark - Gesture

- (void) handleDeleteCell: (UILongPressGestureRecognizer*) longGesture {
    
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint longTapPoint = [longGesture locationInView:self.tableView];
        NSIndexPath *indexPathForCell = [self.tableView indexPathForRowAtPoint:longTapPoint];
        
        NSString *removeMessageText = AlertMessageTextForRemoveCertainMessage;

        self.alertController = [UIAlertController alertControllerWithTitle:nil message:removeMessageText preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:AlertActionTextForConfirmNo style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:AlertActionTextForConfirmYes style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            [self.managedObjectContext deleteObject:[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPathForCell.row]];
            [self.managedObjectContext save:nil];
            [self.fetchedResultsController performFetch:nil];
            [self.tableView reloadData];
        }];
        [self.alertController addAction:noAction];
        [self.alertController addAction:yesAction];
        
        [self presentViewController:self.alertController animated:YES completion:nil];
    }
}


@end
