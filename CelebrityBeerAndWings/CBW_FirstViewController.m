//
//  CBW_FirstViewController.m
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/9/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import "CBW_FirstViewController.h"

#import "CBW_collectionViewCellWithButton.h"

#import "Order+create.h"

#import "Celebrity.h" // Just interesting: Do not need the category here, see Order+create.m it is used there

@interface CBW_FirstViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong,nonatomic)  NSManagedObjectContext* managedObjectContext;

@property (weak, nonatomic) IBOutlet UICollectionView *celebrityCV;

@property (weak, nonatomic) IBOutlet CBW_collectionViewCellWithButton *celebrityCell;

@property (weak, nonatomic) IBOutlet UICollectionView *beerCV;

@property (weak, nonatomic) IBOutlet CBW_collectionViewCellWithButton *beerCell;

@property (weak, nonatomic) IBOutlet UICollectionView *wingCV;

@property (weak, nonatomic) IBOutlet CBW_collectionViewCellWithButton *wingCell;

@property (weak, nonatomic) IBOutlet UICollectionView *sidesCV;

@property (weak, nonatomic) IBOutlet CBW_collectionViewCellWithButton *sidesCell;

@property (weak, nonatomic) IBOutlet UILabel* noOrdersLabel;


@property (strong, nonatomic) NSArray* celebrityList;

@property (strong, nonatomic) NSArray* beerList;

@property (strong, nonatomic) NSArray* wingList;

@property (strong, nonatomic) NSArray* sidesList;


@property (strong, nonatomic) NSMutableDictionary* currentSelections;



-(IBAction)placeOrder;

@end

@implementation CBW_FirstViewController




-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"In view will appear");
    self.debug = YES;
    
    
    // Will use the UIDocument and set the FRC in this method "useDocument"
    [self useDocument];
    
    
}
    
-(NSMutableDictionary*)currentSelections // Custom setter (BE CAREFUL, MAKE SURE YOU SPECIFY MUTABLE)
{
    if (!_currentSelections) {
        
        // Keys
        NSArray* keysArray = @[@"celebrity",@"beer",@"wings",@"sides"];
        
        // Just fill each key with a null value so its easy to tell when it hasn't been set
        NSMutableArray* valuesArray = [NSMutableArray arrayWithCapacity:[keysArray count]];
        for (NSUInteger loop = 0; loop < keysArray.count; loop++) { [valuesArray addObject:[NSNull null]]; }

        _currentSelections = [NSMutableDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
        
    }
    
    return _currentSelections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.celebrityCV]) {
        return [self.celebrityList count];
    } else if ([collectionView isEqual:self.beerCV]) {
        return [self.beerList count];
    } else if ([collectionView isEqual:self.wingCV]) {
        return [self.wingList count];
    } else if ([collectionView isEqual:self.sidesCV]) {
        return [self.sidesList count];
    }
    
    NSLog(@"Aborting");
    abort();
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* theCellIdentifier;
    NSArray* theListOfItemsToChooseFrom;
    
    
    if ([collectionView isEqual:self.celebrityCV]) {
        
        theCellIdentifier = @"celebrityCell";
        theListOfItemsToChooseFrom = [NSArray arrayWithArray:self.celebrityList];
        
    } else if ([collectionView isEqual:self.beerCV]) {
        
        theCellIdentifier = @"beerCell";
        theListOfItemsToChooseFrom = [NSArray arrayWithArray:self.beerList];
        
    } else if ([collectionView isEqual:self.wingCV]) {
        
        theCellIdentifier = @"wingCell";
        theListOfItemsToChooseFrom = [NSArray arrayWithArray:self.wingList];
        
    } else if ([collectionView isEqual:self.sidesCV]) {
        
        theCellIdentifier = @"sidesCell";
        theListOfItemsToChooseFrom = [NSArray arrayWithArray:self.sidesList];
        
    } else {
        
        NSLog(@"Aborting");
        abort();
    }
    
        
    CBW_collectionViewCellWithButton* cell = [collectionView dequeueReusableCellWithReuseIdentifier:theCellIdentifier forIndexPath:indexPath];
    
    
    [cell.cellButton setTitle:[theListOfItemsToChooseFrom objectAtIndex:indexPath.row] forState:UIControlStateNormal];

    [cell.cellButton setTitle:[NSString stringWithFormat:@"✔ %@",[theListOfItemsToChooseFrom objectAtIndex:indexPath.row]] forState:UIControlStateSelected];
    
    [cell.cellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
   
    return cell;

}

