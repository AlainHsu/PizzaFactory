//
//  Chef.h
//  GDC
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PizzaOrder.h"

@protocol ChefDelegate;

@interface Chef : NSObject

@property (assign, nonatomic) NSInteger chefId;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger cookingTime;

@property (strong, nonatomic) NSMutableArray<PizzaOrder *> * remainOrders;

@property (assign, nonatomic) BOOL isWorking;

@property (weak, nonatomic) id<ChefDelegate>delegate;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithChefId:(NSInteger)identifier cookingTime:(NSInteger)second  remainOrders:(NSArray<PizzaOrder *> *)orders;

- (void)addOrder:(PizzaOrder*)order;

- (void)updateOrder:(PizzaOrder*)order succeed:(void(^)(void))success fail:(void(^)(NSString *))failure;

- (void)cancelOrder:(PizzaOrder *)order succeed:(void(^)(void))success fail:(void(^)(NSString *))failure;

- (void)startCooking:(BOOL)fire;

@end

@protocol ChefDelegate <NSObject>

@optional

- (void)chef:(Chef *)chef remaindOrdersNumber:(NSInteger)number;

- (void)chef:(Chef *)chef didFinishedOrder:(PizzaOrder*)order;

- (void)chef:(Chef *)chef didCanceledOrder:(PizzaOrder*)order;

@end
