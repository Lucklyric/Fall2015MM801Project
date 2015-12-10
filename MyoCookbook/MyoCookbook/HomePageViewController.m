//
//  HomePageViewController.m
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-18.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "HomePageViewController.h"
#import "MyCollectionViewCell.h"
#import "MyoController.h"
#import "JHNotificationManager.h"
#import "DetaiViewController.h"
#import "CollectionViewController.h"
#import "CalibrateViewController.h"
@interface HomePageViewController ()

@end

@implementation HomePageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.recentCollection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionView"];
    [self.featureCollection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionView"];
    self.cursorLine = 1;
    self.trackingStatus = 1;
    self.lastFeatureSelected = nil;
    self.lastRecentSelected = nil;
    self.featureCollection.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myoCoookBookGestureCallback:)
                                                 name:@"MyoCookbookGesture"
                                               object:nil];

    [[MyoController sharedManager] setCurrentView:self];
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
    if (collectionView == self.featureCollection) {
        cell.labelData.text = [NSString stringWithFormat:@"Feature%ld",(long)indexPath.row];
        if (indexPath.row == 0 && !self.lastFeatureSelected) {
            cell.labelData.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
            self.lastFeatureSelected = cell;
        }
    }else{
        cell.labelData.text = [NSString stringWithFormat:@"Recent%ld",(long)indexPath.row];
        if (indexPath.row == 0 && !self.lastRecentSelected) {
            cell.labelData.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
            self.lastRecentSelected = cell;
        }
    }
    return cell;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
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
    cell.labelData.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    if (collectionView == self.featureCollection) {
        self.cursorLine = 1;
    }else{
        self.cursorLine = 2;
    }
    
    if (self.cursorLine == 1) {
        self.recentCollection.backgroundColor = [UIColor colorWithRed:144/225.0f green: 202/225.0f  blue:227/225.0f  alpha:1];
        self.featureCollection.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        
    }else{
        self.featureCollection.backgroundColor = [UIColor colorWithRed:144/225.0f green: 202/225.0f  blue:227/225.0f  alpha:1];
        self.recentCollection.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    }
    
    if (self.cursorLine == 1) {
        if (self.lastFeatureSelected) {
            self.lastFeatureSelected.labelData.backgroundColor = preColor;
        }
        self.lastFeatureSelected = cell;
    }else if (self.cursorLine == 2){
        if (self.lastRecentSelected) {
            self.lastRecentSelected.labelData.backgroundColor = preColor;
        }
        self.lastRecentSelected = cell;
    }
}

- (IBAction)collection:(id)sender {
    [self performSegueWithIdentifier:@"showCollection" sender:self];
    
}


- (IBAction)settingButtonTap:(id)sender {
    
    
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
                                                               
                                                               [self performSegueWithIdentifier:@"showCalibrate" sender:self];

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
- (IBAction)searchButtonTap:(id)sender {
    if ([self.searchBarField.text  isEqual: @""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"PlaseEnterWords"
                                                           delegate:self
                                                  cancelButtonTitle:@"Retry"
                                                  otherButtonTitles:nil];
        [alertView setTag:1];
        [alertView show];

    }else if([self.searchBarField.text  isEqual: @"Feature"]){
        
    }else if([self.searchBarField.text  isEqual: @"Recent"]){
        
    }
}




 #pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"homeToDetail"]) {
        
        // Get destination view
        DetaiViewController *vc = [segue destinationViewController];
        
        [vc setFromView:self];
    }else if ([[segue identifier] isEqualToString:@"showCollection"]){
        CollectionViewController *vc = [segue destinationViewController];
        
        [vc setFromView:self];

    }else if ([[segue identifier] isEqualToString:@"showCalibrate"]){
        CalibrateViewController *vc = [segue destinationViewController];
        
        [vc setFromView:self];
        
    }

}




-(void)menuShow:(BOOL) ifHidden{
    if (ifHidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.startButton.alpha = 0;
            self.startLabel.alpha = 0;
            self.cancleButton.alpha = 0;
            self.cancleLabel.alpha = 0;
            self.saveButton.alpha = 0;
            self.saveForLaterLabel.alpha = 0;
            self.menuImage.alpha = 0;
        } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
            self.startButton.hidden = finished;
            self.startLabel.hidden = finished;
            self.cancleButton.hidden = finished;
            self.cancleLabel.hidden = finished;
            self.saveButton.hidden = finished;
            self.saveForLaterLabel.hidden = finished;
            self.menuImage.hidden = finished;
            self.startLabel.backgroundColor = [UIColor clearColor];
            self.saveForLaterLabel.backgroundColor = [UIColor clearColor];
            self.cancleLabel.backgroundColor = [UIColor clearColor];

            
            //if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
        }];
    }else{
        self.startButton.alpha = 0;
        self.startLabel.alpha = 0;
        self.cancleButton.alpha = 0;
        self.cancleLabel.alpha = 0;
        self.saveButton.alpha = 0;
        self.saveForLaterLabel.alpha = 0;
        self.menuImage.alpha = 0;

        self.startButton.hidden = NO;
        self.startLabel.hidden = NO;
        self.cancleButton.hidden = NO;
        self.cancleLabel.hidden = NO;
        self.saveButton.hidden = NO;
        self.saveForLaterLabel.hidden = NO;
        self.menuImage.hidden = NO;

        [UIView animateWithDuration:0.3 animations:^{
            self.startButton.alpha = 1;
            self.startLabel.alpha = 1;
            self.cancleButton.alpha = 2;
            self.cancleLabel.alpha = 1;
            self.saveButton.alpha = 2;
            self.saveForLaterLabel.alpha = 1;
            self.menuImage.alpha = 1;
        }];
    }
