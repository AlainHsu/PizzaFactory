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

@protocol PizzaFactoryDelegate <ChefDelegate>

@end

@interface PizzaFactory : NSObject

@property (strong, nonatomic) NSMutableArray<Chef *> *chefs;

@property (weak, nonatomic) id<PizzaFactoryDelegate>delegate;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithChefs:(NSInteger)number;

- (void)createOrder:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings;

- (void)createOrders:(NSInteger)count size:(PizzaSize)size toppings:(NSSet<NSString *> *)toppings;

- (void)updateOrder:(PizzaOrder*)order succeed:(void(^)(void))success fail:(void(^)(NSString *))failure;

- (void)cancelOrder:(PizzaOrder *)order succeed:(void(^)(void))success fail:(void(^)(NSString *))failure;

- (void)openFactory:(BOOL)open;

@end

NS_ASSUME_NONNULL_END
