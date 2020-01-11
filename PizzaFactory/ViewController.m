//
//  ViewController.m
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "ViewController.h"
#import "PizzaFactory.h"

@interface ViewController ()<PizzaFactoryDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *swc1;
@property (weak, nonatomic) IBOutlet UISwitch *swc2;
@property (weak, nonatomic) IBOutlet UISwitch *swc3;

@property (strong, nonatomic) PizzaFactory *factory;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.factory = [[PizzaFactory alloc] initWithChefs:3];
    self.factory.delegate = self;
    [self.factory createOrders:100 size:PizzaSizeMedium toppings:[NSSet new]];
}

- (void)chef:(Chef *)chef remaindOrdersNumber:(NSInteger)number {
    NSLog(@"chef: %ld remaindOrdersNumber: %ld", chef.chefId, number);
}

- (IBAction)chef1:(UISwitch*)sender {
    [self.factory.chefs[0] startCooking:sender.isOn];
}

- (IBAction)chef2:(UISwitch*)sender {
    [self.factory.chefs[1] startCooking:sender.isOn];

}

- (IBAction)chef3:(UISwitch*)sender {
    [self.factory.chefs[2] startCooking:sender.isOn];

}
- (IBAction)allChefs:(UISwitch*)sender {
    [_swc1 setOn:sender.isOn];
    [_swc2 setOn:sender.isOn];
    [_swc3 setOn:sender.isOn];
    [self chef1:_swc1];
    [self chef2:_swc2];
    [self chef3:_swc3];
}

@end
