//
//  Celebrity+create.m
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/21/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import "Celebrity+create.h"

@implementation Celebrity (create)

+(Celebrity*)createCelebrity: (NSString*)celebrity inManagedObjectContext: (NSManagedObjectContext*)context
{
    NSLog(@"In createCelebrity");
    
    Celebrity* managedObjectCelebrity;
    
    //So let's create a celebrity
    
    managedObjectCelebrity = [NSEntityDescription insertNewObjectForEntityForName:@"Celebrity" inManagedObjectContext:context];
    
    //Configure the new object set the orderString
    managedObjectCelebrity.name = celebrity;
    
    //Just return the new managed object celebrity
    NSLog(@"Returning a NEW managedobject for CELEBRITY");
    return managedObjectCelebrity;
 
}
@end
