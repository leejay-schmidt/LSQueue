//
//  LSQueue.h
//  LSQueue
//
//  Created by Leejay Schmidt on 2016-06-07.
//  Copyright © 2016 Leejay Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LSQueueEvictPolicy) {
    LSQueueEvictOldest,
    LSQueueEvictNewest,
    LSQueueEvictRejectNew
};

@interface LSQueue<ObjectType> : NSObject

@property (nonatomic) LSQueueEvictPolicy evictionPolicy;

/*
 Creates a new queue with the given capacity/size limit
 @param size The desired capacity/size limit for the queue
 @return New LSQueue object
 */
-(nullable id)initWithSize:(NSUInteger)size;
/*
 Adds a new item to the front of the queue, and discards the
 oldest object if capacity is reached
 @param anObject The object to add to the queue (must be non-null)
 */
-(void)enqueueObject:(nonnull ObjectType)anObject;
/*
 Removes and returns the oldest object in the queue
 @returns The oldest object in the queue, or nil if empty queue
 */
-(nullable ObjectType)dequeue;
/*
 Returns the oldest object in the queue while retaining it
 @returns The oldest object in the queue, or nil if empty queue
 */
-(nullable ObjectType)peek;
/*
 Removes and returns the given object if it exists in the queue
 @param anObject The object to find and return if exists
 @returns Given object from queue, or nil if it doesn't exist
 */
-(nullable ObjectType)dequeueObject:(nonnull ObjectType)anObject;
/*
 Removes the given object from the queue if it exists in the queue
 @param anObject The object to find and remove if exists
 */
-(void)removeObject:(nonnull ObjectType)anObject;
/*
 Clears all objects from the queue
 */
-(void)removeAllObjects;
/*
 Tells whether there are any objects currently retained in the queue
 @returns YES if no objects in queue, NO otherwise
 */
-(BOOL)isEmpty;
/*
 Tells whether the given object exists in the queue
 @param anObject The object to search for in the queue
 @returns YES if the object exists, otherwise NO
 */
-(BOOL)containsObject:(nonnull ObjectType)anObject;
/*
 Gives the current number of objects in the queue
 @returns The total number of objects enqueued
 */
-(NSUInteger)count;
/*
 Gives the numerical average of all NSNumber objects in the queue
 @returns Average of all NSNumber objects, as an NSNumber
 */
-(nonnull NSNumber *)averageQueue;

@end
