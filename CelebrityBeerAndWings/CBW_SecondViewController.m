//
//  CBW_SecondViewController.m
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/9/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import "CBW_SecondViewController.h"

#import "Order.h"

#import "Celebrity.h"

#import "CBW_FirstViewController.h"

#define ALL_ORDERS_BY_TIME 100
#define ALL_ORDERS_BY_CELEBRITY 101
#define ALL_ORDERS_BY_BEVERAGE 102


@interface CBW_SecondViewController ()

@property (nonatomic) NSUInteger selectedReport;

@end

@implementation CBW_SecondViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
 
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"In view will appear");
    
    self.selectedReport = ALL_ORDERS_BY_TIME;
    
    [self selectReportAction:(UIButton*)[self.view viewWithTag:ALL_ORDERS_BY_TIME]];
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    
}

- (IBAction)selectReportAction:(UIButton *)sender {

    self.selectedReport = sender.tag;

    sender.selected = YES;
    
    for (NSUInteger loop = ALL_ORDERS_BY_TIME; loop <= ALL_ORDERS_BY_BEVERAGE; loop++) {
        if (self.selectedReport != loop) {
            [(UIButton*)[self.view viewWithTag:loop]setSelected: NO];
        }
    }
    
    NSString* entityNameString;
    NSString* sortDescriptorString;
    BOOL ascendingSortOrder;
    
    switch (self.selectedReport) {
            
        case ALL_ORDERS_BY_TIME:
            entityNameString = @"Order";
            sortDescriptorString = @"orderTime";
            ascendingSortOrder = YES;
            break;
            
        case ALL_ORDERS_BY_CELEBRITY:
            entityNameString = @"Order";
            sortDescriptorString = @"celebrity.name"; // Note: "celebrity" is a relationship to another entity, so you must specify the .name property of the "celebrity" relationship
            ascendingSortOrder = YES;
            break;
            
        case ALL_ORDERS_BY_BEVERAGE:
            entityNameString = @"Order";
            sortDescriptorString = @"orderString";
            ascendingSortOrder = YES;
            break;
            
        default:
            NSLog(@"Invalid selected report of %d in createTheFRCforTheCDTVC for secondViewController. Aborting on purpose.", self.selectedReport);
            abort();
    }

    
    self.fetchedResultsController = nil;
    
    // By getting the FRC via the first view controller I'm keeping all the managedObjectContext issues within the firstViewController.
    self.fetchedResultsController = [(CBW_FirstViewController*)[self.tabBarController.viewControllers firstObject]createTheFRCforTheCDTVCforEntityName:entityNameString usingSortDescriptorKey:sortDescriptorString andAscending:ascendingSortOrder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

// All other data source methods are handled by the parent class
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Report"];
    
    // Uses NSFetchedResultsController's objectAtIndexPath: to find the Order for this row in the table.
    // Then uses that Order to set the cell up.
    Order *order = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = order.celebrity.name;
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"HH':'mm':'ss' on 'EEE' 'MM'/'dd' "];
    NSString* dateString = @"Time: ";
    dateString = [dateString stringByAppendingString:[dateFormater stringFromDate:order.orderTime]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", dateString, order.orderString];
    
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    return cell;
}

@end
