//
//  ChefOrdersCell.m
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "ChefOrdersCell.h"
#import "PizzaOrderCell.h"

@interface ChefOrdersCell ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<PizzaOrder *> *dataSource;
@property (strong, nonatomic) UIColor *mainColor;
@property (strong, nonatomic) UIColor *secondaryColor;

@end

@implementation ChefOrdersCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat red = (random() % 256) / 255.0;
    CGFloat green = (random() % 256) / 255.0;
    CGFloat blue = (random() % 256) / 255.0;

    _mainColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    _secondaryColor = [_mainColor colorWithAlphaComponent:0.1];

    _dataSource = [NSMutableArray new];
}

-(void)reloadOrders:(NSArray<PizzaOrder *> *)dataSource {
    
}

-(void)editButtonPressed:(id)sender{
    UIView *v = [sender superview];
    UITableViewCell *cell = (UITableViewCell *)[v superview];
      
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEditButton:)]) {
        [self.delegate didClickEditButton:indexpath.row];
    }
}

#pragma mark <UITableViewDataSource>

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PizzaOrder *order = _dataSource[indexPath.row];
    PizzaOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PizzaOrderCell"];
    cell.orderIdLabel.text = [NSString stringWithFormat:@"PIZZA_%04ld",(long)order.orderId];
    cell.orderIdLabel.textColor = _mainColor;
    cell.orderIdLabel.backgroundColor = _secondaryColor;
    [cell.editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
