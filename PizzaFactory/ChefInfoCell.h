//
//  ChefInfoCell.h
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChefInfoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainPizzaLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookingTimeLabel;

@end

NS_ASSUME_NONNULL_END
