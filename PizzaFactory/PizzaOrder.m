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
        _orderId = identifier;
        self.size = size;
        self.toppings = toppings;
    }
    
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id) initWithCoder: (NSCoder *)coder  {
    if (self = [super init]) {
        _orderId = [coder decodeIntegerForKey:@"order_id"];

        self.size = [coder decodeIntegerForKey:@"order_size"];

        self.toppings = [coder decodeObjectOfClass:[NSSet class] forKey:@"order_toppings"];

    }

    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
    
    [coder encodeInteger:self.orderId forKey:@"order_id"];

    [coder encodeInteger:self.size forKey:@"order_size"];

    [coder encodeObject:self.toppings forKey:@"order_toppings"];

}

// Precenting property modification via KVC
+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

@end
