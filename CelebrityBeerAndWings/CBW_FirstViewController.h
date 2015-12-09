//
//  CBW_FirstViewController.h
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/9/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CD_TVC_inside_a_standard_VC.h"

@interface CBW_FirstViewController : CD_TVC_inside_a_standard_VC

-(NSFetchedResultsController*)createTheFRCforTheCDTVCforEntityName: (NSString*)entityName usingSortDescriptorKey: (NSString*)sortDescriptorKey andAscending: (BOOL)ascending;

@end
