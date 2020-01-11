//
//  PizzaOrderFactory.h
//  GDC
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chef.h"

NS_ASSUME_NONNULL_BEGIN

@interface PizzaFactory : NSObject

@property (strong, nonatomic) NSMutableArray *chefs;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithChefs:(NSArray<Chef *> *)chefs;

- (PizzaOrder *)createOrder:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings;

- (NSArray <PizzaOrder *> *)createOrders:(NSInteger)count size:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings;


- (void)addOrders:(NSArray<PizzaOrder *> *)orders;

- (void)openFactory:(BOOL)open;

@end

NS_ASSUME_NONNULL_END
