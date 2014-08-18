//
//  PersistentStack.h
//  napa
//
//  Created by Remy JOURDE on 29/06/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistentStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;

- (void)saveContext;

@end
