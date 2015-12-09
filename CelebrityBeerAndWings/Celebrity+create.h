//
//  Celebrity+create.h
//  CelebrityBeerAndWings
//
//  Created by Andrew (Laptop) on 3/21/13.
//  Copyright (c) 2013 Andrew (Laptop). All rights reserved.
//

#import "Celebrity.h"

@interface Celebrity (create)

+(Celebrity*)createCelebrity: (NSString*)celebrity inManagedObjectContext: (NSManagedObjectContext*)context;
@end