#pragma mark - MAGIC
// Here is the magic, you can add or remove as desired and the UI adjusts
-(void)awakeFromNib
{
    self.celebrityList = @[@"Kristen Stewart",@"Clint Eastwood",@"Harrison Ford",@"Jennifer Aniston",@"Julia Roberts",@"George Clooney"];
    
    [self.celebrityCV registerClass:(Class)self.celebrityCell forCellWithReuseIdentifier:@"celebrityCell"];
    
    self.beerList = @[@"Budweiser",@"Bud-Lite",@"Heineken",@"Tonic Water"];
    
    [self.beerCV registerClass:(Class)self.beerCell forCellWithReuseIdentifier:@"beerCell"];
    
    self.wingList = @[@"Hot",@"Medium",@"Mild",@"BBQ"];
    
    [self.wingCV registerClass:(Class)self.wingCell forCellWithReuseIdentifier:@"wingCell"];
    
    self.sidesList = @[@"Blue Cheese",@"Ranch",@"Celery"];
    
    [self.sidesCV registerClass:(Class)self.sidesCell forCellWithReuseIdentifier:@"sidesCell"];
    
    
}

// VERY IMPORTANT TO UNDERSTAND: The button in each collection view cell is user interaction DISABLED (ie: the checkmark removed in the storyboard). This allows the tap to pass through the button view to the collection view. I use the button view for its "view properties" as opposed to its "gesture properties". I use the collection view itself for the tap gesture by ways of the didSelectItemAtIndexPath: delegate method. 
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Selected an item in a collection view");
    
    UIButton *buttonFromCell;
    NSString *keyToSet;
    
    buttonFromCell = (UIButton*)[(CBW_collectionViewCellWithButton*)[collectionView cellForItemAtIndexPath:indexPath]cellButton];
    
    if ([collectionView isEqual:self.celebrityCV]) {
        
        keyToSet = @"celebrity";
        
    } else if ([collectionView isEqual:self.beerCV]) {
        
        keyToSet = @"beer";
        
    } else if ([collectionView isEqual:self.wingCV]) {
        
        keyToSet = @"wings";
        
    } else if ([collectionView isEqual:self.sidesCV]) {
        
        keyToSet = @"sides";
        
    } else {
        
        NSLog(@"Aborting");
        abort();
    }
    
    NSString* tempStringForSettingCurrentSelection;
    
    // FIRST handle "sides". Sides is a special case because more than one selection is allowed.
    if ([keyToSet isEqualToString:@"sides"]) {
        
        tempStringForSettingCurrentSelection = @"Sides: ";
        
        [buttonFromCell setSelected:(![buttonFromCell isSelected])]; // togle selection
        
        for (int x = 0; x < [collectionView numberOfItemsInSection:indexPath.section]; x++) {
            
            
            NSString* stringToAppend = [[(CBW_collectionViewCellWithButton*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:indexPath.section]]cellButton]titleForState:UIControlStateNormal];
            
            if ([[(CBW_collectionViewCellWithButton*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:indexPath.section]]cellButton]isSelected]) {
                
                
                tempStringForSettingCurrentSelection = [tempStringForSettingCurrentSelection stringByAppendingFormat:@"%@ ",stringToAppend];
                
            
            } 
            
        } // end bracket for loop
        
        if ([tempStringForSettingCurrentSelection isEqualToString:@"Sides: "]) {
            
            [self.currentSelections setValue: @"Sides: none" forKey:@"sides"];
        } else {
        
        [self.currentSelections setValue: tempStringForSettingCurrentSelection forKey:@"sides"];

        }
        
        return;

    } else { // SECOND - Now for the standard cases (only one selection allowed).
    
    tempStringForSettingCurrentSelection = (NSString*)[buttonFromCell titleForState:UIControlStateNormal];

    [buttonFromCell setSelected:YES];
    
    [self.currentSelections setValue: tempStringForSettingCurrentSelection forKey:keyToSet];

    for (int x = 0; x < [collectionView numberOfItemsInSection:indexPath.section]; x++) {
        
        if (x != indexPath.row) {
            
            [[(CBW_collectionViewCellWithButton*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:indexPath.section]]cellButton]setSelected:NO];
            
        }
                
    }

    return;
        
    }
}


-(IBAction)placeOrder
{
    
    if ( ([self.currentSelections valueForKey:@"celebrity"] == [NSNull null]) || ([self.currentSelections valueForKey:@"beer"] == [NSNull null]) || ([self.currentSelections valueForKey:@"wings"] == [NSNull null]) ) {
        
        return;
    }
    
    if ([self.currentSelections valueForKey:@"sides"] == [NSNull null]) {
        
        [self.currentSelections setValue:@"Sides: none" forKey:@"sides"];
    }
    
    
    NSString* celebrityString = [self.currentSelections valueForKey:@"celebrity"];
    NSString* orderString = [NSString stringWithFormat:@"%@, %@ Wings, %@",[self.currentSelections valueForKey:@"beer"],[self.currentSelections valueForKey:@"wings"],[self.currentSelections valueForKey:@"sides"]];
    
    NSLog(@"\n\nPlacing order for celebrity: %@ \nThe order: %@ \n\n",celebrityString, orderString);
    NSLog(@"\n\n");

    
    [self resetAllButtonsAndCurrentSelections];
    
    [Order createOrderforCelebrity:celebrityString forOrder:orderString inManagedObjectContext:self.managedObjectContext];
    
    
}


