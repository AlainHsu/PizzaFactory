//
//  AddPizzaCell.h
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//


#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const TOPPINGS_ROAST_BEEF;
FOUNDATION_EXPORT NSString *const TOPPINGS_BELL_PEPPERS;
FOUNDATION_EXPORT NSString *const TOPPINGS_MUSHROOMS;
FOUNDATION_EXPORT NSString *const TOPPINGS_ONIONS;
FOUNDATION_EXPORT NSString *const TOPPINGS_TOMATOES;
FOUNDATION_EXPORT NSString *const TOPPINGS__MARINARA;

NS_ASSUME_NONNULL_BEGIN

@interface AddPizzaCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

NS_ASSUME_NONNULL_END
