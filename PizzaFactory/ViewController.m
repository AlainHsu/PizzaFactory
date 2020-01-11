//
//  ViewController.m
//  PizzaFactory
//
//  Created by Alain Hsu on 2020/1/11.
//  Copyright © 2020 Alain Hsu. All rights reserved.
//

#import "ViewController.h"
#import "PizzaFactory.h"

@interface ViewController ()<ChefDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *swc1;
@property (weak, nonatomic) IBOutlet UISwitch *swc2;
@property (weak, nonatomic) IBOutlet UISwitch *swc3;

@property (strong, nonatomic) NSArray *chefs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSMutableArray *chefs = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        Chef *chef = [[Chef alloc] initWithChefId:i cookingTime:i+1 remainOrders:nil];
        chef.delegate = self;
        [chefs addObject:chef];
    }
    self.chefs = chefs;
    
    PizzaFactory *factory = [[PizzaFactory alloc] initWithChefs:chefs];
    NSArray *orders  = [factory createOrders:100 size:PizzaSizeMedium toppings:[NSSet new]];
    [factory addOrders:orders];
}

- (void)chef:(Chef *)chef didFinishedOrder:(PizzaOrder *)pizza {
    NSLog(@"chef: %ld finished order: %ld", chef.chefId, pizza.orderId);
}

- (void)chef:(Chef *)chef remaindOrdersNumber:(NSInteger)number {
    NSLog(@"chef: %ld remainds order: %ld", chef.chefId, number);
}

- (IBAction)chef1:(UISwitch*)sender {
    [self.chefs[0] startCooking:sender.isOn];
}

- (IBAction)chef2:(UISwitch*)sender {
    [self.chefs[1] startCooking:sender.isOn];

}

- (IBAction)chef3:(UISwitch*)sender {
    [self.chefs[2] startCooking:sender.isOn];

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
