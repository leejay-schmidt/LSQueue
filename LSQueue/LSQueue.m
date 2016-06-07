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
    self = [super init];
    if (self) {
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
    id anObject = [self poll];
    if (anObject) {
        [self.queue removeLastObject];
    }
    return anObject;
}

- (id)poll {
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
    [self.queue removeObject:anObject];
}

- (void)removeAllObjects {
    [self.queue removeAllObjects];
}

- (BOOL)isEmpty {
    return [self.queue count] == 0;
}

- (BOOL)containsObject:(id)anObject {
    return [self.queue containsObject:anObject];
}

@end
