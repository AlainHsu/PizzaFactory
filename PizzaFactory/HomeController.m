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

#import "PizzaFactory.h"

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define IS_FIRST_LAUNCH @"is_first_launch"

@interface HomeController ()<UICollectionViewDelegateFlowLayout, ChefOrderCellDelegate, PizzaFactoryDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceBrowserDelegate, MCAdvertiserAssistantDelegate>

@property (strong, nonatomic) PizzaFactory *factory;
@property (strong, nonatomic) NSSet *defaultToppings;

@property (strong, nonatomic) MCPeerID * peerID;
@property (strong, nonatomic) MCSession * session;
@property (strong, nonatomic) MCAdvertiserAssistant * advertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser * brower;
@property (strong, nonatomic) MCBrowserViewController * browserViewController;
@property (nonatomic,strong)NSMutableArray * sessionArray;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
    
    self.defaultToppings = [[NSSet alloc] initWithObjects:TOPPINGS_ROAST_BEEF,TOPPINGS_BELL_PEPPERS,TOPPINGS_MUSHROOMS,TOPPINGS_ONIONS,TOPPINGS_TOMATOES,TOPPINGS_MARINARA, nil];
    
    self.factory = [[PizzaFactory alloc] initWithChefs:7];
    self.factory.delegate = self;
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:IS_FIRST_LAUNCH] != 1) {
                
        [self.factory createOrders:1000 size:PizzaSizeMedium toppings:self.defaultToppings];
        [defaults setInteger:1 forKey:IS_FIRST_LAUNCH];
    }
    
//    [self.factory openFactory:YES];
    
    [self createMC];
}

- (void)createMC{
    
    _sessionArray = [NSMutableArray new];

    NSString * name = [UIDevice currentDevice].name;
    _peerID = [[MCPeerID alloc]initWithDisplayName:name];
    
    _session = [[MCSession alloc]initWithPeer:_peerID];
    _session.delegate = self;
    
    _advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:@"pizza-factory" discoveryInfo:nil session:_session];
    _advertiser.delegate = self;
    [_advertiser start];
    
    _brower = [[MCNearbyServiceBrowser alloc]initWithPeer:_peerID serviceType:@"pizza-factory"];
    _brower.delegate = self;
    [_brower startBrowsingForPeers];
}

#pragma mark - UI Actions

- (void)didChangedChefStatus:(UISwitch *)sender {
    UIView *v = [sender superview];
    UICollectionViewCell *cell = (UICollectionViewCell *)[v superview];
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    
    [self.factory.chefs[indexpath.row] startCooking:sender.isOn];
    
    BOOL chefsStatusSyncUp = YES;
    for (Chef *chef in self.factory.chefs) {
        if (chef.isWorking != sender.isOn) {
            chefsStatusSyncUp = NO;
        }
    }
    if (chefsStatusSyncUp) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:3]];
        [((FactoryStatusCell*)cell).factoryStatusButton setOn:sender.isOn];
    }
}

- (void)didAddPizzaButtonTapped:(id)sender {
    
    UIView *v = [sender superview];
    UICollectionViewCell *cell = (UICollectionViewCell *)[v superview];
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    
    NSInteger count = indexpath.row == 2 ? 10 : 100;
    
    [self.factory createOrders:count size:PizzaSizeMedium toppings:self.defaultToppings];
    
    for (Chef *chef in self.factory.chefs) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:chef.chefId inSection:2]];
        [((ChefOrdersCell*)cell) reloadOrders:chef.remainOrders];
    }
}

- (void)didChangedFactoryStatus:(UISwitch *)sender {
    
    for (Chef *chef in self.factory.chefs) {
        if (chef.isWorking != sender.isOn) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:chef.chefId inSection:0]];
            [((ChefStatusCell*)cell).statusSwitch setOn:sender.isOn];
            
        }
    }
    
    [self.factory openFactory:sender.isOn];
    
}

#pragma mark <ChefOrderCellDelegate>

-(void)didClickEditOrder:(PizzaOrder *)order {
    NSLog(@"edit %ld",order.orderId);
}

-(void)didClickDelegateOrder:(PizzaOrder *)order {
        
    if (self.session.connectedPeers.count == 0) {
                
        UIAlertController *delegateAlert = [UIAlertController alertControllerWithTitle:nil message:@"Discover other Pizza factory?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [delegateAlert dismissViewControllerAnimated:YES completion:nil];
            
            if (self->_browserViewController == nil) {
                self->_browserViewController = [[MCBrowserViewController alloc]initWithServiceType:@"pizza-factory" session:self->_session];
                self->_browserViewController.delegate = self;

                [self presentViewController:self->_browserViewController animated:YES completion:nil];
            }

        }];
        [delegateAlert addAction:cancel];
        [delegateAlert addAction:ok];
        [self presentViewController:delegateAlert animated:YES completion:nil];

    }
}

