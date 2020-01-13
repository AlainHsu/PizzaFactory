//
//  FactorySummaryCell.h
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FactorySummaryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *chef0Label;
@property (weak, nonatomic) IBOutlet UILabel *chef1Label;
@property (weak, nonatomic) IBOutlet UILabel *chef2Label;
@property (weak, nonatomic) IBOutlet UILabel *chef3Label;
@property (weak, nonatomic) IBOutlet UILabel *chef4Label;
@property (weak, nonatomic) IBOutlet UILabel *chef5Label;
@property (weak, nonatomic) IBOutlet UILabel *chef6Label;

@end

NS_ASSUME_NONNULL_END
