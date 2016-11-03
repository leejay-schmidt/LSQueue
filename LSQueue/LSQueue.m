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

@property (nonatomic) NSMutableArray *queue;
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
        self.size = (NSUInteger)INT_MAX;
    }
    return self;
}

- (id)initWithSize:(NSUInteger)size {
    self = [super init];
    if (self) {
        //use initWithCapacity to maximize efficiency
        self.queue = [[NSMutableArray alloc] initWithCapacity:size];
        self.size = size;
    }
    return self;
}

#pragma mark - Standard queue operations
- (void)enqueueObject:(id)anObject {
    if ([self.queue count] == self.size) {
        [self.queue removeLastObject];
    }
    [self.queue insertObject:anObject atIndex:0];
}

- (id)dequeue {
    id anObject = [self peek];
    if (anObject) {
        [self.queue removeLastObject];
    }
    return anObject;
}

- (id)peek {
    id anObject = nil;
    if ([self.queue count]) {
        anObject = [self.queue lastObject];
    }
    return anObject;
}

- (id)dequeueObject:(id)anObject {
    id returnObject = nil;
    if ([self.queue containsObject:anObject]) {
        returnObject = anObject;
        [self.queue removeObject:anObject];
    }
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
