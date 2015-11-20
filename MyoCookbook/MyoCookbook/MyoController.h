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
@property (assign,nonatomic) NSInteger MyoConnection; //0 or 1
@property (assign,nonatomic) NSInteger MyoLockState; //0 or 1
@property (assign,nonatomic) NSInteger MyoSyncState; // 0 or 1
@property (strong,nonatomic) TLMPose *currentPose; // currentPose
@property (assign,nonatomic) NSString * armString;// which arm
@property (assign,nonatomic) NSString * directionString;// arm direction
@property (assign,nonatomic) NSString * poseString; //which pose
@property (assign,nonatomic) NSString * accDir; //accleration direction
- (UINavigationController*)connectMyo;
@end
