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
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    switch (indexPath.section) {
        case 0:
            return CGSizeMake(width  / 7 , height / 4 - 10);
            break;
        case 1:
            return CGSizeMake(width / 7 ,  height / 8 + 10);
            break;
        case 2:
            return CGSizeMake(width / 7 , height / 2 - 50);
            break;
        case 3:
        {
            // TODO: Cell width is not correct, may cause by percision
            if (indexPath.row == 0) {
                return CGSizeMake(width / 7 * 3 + 0.39, height / 8 + 30);

            } else {
                return CGSizeMake(width / 7 + 0.9642 , height / 8  + 30);
            }
            
        }
            break;
        default:
            return CGSizeZero;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return -1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return -1;
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
    
    UICollectionViewCell *collectionViewCell;
    if (indexPath.section == 0) {
        ChefStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefStatusCell" forIndexPath:indexPath];
        [cell.headImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",indexPath.row]]];
        
        collectionViewCell =  cell;
    }else if (indexPath.section == 1) {
        ChefInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefInfoCell" forIndexPath:indexPath];
        collectionViewCell =  cell;

    }else if (indexPath.section == 2) {
        ChefOrdersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefOrdersCell" forIndexPath:indexPath];
        collectionViewCell =  cell;
    }else {
        if (indexPath.row == 0) {
            FactorySummaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FactorySummaryCell" forIndexPath:indexPath];
            collectionViewCell =  cell;
        } else if (indexPath.row == 1){
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpaceCell" forIndexPath:indexPath];
            collectionViewCell =  cell;
        } else if (indexPath.row == 2 ){
            AddPizzaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPizzaCell" forIndexPath:indexPath];
            [cell.addButton setTitle:@"Add 10 Pizza" forState:0];
            collectionViewCell =  cell;
        } else if (indexPath.row == 3){
            AddPizzaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPizzaCell" forIndexPath:indexPath];
            [cell.addButton setTitle:@"Add 100 Pizza" forState:0];
            collectionViewCell =  cell;
        } else {
            FactoryStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FactoryStatusCell" forIndexPath:indexPath];
            collectionViewCell =  cell;
        }
    }
    
    
    collectionViewCell.clipsToBounds = YES;

    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor lightGrayColor].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(1, 0, 1, collectionViewCell.frame.size.height);

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(0, 1, collectionViewCell.frame.size.width, 1);

    [collectionViewCell.layer addSublayer:rightBorder];
    [collectionViewCell.layer addSublayer:bottomBorder];

    
    return collectionViewCell;
}

@end
