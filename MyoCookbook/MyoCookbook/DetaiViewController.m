//
//  DetaiViewController.m
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-20.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "DetaiViewController.h"
#import "MyoController.h"
@interface DetaiViewController ()

@end

@implementation DetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trackingLine = 2;
    self.textLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myoCookBookArmTwistCallback:)
                                                 name:@"MyoArmTwist"
                                               object:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTap:(id)sender {
    [[MyoController sharedManager] setCurrentView:self.fromView];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)settingButtonLabel:(id)sender {
    
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

- (IBAction)helpButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"showTutorial" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Gesture CallBack
-(void)spreadCallback{
}

-(void)fistCallback{
    if (self.trackingLine == 1) {
        [self backButtonTap:nil];
    }
}

-(void)upCallback{
    if (self.trackingLine == 1) {
        return;
    }
    CGFloat preSize = self.scrollTextField.font.pointSize;
    if (preSize > 35) {
        return;
    }
    UIFont *yourNewSameStyleFont = [self.scrollTextField
                                    .font fontWithSize:preSize+1];
    self.scrollTextField.font = yourNewSameStyleFont ;
}

-(void)downCallback{
    if (self.trackingLine == 1) {
        return;
    }
    CGFloat preSize = self.scrollTextField.font.pointSize;
    if (preSize < 20) {
        return;
    }
    UIFont *yourNewSameStyleFont = [self.scrollTextField
                                    .font fontWithSize:preSize-1];
    self.scrollTextField.font = yourNewSameStyleFont ;

}

-(void)leftCallback{
    if (self.trackingLine == 2) {
        self.backButton.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        self.trackingLine =1;
        self.textLabel.backgroundColor = [UIColor colorWithRed:92/225.0f green: 129/225.0f  blue:237/225.0f  alpha:1];

    }
}

-(void)rightCallback{
    if (self.trackingLine == 1) {
        self.textLabel.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
        self.trackingLine =2;
        self.backButton.backgroundColor = [UIColor colorWithRed:92/225.0f green: 129/225.0f  blue:237/225.0f  alpha:1];
        
    }
}

- (void)myoCookBookArmTwistCallback:(NSNotification *)notification {
    if (self.trackingLine == 1) {
        return;
    }
    UIScrollView* v = (UIScrollView*) self.scrollTextField ;
    CGRect rc = [self.scrollTextField bounds];
    rc = [self.scrollTextField convertRect:rc toView:v];
    rc.origin.x = 0 ;
    if (self.fistStatus == 0) {
        self.fistStatus = 1;
        self.preOffset = rc.origin.y;
    }
    NSNumber* number = [notification object];
    float diff = [number floatValue];
    //TODO Make the chaing based on the tending
    rc.origin.y = self.preOffset - diff*10;
    [self.scrollTextField scrollRectToVisible:rc animated:YES];
    NSLog(@"%f",diff);
}

- (void)myoCoookBookGestureCallback:(NSNotification *)notification {
    NSLog(@"Myo Gesture Callback hit");
    self.fistStatus = 0;
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
- (IBAction)downTest:(id)sender {
    [self downCallback];
}
- (IBAction)upTest:(id)sender {
    [self upCallback];
}

- (IBAction)fistTest:(id)sender {
}

- (IBAction)spredTest:(id)sender {
}

- (IBAction)leftTest:(id)sender {
    [self leftCallback];
}

- (IBAction)rightTest:(id)sender {
    [self rightCallback];
}
@end
