//
//  LSQueue.m
//  LSQueue
//
//  Created by Leejay Schmidt on 2016-06-07.
//  Copyright © 2016 Leejay Schmidt. All rights reserved.
//

#import "LSQueue.h"
#import <limits.h>

@interface LSQueue ()

// the backing array for the queue
// needs to be both mutable and private to prevent people
// from accessing the array directly
@property (nonatomic) NSMutableArray *queue;
// the size to ceiling the number of objects in the queue at any moment
@property (nonatomic) NSUInteger size;

@end

@implementation LSQueue

#pragma mark - Initialization
- (id)init {
    // note: this is just a mapping of the backing array's
    // method to the queue's operation
    self = [super init];
    if (self) {
        // need to initialize both the backing array and the size value
        self.queue = [[NSMutableArray alloc] init];
        // assume no ceiling on capacity
        self.size = (NSUInteger)INT_MAX;
        // default eviction policy to oldest object being dumped
        self.evictionPolicy = LSQueueEvictOldest;
    }
    return self;
}

- (id)initWithSize:(NSUInteger)size {
    self = [super init];
    if (self) {
        //use initWithCapacity to maximize efficiency
        self.queue = [[NSMutableArray alloc] initWithCapacity:size];
        // set ceiling on size
        // this will be used to automatically determine when to dump
        // the oldest items in the queue
        self.size = size;
        // default eviction policy to oldest
        self.evictionPolicy = LSQueueEvictOldest;
    }
    return self;
}

#pragma mark - Standard queue operations
- (void)enqueueObject:(id)anObject {
    BOOL rejectNew = NO;
    // first ensure that queue is not going to be over capacity
    if ([self.queue count] == self.size) {
        if (self.evictionPolicy == LSQueueEvictOldest) {
            // if it is going to be overcapacity, dump the oldest one
            [self.queue removeLastObject];
        } else if (self.evictionPolicy == LSQueueEvictNewest) {
            // if it is going to be overcapacity, dump the newest one
            [self.queue removeObjectAtIndex:0];
        } else if (self.evictionPolicy == LSQueueEvictRejectNew) {
            rejectNew = YES;
        }
    }
    if (!rejectNew) {
        // queue up new item as the first object to follow FIFO structure
        [self.queue insertObject:anObject atIndex:0];
    }
}

- (id)dequeue {
    // grab the oldest (last) object using PEEK
    id anObject = [self peek];
    // if there is an object, then remove the object
    if (anObject) {
        [self.queue removeLastObject];
    }
    // return the dequeued object
    return anObject;
}

- (id)peek {
    // assume that the object is null
    id anObject = nil;
    // if there are objects in the queue, grab the last one
    if ([self.queue count]) {
        anObject = [self.queue lastObject];
    }
    // return that object
    // since this is just peek, it will not remove the object
    // from the queue
    return anObject;
}

- (id)dequeueObject:(id)anObject {
    // assume that there's no object to return
    id returnObject = nil;
    // check if the queue actually contains the desired object
    if ([self.queue containsObject:anObject]) {
        // if the object is in the queue, then grab it
        returnObject = anObject;
        // remove the object from the queue, per the dequeue contract
        [self.queue removeObject:anObject];
    }
    // return the object, if it was found, or nil otherwise
    return returnObject;
}

- (void)removeObject:(id)anObject {
    // leverage the backing array's removeObject method
    // note: this is just a mapping of the backing array's
    // method to the queue's operation
    [self.queue removeObject:anObject];
}

- (void)removeAllObjects {
    // leverage the backing array's removeAllObjects method
    // to dump all of the existing values
    // note: this is just a mapping of the backing array's
    // method to the queue's operation
    [self.queue removeAllObjects];
}

- (BOOL)isEmpty {
    // resolve to YES if the backing array's count is zero,
    // otherwise resolve to NO
    // this can be in-lined for expediency in code-writing
    return [self.queue count] == 0;
}

- (BOOL)containsObject:(id)anObject {
    // leverage the containsObject: method on the backing array
    // note: this is just a mapping of the backing array's
    // method to the queue's operation
    return [self.queue containsObject:anObject];
}

- (NSUInteger)count {
    // just leverage the existing count method on the backing array
    // note: this is just a mapping of the backing array's
    // method to the queue's operation
    return [self.queue count];
}

- (NSArray *)array {
    // this is a shallow copy...which is important!!
    return [self.queue copy];
}

- (NSArray *)deepCopiedArray {
    // in order to deep copy, we need to init a new array with the
    // elements copied, rather than just copying the pointers
    return [[NSArray alloc] initWithArray:self.queue copyItems:YES];
}

- (NSNumber *)averageQueue {
    // in order to prevent overflow, use a quad (128-bit float)
    quad_t currAverage = 0;
    // start out the count at zero (assume zero objects)
    int count = 0;
    // fast enumerate the queue, iterate
    for (NSObject *obj in self.queue) {
        // if the value is numeric, then you can average it in
        // if it is not a member of the NSNumber class, then it is
        // not going to be numeric, since if must be an NSObject stored
        // inside of an NSMutableArray
        if ([obj isKindOfClass:[NSNumber class]]) {
            // add the value to the current avraging value
            // ceiling pre-overflow with be quad_t max
            currAverage += (quad_t)[(NSNumber *)obj doubleValue];
            // increment the count of objects
            ++count;
        }
    }
    // divide out to find the actual average of the numeric values
    currAverage /= count;
    // turn into an NSNumber, as a double, since that is the largest
    // type that NSNumber handles (as a numeric)
    return @((double)currAverage);
}

@end
