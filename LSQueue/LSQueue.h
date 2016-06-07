//
//  LSQueue.h
//  LSQueue
//
//  Created by Leejay Schmidt on 2016-06-07.
//  Copyright © 2016 Leejay Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSQueue<ObjectType> : NSObject

-(nullable id)initWithSize:(NSUInteger)size;
-(void)enqueueObject:(nonnull ObjectType)anObject;
-(nullable ObjectType)dequeue;
-(nullable ObjectType)peek;
-(nullable ObjectType)dequeueObject:(nonnull ObjectType)anObject;
-(void)removeObject:(nonnull ObjectType)anObject;
-(void)removeAllObjects;
-(BOOL)isEmpty;
-(BOOL)containsObject:(nonnull ObjectType)anObject;
-(NSUInteger)count;

@end
