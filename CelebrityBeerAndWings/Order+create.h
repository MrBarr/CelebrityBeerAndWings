//
//  Order+create.h
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/21/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import "Order.h"

@interface Order (create)

+(Order*)createOrderforCelebrity: (NSString*)celebrity forOrder: (NSString*)order inManagedObjectContext: (NSManagedObjectContext*)context;

@end
