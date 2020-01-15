//
//  PizzaOrder.h
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PizzaSizeSmall,
    PizzaSizeMedium,
    PizzaSizeLarge,
} PizzaSize;


@interface PizzaOrder : NSObject <NSSecureCoding>

@property (assign, nonatomic, readonly) NSInteger orderId;

@property (assign, nonatomic) NSInteger chefId;

@property (assign, nonatomic) NSInteger size;

@property (strong, nonatomic) NSSet * toppings;


+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithOrderId:(NSInteger)identifier size:(PizzaSize)size topping:(NSSet<NSString *> *)toppings;

@end

NS_ASSUME_NONNULL_END
