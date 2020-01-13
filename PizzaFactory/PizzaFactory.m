//
//  PizzaOrderFactory.m
//  GDC
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "PizzaFactory.h"

#define ORDER_ID    @"order_id"
#define TOTAL_ORDER @"total_orders"

@interface PizzaFactory ()<ChefDelegate>

@end

@implementation PizzaFactory

- (instancetype)initWithChefs:(NSInteger)number {
    if (self = [super init]) {
        
        self.chefs = [NSMutableArray new];
        for (int i = 0; i < number; i++) {
            Chef *chef = [[Chef alloc] initWithChefId:i cookingTime:i+1 remainOrders:nil];
            chef.delegate = self;
            [self.chefs addObject:chef];
        }

        NSMutableArray *ordersArray  = [NSMutableArray new];
        
        NSMutableDictionary *ordersDic  = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:TOTAL_ORDER]];

        NSArray *ordersDataArray = [[NSArray alloc] initWithArray:ordersDic.allKeys];

        ordersDataArray = [ordersDataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];

        for (NSString *key in ordersDataArray) {
            
            NSData *data = [ordersDic valueForKey:key];
            
            PizzaOrder *order = [NSKeyedUnarchiver unarchivedObjectOfClass:[PizzaOrder class] fromData:data error:nil];
            [ordersArray addObject:order];
        }
                
        [self addOrders:ordersArray];
    }
    return self;
}

- (void)createOrder:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings {
    
    [self createOrders:1 size:size toppings:toppings];
}

- (void)createOrders:(NSInteger)count size:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings {
    if (count < 1) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger lastOrderId = [defaults integerForKey:ORDER_ID];
    
    NSMutableArray *orders = [NSMutableArray new];
    for (NSInteger i = lastOrderId; i < lastOrderId + count; i++) {
        PizzaOrder *pizzaOrder = [[PizzaOrder alloc] initWithOrderId:i size:size topping:toppings];
        [orders addObject:pizzaOrder];
    }
    
    [self addOrders:orders];
    
    
    // Save order id in storage
    [defaults setInteger:lastOrderId + count forKey:ORDER_ID];
    
    
    // Save remaind orders in storage
    NSMutableDictionary *ordersDic  = [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:TOTAL_ORDER]];

    NSMutableArray *ordersDataArray = [NSMutableArray new];
    for (PizzaOrder *order in orders) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:order requiringSecureCoding:YES error:nil];
        [ordersDataArray addObject:data];
        [ordersDic setValue:data forKey:[@(order.orderId) stringValue]];

    }
    
    [defaults setObject:ordersDic forKey:TOTAL_ORDER];
    [defaults synchronize];
}



- (void)addOrders:(NSArray<PizzaOrder *> *)orders {
    for (PizzaOrder *order in orders) {
        Chef *chef = [self.chefs objectAtIndex: order.orderId % (self.chefs.count)];
        order.chefId = chef.chefId;
        [chef addOrder:order];
    }
}

- (void)openFactory:(BOOL)open {
    for (Chef *chef in self.chefs) {
        [chef startCooking:open];
    }
}

#pragma mark <ChefDelegate>
- (void)chef:(Chef *)chef didFinishedOrder:(PizzaOrder *)order {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chef:didFinishedOrder:)]) {
        [self.delegate chef:chef didFinishedOrder:order];
    }
    
    // Clear order in storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *ordersDic  = [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:TOTAL_ORDER]];

    [ordersDic removeObjectForKey:[@(order.orderId) stringValue]];
    
    [defaults setObject:ordersDic forKey:TOTAL_ORDER];
    [defaults synchronize];
    
}

- (void)chef:(Chef *)chef remaindOrdersNumber:(NSInteger)number {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chef:remaindOrdersNumber:)]) {
        [self.delegate chef:chef remaindOrdersNumber:number];
    }
}

@end
