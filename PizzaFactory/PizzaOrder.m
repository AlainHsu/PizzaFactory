//
//  PizzaOrder.m
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "PizzaOrder.h"

@implementation PizzaOrder

- (instancetype)initWithOrderId:(NSInteger)identifier size:(PizzaSize)size topping:(NSSet<NSString *> *)toppings {
    if (self = [super init]) {
        self.orderId = identifier;
        self.size = size;
        self.toppings = toppings;
    }
    
    return self;
}


@end
