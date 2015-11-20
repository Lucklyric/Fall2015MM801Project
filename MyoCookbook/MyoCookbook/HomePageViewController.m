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
- (IBAction)settingButtonTap:(id)sender {
    UINavigationController *controller =  [[MyoController sharedManager] connectMyo];
    // Present the settings view controller modally.
    [self presentViewController:controller animated:YES completion:nil];

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





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



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


#pragma mark - Gesture CallBack
-(void)spreadCallback{
    if (self.trackingStatus == 2) {
        [self menuShow:YES];
        self.trackingStatus = 1;
    }
}

-(void)fistCallback{
    if (self.trackingStatus == 1) {
        self.trackingStatus = 2;
        self.cancleLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        [self menuShow:NO];
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
    }
    
}

-(void)downCallback{
    if (self.trackingStatus == 1){
        if (self.cursorLine == 1){
            self.cursorLine =2;
            self.featureCollection.backgroundColor = [UIColor colorWithRed:144/225.0f green: 202/225.0f  blue:227/225.0f  alpha:1];
            self.recentCollection.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
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

    NSString* gestureName = [notification object];
    if ([gestureName isEqual:@"MyoConnect"]) {
        self.myoStatusLabel.backgroundColor = [UIColor greenColor];
        NSLog(@"Myo Connected");
    }
    
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



@end
