//
//  StepsViewController.m
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-20.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "CollectionViewController.h"
#import "MyoController.h"
#import "MyCollectionViewCell.h"
#import "DetaiViewController.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionView"];
    self.sourceArray = [[NSMutableArray alloc] initWithArray:@[@1,@2,@3,@4]];
    self.lastSelect = nil;
    // Do any additional setup after loading the view.
    self.trackingLine = 2;
    self.trackingStatus =1;
    self.collectionLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    
    if ([[MyoController sharedManager]connectionStatus] ==1 ) {
        if ([[MyoController sharedManager]syncStatus]==1) {
            if ([[MyoController sharedManager]unlockStatus]==1) {
                self.myoStatusLabel.backgroundColor = [UIColor greenColor];
                self.myoStatusLabel.text = @"UnLock";
            }else{
                self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
                self.myoStatusLabel.text = @"Locked";
            }
        }else{
            self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
            self.myoStatusLabel.text = @"UnSyn";
            
        }
    }else{
        self.myoStatusLabel.backgroundColor = [UIColor redColor];
        self.myoStatusLabel.text = @"UnCon";
    }
    [[MyoController sharedManager]setCurrentView:self];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myoCoookBookGestureCallback:)
                                                 name:@"MyoCookbookGesture"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionView" forIndexPath:indexPath];
    //图片名称
    NSString *imageToLoad = [NSString stringWithFormat:@"sample.png"];
    //加载图片
    cell.imageData.image = [UIImage imageNamed:imageToLoad];
    //设置label文字
    
    cell.labelData.text = [NSString stringWithFormat:@"Collection:%@",[self.sourceArray objectAtIndex:indexPath.row]];
    if (!self.lastSelect && indexPath.row == 0) {
//        cell.labelData.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    }
    return cell;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.sourceArray count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    NSLog(@"Choose: %ld",indexPath.row);
    MyCollectionViewCell *cell = (MyCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    UIColor* preColor = cell.labelData.backgroundColor;
//    cell.labelData.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
//    self.lastSelect.labelData.backgroundColor = preColor;
    self.lastSelect = cell;
    [self fistCallback];
}







- (IBAction)helpTap:(id)sender {
    [self performSegueWithIdentifier:@"showTutorial" sender:self];
}
- (IBAction)backButtonTap:(id)sender {
    [[MyoController sharedManager] setCurrentView:self.fromView];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)settingTap:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Setting"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Choose Myo Device"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button one"
                                                                    );
                                                              UINavigationController *controller =  [[MyoController sharedManager] connectMyo];
                                                              // Present the settings view controller modally.
                                                              [self presentViewController:controller animated:YES completion:nil];
                                                              
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Calibrate Myo"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button two");
                                                           }]; // 3
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancle"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button two");
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}
- (IBAction)startAllButton:(id)sender {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


#pragma mark - Gesture CallBack
-(void)spreadCallback{

}

-(void)fistCallback{
    if (self.trackingStatus == 1) {
        if (self.trackingLine == 1) {
            [self backButtonTap:nil];
        }else if (self.trackingLine == 2){
            
        }else if (self.trackingLine == 3){
            [self startAllButton:nil];
        }
    }
}

-(void)upCallback{
    if (self.trackingStatus ==1) {
        if (self.trackingLine == 1) {
            
        }else if (self.trackingLine ==2){
            self.collectionLabel.backgroundColor = [UIColor colorWithRed:92/225.0f green: 129/225.0f  blue:237/225.0f  alpha:1];
            self.backButton.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
            self.trackingLine = 1;
            
        }else if (self.trackingLine == 3){
            self.startAllButton.backgroundColor = [UIColor colorWithRed:111/225.0f green: 113/225.0f  blue:121/225.0f  alpha:1];
            self.collectionLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
            self.trackingLine = 2;
            
        }
    }
}

-(void)downCallback{
    if (self.trackingStatus ==1) {
        if (self.trackingLine == 1) {
            self.backButton.backgroundColor = [UIColor colorWithRed:170/225.0f green: 170/225.0f  blue:170/225.0f  alpha:1];
            self.collectionLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
            self.trackingLine = 2;

        }else if (self.trackingLine ==2){
            self.startAllButton.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];

            self.collectionLabel.backgroundColor = [UIColor colorWithRed:92/225.0f green: 129/225.0f  blue:237/225.0f  alpha:1];            self.trackingLine = 3;

        }else if (self.trackingLine == 3){
            
        }
    }

}

