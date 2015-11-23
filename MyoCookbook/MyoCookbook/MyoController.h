//
//  MyoController.h
//  MyoCookbook
//
//  Created by Hongzu Li on 2015-11-20.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MyoKit/MyoKit.h>

@interface MyoController : NSObject
@property (assign,nonatomic) float Xrotation;
@property (assign,nonatomic) float UDrotation;
@property (assign,nonatomic) float LRrotation;
@property (assign,nonatomic) float originX;
@property (assign,nonatomic) int fistStatus;
@property (assign,nonatomic) int originSetup;
@property (strong,nonatomic) TLMPose *currentPose; // currentPose
@property (weak,nonatomic) UIViewController *currentView; 
@property (assign,nonatomic) int unlockStatus;
@property (assign,nonatomic) int connectionStatus;
@property (assign,nonatomic) int syncStatus;
@property (assign,nonatomic) NSTimeInterval fistTime;
@property (assign,nonatomic) float timeDelay;
@property (assign,nonatomic) int lrCalibration;
@property (assign,nonatomic) int udCalibration;
@property (assign,nonatomic) float threshValue;
- (UINavigationController*)connectMyo;
+ (MyoController*)sharedManager;
- (void)calibrateLR;
- (void)calibrateUD;
@end
