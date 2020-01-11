//
//  PizzaOrderFactory.m
//  GDC
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "PizzaFactory.h"

@implementation PizzaFactory

- (instancetype)initWithChefs:(NSArray<Chef *> *)chefs{
    if (self = [super init]) {
        self.chefs = [[NSMutableArray alloc] initWithArray:chefs];
    }
    return self;
}

- (PizzaOrder *)createOrder:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings {
    
    return [self createOrders:1 size:size toppings:toppings].firstObject;
}

- (NSArray <PizzaOrder *> *)createOrders:(NSInteger)count size:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings {
    if (count < 1) {
        return nil;
    }
    
    NSInteger lastOrderId = [[NSUserDefaults standardUserDefaults] integerForKey:@"order_id"];
    
    NSMutableArray *orders = [NSMutableArray new];
    for (NSInteger i = lastOrderId; i < lastOrderId + count; i++) {
        PizzaOrder *pizzaOrder = [[PizzaOrder alloc] initWithOrderId:i size:size topping:toppings];
        [orders addObject:pizzaOrder];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:lastOrderId + count forKey:@"order_id"];
        
    return orders;
}



- (void)addOrders:(NSArray<PizzaOrder *> *)orders {
    for (PizzaOrder *order in orders) {
        Chef *chef = [self.chefs objectAtIndex: order.orderId % (self.chefs.count)];
        [chef addOrder:order];
    }
}

- (void)openFactory:(BOOL)open {
    for (Chef *chef in self.chefs) {
        [chef startCooking:open];
    }
}

@end
