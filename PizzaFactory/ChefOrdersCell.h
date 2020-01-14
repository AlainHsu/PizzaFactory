//
//  ChefOrdersCell.h
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PizzaOrder.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ChefOrderCellDelegate <NSObject>

@optional
-(void)didClickEditOrder:(PizzaOrder *)order;

-(void)didClickDelegateOrder:(PizzaOrder *)order;

@end

@interface ChefOrdersCell : UICollectionViewCell

@property(weak, nonatomic) id<ChefOrderCellDelegate>delegate;

-(void)reloadOrders:(NSArray<PizzaOrder *> *)dataSource;

-(void)removeOrder:(PizzaOrder *)order;

@end

NS_ASSUME_NONNULL_END
