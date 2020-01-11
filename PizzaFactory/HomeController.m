//
//  HomeController.m
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "HomeController.h"
#import "ChefStatusCell.h"
#import "ChefInfoCell.h"
#import "ChefOrdersCell.h"
#import "FactorySummaryCell.h"
#import "AddPizzaCell.h"
#import "FactoryStatusCell.h"

@interface HomeController ()<UICollectionViewDelegateFlowLayout, ChefOrderCellDelegate>

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return CGSizeMake((collectionView.frame.size.width - 1 ) /  7  - 1, collectionView.frame.size.height / 4 - 10);
            break;
        case 1:
            return CGSizeMake((collectionView.frame.size.width - 1 ) /  7  - 1, collectionView.frame.size.height / 8);
            break;
        case 2:
            return CGSizeMake((collectionView.frame.size.width - 1 ) /  7  - 1, collectionView.frame.size.height / 2 - 50);
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                return CGSizeMake((collectionView.frame.size.width - 1 ) /  7 * 3 - 1 , collectionView.frame.size.height / 8 + 30);

            } else {
                return CGSizeMake((collectionView.frame.size.width - 1 ) /  7 - 1, collectionView.frame.size.height / 8  + 30);
            }
        }
            break;
        default:
            return CGSizeZero;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 3) {
        return 5;
    } else {
        return 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ChefStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefStatusCell" forIndexPath:indexPath];
        [cell.headImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",indexPath.row]]];
        
        return cell;
    }else if (indexPath.section == 1) {
        ChefInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefInfoCell" forIndexPath:indexPath];
        return cell;
    
    }else if (indexPath.section == 2) {
        ChefOrdersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefOrdersCell" forIndexPath:indexPath];
        return cell;
    }else {
        if (indexPath.row == 0) {
            FactorySummaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FactorySummaryCell" forIndexPath:indexPath];
            return cell;
        } else if (indexPath.row == 1){
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpaceCell" forIndexPath:indexPath];
            return cell;
        } else if (indexPath.row == 2 ){
            AddPizzaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPizzaCell" forIndexPath:indexPath];
            [cell.addButton setTitle:@"Add 10 Pizza" forState:0];
            return cell;
        } else if (indexPath.row == 3){
            AddPizzaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPizzaCell" forIndexPath:indexPath];
            [cell.addButton setTitle:@"Add 100 Pizza" forState:0];
            return cell;
        } else {
            FactoryStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FactoryStatusCell" forIndexPath:indexPath];
            return cell;
        }
    }
}

@end
