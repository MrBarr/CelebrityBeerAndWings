//
//  Celebrity.h
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/18/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Celebrity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *orders;
@end

@interface Celebrity (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
