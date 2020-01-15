//
//  Chef.m
//  GDC
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "Chef.h"

@interface Chef ()

@property (strong, nonatomic) NSOperationQueue *cookingQueue;

@end

@implementation Chef

- (instancetype)initWithChefId:(NSInteger)identifier cookingTime:(NSInteger)second  remainOrders:(NSArray<PizzaOrder *> *)orders {
    if (self = [super init]) {
        self.chefId = identifier;
        self.name = [NSString stringWithFormat:@"Pizza Chef %ld", identifier];
        self.cookingTime = second;
        self.remainOrders = [[NSMutableArray alloc] initWithArray:orders];
        self.isWorking = NO;
        
        _cookingQueue = [NSOperationQueue new];
        _cookingQueue.maxConcurrentOperationCount = 1;
        [_cookingQueue setSuspended:YES];

        for (PizzaOrder *order in self.remainOrders) {
            [self addOrder:order];
        }
    }
    return self;
}

- (void)addOrder:(PizzaOrder*)order {
    [self.remainOrders addObject:order];
    
    __block NSBlockOperation *cookOperation = [NSBlockOperation blockOperationWithBlock:^{

        if (cookOperation.isCancelled) {
            return ;
        }
        
        [NSThread sleepForTimeInterval:self.cookingTime];
        
        if (!cookOperation.isCancelled) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chef:didFinishedOrder:)]) {
                [self.delegate chef:self didFinishedOrder:order];
            }
            [self.remainOrders removeObject:order];
            if (self.delegate && [self.delegate respondsToSelector:@selector(chef:remaindOrdersNumber:)]) {
                [self.delegate chef:self remaindOrdersNumber:self.remainOrders.count];
            }
        }
    }];
    
    cookOperation.name = [NSString stringWithFormat:@"%ld",order.orderId];
    
    [_cookingQueue addOperation:cookOperation];
}

- (void)updateOrder:(PizzaOrder*)order succeed:(void(^)(void))success fail:(void(^)(NSString *))failure {

    if ([self.remainOrders containsObject:order]) {
        
        NSInteger index = [self.remainOrders indexOfObject:order];
        
        if ([self.cookingQueue.operations.firstObject.name isEqualToString:[NSString stringWithFormat:@"%ld",order.orderId]]) {
            
            failure(@"Order is being process, can not edit!");
        }else{
            [self.remainOrders replaceObjectAtIndex:index withObject:order];
        }
        
    }else{
        failure(@"Order not found!");
    }
    
}

- (void)cancelOrder:(PizzaOrder *)order succeed:(void(^)(void))success fail:(void(^)(NSString *))failure {
    if ([self.remainOrders containsObject:order]) {
        
        for (NSBlockOperation *op in self.cookingQueue.operations) {
            if ([op.name isEqualToString:[NSString stringWithFormat:@"%ld",order.orderId]]) {
                [op cancel];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(chef:didCanceledOrder:)]) {
                    [self.delegate chef:self didCanceledOrder:order];
                }
                
                [self.remainOrders removeObject:order];
                
                success();
            }
        }
        
    }else{
        failure(@"Order not found!");
    }
}


- (void)startCooking:(BOOL)fire {
    
    self.isWorking = fire;
    
    if (fire == _cookingQueue.isSuspended) {
        if (!fire && _cookingQueue.operationCount > 0) {
            
            
            NSBlockOperation *currentOp = _cookingQueue.operations.firstObject;
            PizzaOrder *currentOrder = self.remainOrders.firstObject;
            [currentOp cancel];
            

            __block NSBlockOperation *newOp = [NSBlockOperation blockOperationWithBlock:^{

                if (newOp.isCancelled) {
                    return ;
                }
                
                [NSThread sleepForTimeInterval:self.cookingTime];
                
                if (!newOp.isCancelled) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(chef:didFinishedOrder:)]) {
                        [self.delegate chef:self didFinishedOrder:currentOrder];
                    }
                    [self.remainOrders removeObject:currentOrder];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(chef:remaindOrdersNumber:)]) {
                        [self.delegate chef:self remaindOrdersNumber:self.remainOrders.count];
                    }
                }
            }];
            
            newOp.name = [NSString stringWithFormat:@"%ld",currentOrder.orderId];
            newOp.queuePriority = NSOperationQueuePriorityHigh;
            [self.cookingQueue addOperation:newOp];
        }
        
        [_cookingQueue setSuspended:!fire];
    }
}

@end