// Either creates, opens or just uses the demo document
//   (actually, it will never "just use" it since it just creates the UIManagedDocument instance here;
//    the "just uses" case is just shown that if someone hands you a UIManagedDocument, it might already
//    be open and so you can just use it if it's documentState is UIDocumentStateNormal).
//
// Creating and opening are asynchronous, so in the completion handler we set our Model (managedObjectContext).

- (void)useDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Orders Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  NSLog(@"Creating Orders Document (a UIDocument). Setting FRC");
                  // Set the FRC for the CDTVC (this class is a child of CDTVC)
                  self.fetchedResultsController = [self createTheFRCforTheCDTVCforEntityName:@"Order" usingSortDescriptorKey:@"orderTime" andAscending:NO];

              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                NSLog(@"Opening Orders Document (a UIDocument). Setting FRC");
                // Set the FRC for the CDTVC (this class is a child of CDTVC)
                self.fetchedResultsController = [self createTheFRCforTheCDTVCforEntityName:@"Order" usingSortDescriptorKey:@"orderTime" andAscending:NO];

            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
        NSLog(@"The Orders Document (a UIDocument) already exists and is open. Setting FRC");
        // Set the FRC for the CDTVC (this class is a child of CDTVC)
        self.fetchedResultsController = [self createTheFRCforTheCDTVCforEntityName:@"Order" usingSortDescriptorKey:@"orderTime" andAscending:NO];

    }
    

}

-(NSFetchedResultsController*)createTheFRCforTheCDTVCforEntityName: (NSString*)entityName usingSortDescriptorKey: (NSString*)sortDescriptorKey andAscending: (BOOL)ascending
{
    
    if (entityName == nil) {
        entityName = @"Order";
    }
    
    if (sortDescriptorKey == nil) {
        sortDescriptorKey = @"orderTime";
    }
    
    // Note: ascending will be NO by default unless passed in
    
    // Build a fetch request for all the orders in the database sorted by date and return it
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortDescriptorKey ascending:ascending]]; // 12/8/15 1044 Changed to NO for better readablility for new orders placed
    
    request.predicate = nil; // Just making it obvious
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return  fetchedResultsController;

}


-(void)resetAllButtonsAndCurrentSelections
{
    self.currentSelections = nil;
    
    [self resetButtons:self.celebrityCV];
    [self resetButtons:self.wingCV];
    [self resetButtons:self.beerCV];
    [self resetButtons:self.sidesCV];
    
    return;
}


-(void)resetButtons: (UICollectionView*) collectionView
{
    for (int x = 0; x < [collectionView numberOfItemsInSection:0]; x++) {
       
        [[(CBW_collectionViewCellWithButton*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:0]]cellButton]setSelected:NO];
    }
}
                        
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    if ([self.celebrityCV numberOfItemsInSection:0] > 4) {
        
        [self bounceCVoffBottomAndScrollBackToTopPart1: self.celebrityCV];

    }
    
    //[self.tableView reloadData];

}

-(void)bounceCVoffBottomAndScrollBackToTopPart1: (UICollectionView*)aCollectionView
{
    
    NSIndexPath* bottomIndexPath = [NSIndexPath indexPathForItem:([aCollectionView numberOfItemsInSection:0]-1) inSection:0];
    [aCollectionView scrollToItemAtIndexPath:bottomIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        
    [self performSelector:@selector(bounceCVoffBottomAndScrollBackToTopPart2:) withObject:aCollectionView afterDelay:1.0];
}
    
-(void)bounceCVoffBottomAndScrollBackToTopPart2: (UICollectionView*)aCollectionView
{
    NSIndexPath* topIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [aCollectionView scrollToItemAtIndexPath:topIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        
    [self performSelector:@selector(bounceCVoffBottomAndScrollBackToTopPart3:) withObject:aCollectionView afterDelay:0.5];
}

-(void)bounceCVoffBottomAndScrollBackToTopPart3: (UICollectionView*)aCollectionView
{
    [aCollectionView flashScrollIndicators];
}



#pragma mark - UITableViewDataSource

// All other data source methods are handled by the parent class
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Order"];
    
    // Uses NSFetchedResultsController's objectAtIndexPath: to find the Order for this row in the table.
    // Then uses that Order to set the cell up.
    Order *order = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = order.celebrity.name;
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"HH':'mm':'ss' on 'EEE' 'MM'/'dd' "];
    NSString* dateString = @"Time: ";
    dateString = [dateString stringByAppendingString:[dateFormater stringFromDate:order.orderTime]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", dateString, order.orderString];
        
    self.noOrdersLabel.hidden = YES; // If this method is called there must be at least one order.
    
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    return cell;
}

@end
