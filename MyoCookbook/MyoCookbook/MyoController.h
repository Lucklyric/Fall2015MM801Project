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
@property (assign,nonatomic) float originX;
@property (assign,nonatomic) int fistStatus;
@property (assign,nonatomic) int originSetup;
@property (strong,nonatomic) TLMPose *currentPose; // currentPose
@property (weak,nonatomic) UIViewController *currentView; 

- (UINavigationController*)connectMyo;
+ (MyoController*)sharedManager;
@end
