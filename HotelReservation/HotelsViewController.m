//
//  HotelsViewController.m
//  HotelReservation
//
//  Created by Cynthia Whitlatch on 11/30/15.
//  Copyright © 2015 Cynthia Whitlatch. All rights reserved.
//

#import "HotelsViewController.h"
#import "AppDelegate.h"
#import "NSObject+NSManagedObjectContext_Category.h"
#import "Hotel.h"
#import "RoomsViewController.h"
@import CoreData;
@import Foundation;

@interface HotelsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HotelsViewController

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        NSManagedObjectContext *context = [NSManagedObjectContext managerContext];
        
        request.sortDescriptors =@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        
//        _fetchedResultsController.delegate = self;
        
        
        NSError *error;
        [_fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        
        } else {
            NSLog(@"Successfully fetched ...");
        }
        
    }
    return _fetchedResultsController;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        
        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        _dataSource = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"Error fetching from Core Data");
            }
        }
    return _dataSource;
}

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIView *rootView = [[UIView alloc] init];    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rootView.frame style:UITableViewStylePlain];
    self.tableView = tableView;
    [tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [rootView addSubview:tableView];
    
    NSDictionary *views = @{@"tableView" : tableView};
    
    NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views];
    [rootView addConstraints:tableViewVerticalConstraints];
    NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views];
    [rootView addConstraints:tableViewHorizontalConstraints];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHotelsViewController];
    [self setupTableView];
}

- (void)setupHotelsViewController {
    [self setTitle:@"Hotels"];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    
    leading.active = YES;
    top.active = YES;
    trailing.active = YES;
    bottom.active = YES;
}

#pragma mark - TABLEVIEW DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Hotel *hotel = self.dataSource[indexPath.row];
    cell.textLabel.text = hotel.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImage *headerImage = [UIImage imageNamed:@"hotel"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:headerImage];
    imageView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 150.0);
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Hotel *hotel = self.dataSource[indexPath.row];
    RoomsViewController *roomsViewController = [[RoomsViewController alloc]init];
    roomsViewController.hotel = hotel;
    
    [self.navigationController pushViewController:roomsViewController animated:YES];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return YES;
//    
//}

//- (void)tabl

#pragma mark - FRCD

-(void)controller(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:([indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
             break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationMiddle];
            break:
        
        case NSFetchedResultsChangeUpdate: break;
        
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
        }
    }
                                                                                                     
@end