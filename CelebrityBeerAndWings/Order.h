//
//  Order.h
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/18/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Celebrity;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSString * orderString;
@property (nonatomic, retain) NSDate * orderTime;
@property (nonatomic, retain) Celebrity *celebrity;

@end
