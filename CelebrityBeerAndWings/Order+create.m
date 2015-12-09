//
//  Order+create.m
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/21/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import "Order+create.h"
#import "Celebrity+create.h"

@implementation Order (create)


+(Order*)createOrderforCelebrity: (NSString*)celebrity forOrder: (NSString*)order inManagedObjectContext: (NSManagedObjectContext*)context
{
    NSLog(@"In createOrder");
    
    Order* newManagedObjectOrder;
    
    //So let's create a order
    
    newManagedObjectOrder = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
    
    //Configure the new object set the orderString and the orderTime (to now)
    newManagedObjectOrder.orderString = order;
    newManagedObjectOrder.orderTime = [NSDate date];
    
    // But now we need to set the celebrity, first we have to get the celebrity
    
    // Build a fetch request to see if we can find the celebrity in the database.
    // The "name" attribute in Celebrity is how we will match up the celebrity.
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Celebrity"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", celebrity];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    
    if ([matches count] == 0) { // The celebrity doesn't exist yet, create it & set it
        
        NSLog(@"The celebrity doesn't exist yet, create it & set it.");
        
        // Create the new celebrity
        Celebrity* newCelebrityManagedObject;
        
        newCelebrityManagedObject = [Celebrity createCelebrity:celebrity inManagedObjectContext:context];
                
        // Now set the new celebrity to the order
        newManagedObjectOrder.celebrity = newCelebrityManagedObject;
        
        
    } else if ([matches count] == 1) { // the celebrity exists, just set it
        
        NSLog(@"The celebrity exists, just set it.");
        
        newManagedObjectOrder.celebrity = (Celebrity*)[matches lastObject];
        
    } else if ([matches count] > 1) { // opps an error occurred
        NSLog(@"An error occured in a fetch to find a celebrity, more than one match found (in create new order category)...");
        abort();
    }
    
    // Now we are done with create, just return the new object
    
    NSLog(@"Returning a NEW managedobject for ORDER");
    return newManagedObjectOrder;
    
}

@end