-(void)leftCallback{
    if (self.trackingStatus == 1) {
        if (self.trackingLine != 2) {
            return;
        }
        NSIndexPath* index;NSIndexPath *newIndexPath;
        index = [self.collectionView indexPathForCell:self.lastSelect];
        if (index.row > 0) {
            newIndexPath = [NSIndexPath indexPathForRow:index.row-1 inSection:0];
            [self.collectionView selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            
            [self collectionView:self.collectionView didSelectItemAtIndexPath:newIndexPath];
        }
    }else if (self.trackingStatus == 2){
        
    }
    
}

-(void)rightCallback{
    if (self.trackingStatus == 1) {
        if (self.trackingLine != 2) {
            return;
        }
        NSIndexPath* index;NSIndexPath *newIndexPath;
        index = [self.collectionView indexPathForCell:self.lastSelect];
        if (index.row < [self.sourceArray count]-1) {
            newIndexPath = [NSIndexPath indexPathForRow:index.row+1 inSection:0];
            [self.collectionView selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            
            [self collectionView:self.collectionView didSelectItemAtIndexPath:newIndexPath];
        }
    }else if (self.trackingStatus == 2){
        
    }
}

- (void)myoCoookBookGestureCallback:(NSNotification *)notification {
    NSLog(@"Myo Gesture Callback hit");
    NSString* notif = @"";
    NSString* gestureName = [notification object];
    if ([gestureName isEqual:@"MyoConnect"]) {
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"UnSyn";
        notif = @"Myo Connected";
        NSLog(@"Myo Connected");
    }else if([gestureName isEqual:@"MyoUnconnect"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"UnCon";
        notif = @"Myo UnConnect";
        NSLog(@"Myo UnConnect");
    }else if([gestureName isEqual:@"MyoSync"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"Locked";
        notif = @"Myo MyoSync";
        NSLog(@"Myo Syned");
    }else if([gestureName isEqual:@"MyoUnsync"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"UnSyn";
        NSLog(@"Myo UnSyned");
        notif = @"Myo MyoUnsync";
        
    }else if([gestureName isEqual:@"MyoUnlock"]){
        self.myoStatusLabel.backgroundColor = [UIColor greenColor];
        self.myoStatusLabel.text = @"UnLock";
        NSLog(@"Myo UnLock");
        notif = @"Myo UnLcoked";
    }else if([gestureName isEqual:@"MyoLock"]){
        self.myoStatusLabel.backgroundColor = [UIColor orangeColor];
        self.myoStatusLabel.text = @"Locked";
        NSLog(@"Myo Locked");
        notif = @"Myo Locked";
        
    }else if([gestureName isEqual:@"MyoGestureFist"]){
        if (![[[MyoController sharedManager]currentView]isEqual:self]) return;

        [self fistCallback];
        NSLog(@"Myo fist");
        notif = @"Fist Gesture";
        
    }else if([gestureName isEqual:@"MyoGestureWaveDown"]){
        if (![[[MyoController sharedManager]currentView]isEqual:self]) return;
        
        if ([[[MyoController sharedManager]currentView]isEqual:self]) {
            [self downCallback];
            NSLog(@"Myo down");
            notif = @"Wave down Gesture";
        }
        
        
    }else if([gestureName isEqual:@"MyoGestureWaveLeft"]){
        if (![[[MyoController sharedManager]currentView]isEqual:self]) return;
        
        [self leftCallback];
        notif = @"Wave left Gesture";
        
    }else if([gestureName isEqual:@"MyoGestureWaveUp"]){
        if (![[[MyoController sharedManager]currentView]isEqual:self]) return;
        
        [self upCallback];
        notif = @"Wave up Gesture";
        
    }else if([gestureName isEqual:@"MyoGestureWaveRight"]){
        if (![[[MyoController sharedManager]currentView]isEqual:self]) return;
        
        [self rightCallback];
        notif = @"Wave right Gesture";
        
    }else if([gestureName isEqual:@"MyoGestureFingerSpread"]){
        if (![[[MyoController sharedManager]currentView]isEqual:self]) return;
        
        [self spreadCallback];
        notif = @"Finger Spread Gesture";
        
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        // Get destination view
        DetaiViewController *vc = [segue destinationViewController];
        
        [vc setFromView:self];
    }else if ([[segue identifier] isEqualToString:@"showCollection"]){
        
    }

}

@end