//    [self.startButton setHidden:ifHidden];
//    [self.startLabel setHidden:ifHidden];
//    [self.cancleButton setHidden:ifHidden];
//    [self.cancleLabel setHidden:ifHidden];
//    [self.saveButton setHidden:ifHidden];
//    [self.saveForLaterLabel setHidden:ifHidden];
}

- (IBAction)helpButton:(id)sender {
    [self performSegueWithIdentifier:@"showTutorial" sender:self];
}

#pragma mark - Gesture CallBack
-(void)spreadCallback{
    if (self.trackingStatus == 2) {
        self.cancleLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        [self menuShow:YES];
        self.trackingStatus = 1;
    }
}

-(void)fistCallback{
    if (self.trackingStatus == 1) {
        self.trackingStatus = 2;
        [self menuShow:NO];
    }else if (self.trackingStatus == 3){
        [self collection:nil];
    }
    //[self performSegueWithIdentifier:@"homeToDetail" sender:self];
}

-(void)upCallback{
    if (self.trackingStatus == 1) {
        if (self.cursorLine == 2) {
            self.cursorLine =1;
            self.recentCollection.backgroundColor = [UIColor colorWithRed:144/225.0f green: 202/225.0f  blue:227/225.0f  alpha:1];
            self.featureCollection.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        }
    }else if (self.trackingStatus == 3){
        //self.featureCollection.backgroundColor = [UIColor colorWithRed:144/225.0f green: 202/225.0f  blue:227/225.0f  alpha:1];
        self.recentCollection.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        self.collectionButton.backgroundColor = [UIColor colorWithRed:111/225.0f green: 113/225.0f  blue:121/225.0f  alpha:1];
        self.trackingStatus = 1;
    }
}

-(void)downCallback{
    if (self.trackingStatus == 1){
        if (self.cursorLine == 1){
            self.cursorLine =2;
            self.featureCollection.backgroundColor = [UIColor colorWithRed:144/225.0f green: 202/225.0f  blue:227/225.0f  alpha:1];
            self.recentCollection.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        }else if(self.cursorLine == 2){
            self.trackingStatus = 3;
            self.recentCollection.backgroundColor = [UIColor colorWithRed:144/225.0f green: 202/225.0f  blue:227/225.0f  alpha:1];
            self.collectionButton.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        }
    }else if(self.trackingStatus == 2){
        
    }
}
-(void)leftCallback{
    if (self.trackingStatus == 1) {
        NSIndexPath* index;NSIndexPath *newIndexPath;
        if (self.cursorLine == 1) {
            index = [self.featureCollection indexPathForCell:self.lastFeatureSelected];
        }else{
            index = [self.recentCollection indexPathForCell:self.lastRecentSelected];
        }
        if (index.row > 0) {
            newIndexPath = [NSIndexPath indexPathForRow:index.row-1 inSection:0];
            if (self.cursorLine == 1) {
                NSLog(@"New:%ld",newIndexPath.row);
                [self.featureCollection selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                
                [self collectionView:self.featureCollection didSelectItemAtIndexPath:newIndexPath];
            }else{
                
                [self.recentCollection selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                [self collectionView:self.recentCollection didSelectItemAtIndexPath:newIndexPath];
            }
        }
        
    }else if(self.trackingStatus == 2){
        self.saveForLaterLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        [self menuShow:YES];
        self.trackingStatus = 1;
    }
}

-(void)rightCallback{
    if (self.trackingStatus == 1) {
        NSIndexPath* index;NSIndexPath *newIndexPath;
        if (self.cursorLine == 1) {
            index = [self.featureCollection indexPathForCell:self.lastFeatureSelected];
        }else{
            index = [self.recentCollection indexPathForCell:self.lastRecentSelected];
        }
        NSLog(@"PreINdex:%ld",index.row);
        if (index.row < 4) {
            newIndexPath = [NSIndexPath indexPathForRow:index.row+1 inSection:0];
            if (self.cursorLine == 1) {
                NSLog(@"New:%ld",newIndexPath.row);
                [self.featureCollection selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                
                [self collectionView:self.featureCollection didSelectItemAtIndexPath:newIndexPath];
            }else{
                
                [self.recentCollection selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                [self collectionView:self.recentCollection didSelectItemAtIndexPath:newIndexPath];
            }
        }
        
    }else if (self.trackingStatus == 2){
        self.startLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        [self menuShow:YES];
        self.trackingStatus = 1;
        [self performSegueWithIdentifier:@"homeToDetail" sender:self];
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
//    if (![notif isEqual:@""]) {
//        [JHNotificationManager notificationWithMessage:notif direction:JHNotificationAnimationDirectionSlideInLeft];
//    }

    
}

- (IBAction)startButtonTap:(id)sender {
    self.startLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    [self menuShow:YES];
    self.trackingStatus = 1;
    [self performSegueWithIdentifier:@"homeToDetail" sender:self];
}
- (IBAction)cancleButtonTap:(id)sender {
    self.cancleLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    [self menuShow:YES];
    self.trackingStatus = 1;

}
- (IBAction)saveButtonTap:(id)sender {
    self.saveForLaterLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    [self menuShow:YES];
    self.trackingStatus = 1;
}
#pragma mark - Test Gesture Part
- (IBAction)selectGesture:(id)sender {
    [self fistCallback];
}

- (IBAction)upGesture:(id)sender {
    [self upCallback];
}

- (IBAction)downGesture:(id)sender {
    [self downCallback];
}

- (IBAction)leftGesture:(id)sender {
    [self leftCallback];
}

- (IBAction)rightGesture:(id)sender {
    [self rightCallback];
}
- (IBAction)spreadGesture:(id)sender {
    [self spreadCallback];
}



@end
