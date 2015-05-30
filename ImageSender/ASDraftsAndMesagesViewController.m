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

@interface ASDraftsAndMesagesViewController ()  <UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end


@implementation ASDraftsAndMesagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Drafts and sent messages";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddNewMessage)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext= delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ASMessage"];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES]]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;

#warning Праильно ли так избавляться от разделителя в ячейках (выставил,чтобы их не было видно)!?
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (void) actionAddNewMessage {
    
    ASShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASShareViewController"];
    [self.navigationController pushViewController:shareVC animated:YES];
}


- (IBAction)actionRemoveAll:(UIButton*)sender {
    
#warning правльно ли делать эту месседж-строку статической?
    static NSString *alertMessage = @"Are you sure you want to remove all messages?";
    
    UIAlertController *removeAlertContrl = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
#warning Delete ALL messages
        //Work with tableView and ASMessage
        NSArray *array = self.fetchedResultsController.fetchedObjects;
        for (NSManagedObject *managedObject in array) {
            [self.managedObjectContext deleteObject:managedObject];
        }
        [self.managedObjectContext save:nil];
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
    }];
    [removeAlertContrl addAction:noAction];
    [removeAlertContrl addAction:yesAction];
    
    [self presentViewController:removeAlertContrl animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
#warning Возможно тут заменить на ASMessage?
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ASMessageInfoCell";
    
    ASMessageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ASMessage *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell addInfoFromMessage:message];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDeleteCell:)];
    longPressRecognizer.delegate = self;
    longPressRecognizer.minimumPressDuration = 2.0;
    [cell addGestureRecognizer:longPressRecognizer];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ASShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASShareViewController"];
    ASMessage *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    shareVC.message = message;
    [self.navigationController pushViewController:shareVC animated:YES];
}


#pragma mark - Gesture

- (void) handleDeleteCell: (UILongPressGestureRecognizer*) longGesture {
    
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint longTapPoint = [longGesture locationInView:self.tableView];
        NSIndexPath *indexPathForCell = [self.tableView indexPathForRowAtPoint:longTapPoint];
        
        static NSString *removeMessage = @"Are you sure you want to remove this message?";
        
        UIAlertController *removeAlertContrl = [UIAlertController alertControllerWithTitle:nil message:removeMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            [self.managedObjectContext deleteObject:[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPathForCell.row]];
            [self.managedObjectContext save:nil];
            [self.fetchedResultsController performFetch:nil];
            [self.tableView reloadData];
        }];
        [removeAlertContrl addAction:noAction];
        [removeAlertContrl addAction:yesAction];
        
        [self presentViewController:removeAlertContrl animated:YES completion:nil];
    }
}

@end