#pragma mark - <PizzaFactoryDelegate>

- (void)chef:(Chef *)chef didFinishedOrder:(PizzaOrder *)order {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:order.chefId inSection:2]];
        [((ChefOrdersCell*)cell) removeOrder:order];
    });
}

-(void)chef:(Chef *)chef remaindOrdersNumber:(NSInteger)number {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:chef.chefId inSection:1], [NSIndexPath indexPathForRow:0 inSection:3]]];
    });
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
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
            if (indexPath.row == 0) {
                return CGSizeMake(width / 7 * 3, height / 8 + 30);

            } else {
                return CGSizeMake(width / 7 , height / 8  + 30);
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
        [cell.statusSwitch addTarget:self action:@selector(didChangedChefStatus:) forControlEvents:UIControlEventValueChanged];
        
        collectionViewCell =  cell;
    }else if (indexPath.section == 1) {
        ChefInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefInfoCell" forIndexPath:indexPath];
        cell.nameLabel.text = self.factory.chefs[indexPath.row].name;
        cell.remainPizzaLabel.text = [NSString stringWithFormat:@"Remaining Pizza: %ld",self.factory.chefs[indexPath.row].remainOrders.count];
        cell.cookingTimeLabel.text = [NSString stringWithFormat:@"Speed: %ld seconds per pizza",self.factory.chefs[indexPath.row].cookingTime];
        collectionViewCell =  cell;

    }else if (indexPath.section == 2) {
        ChefOrdersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChefOrdersCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell reloadOrders:self.factory.chefs[indexPath.row].remainOrders];
        collectionViewCell =  cell;
    }else {
        if (indexPath.row == 0) {
            FactorySummaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FactorySummaryCell" forIndexPath:indexPath];
            cell.chef0Label.text = [NSString stringWithFormat:@"Pizza chef 0: %ld", self.factory.chefs[0].remainOrders.count];
            cell.chef1Label.text = [NSString stringWithFormat:@"Pizza chef 1: %ld", self.factory.chefs[1].remainOrders.count];
            cell.chef2Label.text = [NSString stringWithFormat:@"Pizza chef 2: %ld", self.factory.chefs[2].remainOrders.count];
            cell.chef3Label.text = [NSString stringWithFormat:@"Pizza chef 3: %ld", self.factory.chefs[3].remainOrders.count];
            cell.chef4Label.text = [NSString stringWithFormat:@"Pizza chef 4: %ld", self.factory.chefs[4].remainOrders.count];
            cell.chef5Label.text = [NSString stringWithFormat:@"Pizza chef 5: %ld", self.factory.chefs[5].remainOrders.count];
            cell.chef6Label.text = [NSString stringWithFormat:@"Pizza chef 6: %ld", self.factory.chefs[6].remainOrders.count];

            collectionViewCell =  cell;
        } else if (indexPath.row == 1){
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpaceCell" forIndexPath:indexPath];
            collectionViewCell =  cell;
        } else if (indexPath.row == 2 ){
            AddPizzaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPizzaCell" forIndexPath:indexPath];
            [cell.addButton setTitle:@"Add 10 Pizza" forState:0];
            [cell.addButton addTarget:self action:@selector(didAddPizzaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            collectionViewCell =  cell;
        } else if (indexPath.row == 3){
            AddPizzaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPizzaCell" forIndexPath:indexPath];
            [cell.addButton setTitle:@"Add 100 Pizza" forState:0];
            [cell.addButton addTarget:self action:@selector(didAddPizzaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

            collectionViewCell =  cell;
        } else {
            FactoryStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FactoryStatusCell" forIndexPath:indexPath];
            [cell.factoryStatusButton addTarget:self action:@selector(didChangedFactoryStatus:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - <MCNearbyServiceBrowserDelegate>

- (void)advertiserAssistantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
    NSLog(@"advertiserAssistantWillPresentInvitation");
}

// An invitation was dismissed from screen.
- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
    NSLog(@"advertiserAssistantDidDismissInvitation");
}


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    NSLog(@"found peer: %@", peerID.displayName);
    if (_browserViewController == nil) {
        _browserViewController = [[MCBrowserViewController alloc]initWithServiceType:@"pizza-factory" session:_session];
        _browserViewController.delegate = self;

        [self presentViewController:_browserViewController animated:YES completion:nil];
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
    NSLog(@"lost peer: %@",peerID.displayName);
}


#pragma mark <MCBrowserViewControllerDelegate>

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    _browserViewController = nil;
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    _browserViewController = nil;
}

#pragma mark <MCSessionDelegate>

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{

    if (state == MCSessionStateConnected) {
        
        if (![_sessionArray containsObject:session]) {

            [_sessionArray addObject:session];
        }
        
        NSLog(@"connectedPeers %@", _session.connectedPeers);
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSString * message = [NSString stringWithFormat:@"%@:%@",peerID.displayName,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: data handling
    });
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{

}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
