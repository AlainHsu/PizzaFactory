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
@property (strong, nonatomic) PizzaOrder *currentOrder;
@property (strong, nonatomic) NSMutableArray<PizzaOrder *> * dropOrders;

@end

@implementation Chef

- (instancetype)initWithChefId:(NSInteger)identifier cookingTime:(NSInteger)second  remainOrders:(NSArray<PizzaOrder *> *)orders {
    if (self = [super init]) {
        self.chefId = identifier;
        self.name = [NSString stringWithFormat:@"Pizza Chef %ld", identifier];
        self.cookingTime = second;
        self.remainOrders = [[NSMutableArray alloc] initWithArray:orders];
        self.isWorking = NO;
        self.dropOrders = [NSMutableArray new];
        
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
    
    __weak typeof(self) weakSelf = self;
    
    [_cookingQueue addOperationWithBlock:^{
        [weakSelf cook:order];
    }];
    
}

- (void)cook:(PizzaOrder *)order {
    self.currentOrder = order;
    
    [NSThread sleepForTimeInterval:self.cookingTime];
    
    if ([self.dropOrders containsObject:order]) {
        NSLog(@"dropped: %ld", order.orderId);
        [self.dropOrders removeObject:order];
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chef:didFinishedOrder:)]) {
            [self.delegate chef:self didFinishedOrder:order];
        }
        [self.remainOrders removeObject:order];
        if (self.delegate && [self.delegate respondsToSelector:@selector(chef:remaindOrdersNumber:)]) {
            [self.delegate chef:self remaindOrdersNumber:self.remainOrders.count];
        }
    }
}

- (void)updateOrder:(PizzaOrder*)PizzaOrder succeed:(void(^)(void))success fail:(void(^)(NSString *))failure {
    if (self.remainOrders.count > 0) {
        
        if (self.remainOrders.firstObject.orderId == PizzaOrder.orderId) {
            failure(@"Order is being process, can not edit!");
        } else if (self.remainOrders.firstObject.orderId < PizzaOrder.orderId && self.remainOrders.lastObject.orderId >= PizzaOrder.orderId) {
            
            [self.remainOrders replaceObjectAtIndex:(PizzaOrder.orderId - self.remainOrders.firstObject.orderId) withObject:PizzaOrder];
            success();
        } else {
            failure(@"Order not found!");
        }

    }else{
        failure(@"Order not found!");
    }

}

- (void)startCooking:(BOOL)fire {
    
    self.isWorking = fire;
    
    if (fire == _cookingQueue.isSuspended) {
        if (!fire && _cookingQueue.operationCount > 0 && ![self.dropOrders containsObject:self.currentOrder]) {
            
            [self.dropOrders addObject:self.currentOrder];

            NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(cook:) object:self.currentOrder];
            op.queuePriority = NSOperationQueuePriorityHigh;
            [self.cookingQueue addOperation:op];
        }
        
        [_cookingQueue setSuspended:!fire];
    }
}

@end
