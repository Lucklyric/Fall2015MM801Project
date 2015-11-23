//
//  MyoController.m
//  MyoCookbook
//
//  Created by Hongzu Li on 2015-11-20.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "MyoController.h"


@implementation MyoController
static MyoController *sharedManager = nil;

+ (MyoController*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}


- (id)init{
    self = [super init];
    _originSetup=0;
    _fistStatus=0;
    _timeDelay = 1.0f/20;
    _lrCalibration=0;
    _udCalibration=0;
    _LRrotation=0;
    _UDrotation=0;
    _threshValue=-5.0f;
    if (self)
    {
        self.currentView = nil;
        // Custom stuff
        // Data notifications are received through NSNotificationCenter.
        // Posted whenever a TLMMyo connects
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didConnectDevice:)
                                                     name:TLMHubDidConnectDeviceNotification
                                                   object:nil];
        // Posted whenever a TLMMyo disconnects.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDisconnectDevice:)
                                                     name:TLMHubDidDisconnectDeviceNotification
                                                   object:nil];
        // Posted whenever the user does a successful Sync Gesture.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSyncArm:)
                                                     name:TLMMyoDidReceiveArmSyncEventNotification
                                                   object:nil];
        // Posted whenever Myo loses sync with an arm (when Myo is taken off, or moved enough on the user's arm).
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUnsyncArm:)
                                                     name:TLMMyoDidReceiveArmUnsyncEventNotification
                                                   object:nil];
        // Posted whenever Myo is unlocked and the application uses TLMLockingPolicyStandard.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUnlockDevice:)
                                                     name:TLMMyoDidReceiveUnlockEventNotification
                                                   object:nil];
        // Posted whenever Myo is locked and the application uses TLMLockingPolicyStandard.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLockDevice:)
                                                     name:TLMMyoDidReceiveLockEventNotification
                                                   object:nil];
        // Posted when a new orientation event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveOrientationEvent:)
                                                     name:TLMMyoDidReceiveOrientationEventNotification
                                                   object:nil];
        // Posted when a new accelerometer event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveAccelerometerEvent:)
                                                     name:TLMMyoDidReceiveAccelerometerEventNotification
                                                   object:nil];
        // Posted when a new pose is available from a TLMMyo.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceivePoseChange:)
                                                     name:TLMMyoDidReceivePoseChangedNotification
                                                   object:nil];
        return self;
    }
    return nil;
}


#pragma mark - NSNotificationCenter Methods

- (void)didConnectDevice:(NSNotification *)notification {
    // Access the connected device.
    //TLMMyo *myo = notification.userInfo[kTLMKeyMyo];
    _connectionStatus=1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                        object:@"MyoConnect"];
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    // Access the disconnected device.
    //TLMMyo *myo = notification.userInfo[kTLMKeyMyo];
    _connectionStatus=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                        object:@"MyoUnconnect"];
}

- (void)didUnlockDevice:(NSNotification *)notification {
    // Update the state to reflect Myo's lock state.
    _unlockStatus=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                        object:@"MyoUnlock"];
}

- (void)didLockDevice:(NSNotification *)notification {
    // Update the label to reflect Myo's lock state.
    _unlockStatus=1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                        object:@"MyoLock"];
}

- (void)didSyncArm:(NSNotification *)notification {
    // Retrieve the arm event from the notification's userInfo with the kTLMKeyArmSyncEvent key.
    //TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];
    _syncStatus=1;
    // Update the armLabel with arm information.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                        object:@"MyoSync"];
   
}

- (void)didUnsyncArm:(NSNotification *)notification {
    // Reset the labels.
    _syncStatus=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                        object:@"MyoUnsync"];
    
}

- (void)didReceiveOrientationEvent:(NSNotification *)notification {
    // Retrieve the orientation from the NSNotification's userInfo with the kTLMKeyOrientationEvent key.
    TLMOrientationEvent *orientationEvent = notification.userInfo[kTLMKeyOrientationEvent];
    float diff=0.0f;
    // Create Euler angles from the quaternion of the orientation.
    TLMEulerAngles *angles = [TLMEulerAngles anglesWithQuaternion:orientationEvent.quaternion];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if(_fistStatus==1 && _originSetup==1){
        diff = _originX-angles.roll.degrees;
        //NSLog(@"Roll 沿x轴转动的差值: %f\n",diff);
        if(currentTime-_fistTime>=_timeDelay){
            _timeDelay+=(1.0f/20);
            //NSLog(@"%lf, %lf\n",currentTime, _fistTime);
            //NSLog(@"Roll 沿x轴转动的差值: %f\n",diff);
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoArmTwist"
                                                            object:[[NSNumber alloc]initWithFloat:diff]];
        }
    }
    // Next, we want to apply a rotation and perspective transformation based on the pitch, yaw, and roll.
    //CATransform3D rotationAndPerspectiveTransform = CATransform3DConcat(CATransform3DConcat(CATransform3DRotate (CATransform3DIdentity, angles.pitch.radians, -1.0, 0.0, 0.0), CATransform3DRotate(CATransform3DIdentity, angles.yaw.radians, 0.0, 1.0, 0.0)), CATransform3DRotate(CATransform3DIdentity, angles.roll.radians, 0.0, 0.0, -1.0));
    
    if(_fistStatus==1 && _originSetup==0){
        _originX=angles.roll.degrees;
        _originSetup=1;
        _fistTime=[[NSDate date] timeIntervalSince1970];
        _timeDelay=1.0f/20;
    }
    _Xrotation = angles.roll.degrees;
    if(_udCalibration==1){
        _UDrotation=_Xrotation;
        _udCalibration=0;
    }
    if(_lrCalibration==1){
        _LRrotation=_Xrotation;
        _lrCalibration=0;
    }
    if(_LRrotation!=0 && _UDrotation!=0){
        _threshValue = (_LRrotation+_UDrotation)/2;
        _LRrotation=0.0f;
        _UDrotation=0.0f;
        NSLog(@"THRESH:%f",self.threshValue);
    }
    
}

- (void)didReceiveAccelerometerEvent:(NSNotification *)notification {
    // Retrieve the accelerometer event from the NSNotification's userInfo with the kTLMKeyAccelerometerEvent.
    //TLMAccelerometerEvent *accelerometerEvent = notification.userInfo[kTLMKeyAccelerometerEvent];
    
    // Get the acceleration vector from the accelerometer event.
    //TLMVector3 accelerationVector = accelerometerEvent.vector;
    
    // Calculate the magnitude of the acceleration vector.
    //float magnitude = TLMVector3Length(accelerationVector);
    
    // Update the progress bar based on the magnitude of the acceleration vector.
    
    // Note you can also access the x, y, z values of the acceleration (in G's) like below
    //float x = accelerationVector.x;
    //float y = accelerationVector.y;
    //float z = accelerationVector.z;
    
    
}

- (void)didReceivePoseChange:(NSNotification *)notification {
    // Retrieve the pose from the NSNotification's userInfo with the kTLMKeyPose key.
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    self.currentPose = pose;
    _fistStatus=0;
    _originSetup=0;
    // Handle the cases of the TLMPoseType enumeration, and change the color of helloLabel based on the pose we receive.
    switch (pose.type) {
        case TLMPoseTypeUnknown:
        case TLMPoseTypeRest:
        case TLMPoseTypeDoubleTap:
            // Changes helloLabel's font to Helvetica Neue when the user is in a rest or unknown pose.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                                object:@"MyoGestureDoubleTap"];
            break;
        case TLMPoseTypeFist:
            // Changes helloLabel's font to Noteworthy when the user is in a fist pose.
            _fistStatus=1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                                object:@"MyoGestureFist"];
            break;
        case TLMPoseTypeWaveIn:
            // Changes helloLabel's font to Courier New when the user is in a wave in pose.
          
            if(_Xrotation>=_threshValue){
                NSLog(@"向下动－－－－－－－－－－－－－－－－－－－－－\n");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                                    object:@"MyoGestureWaveDown"];
            }
            else{
                NSLog(@"向左动－－－－－－－－－－－－－－－－－－－－－\n");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                                    object:@"MyoGestureWaveLeft"];
            }
            
            break;
        case TLMPoseTypeWaveOut:
            // Changes helloLabel's font to Snell Roundhand when the user is in a wave out pose.
            if(_Xrotation>=_threshValue){
                NSLog(@"向上动－－－－－－－－－－－－－－－－－－－－－\n");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                                    object:@"MyoGestureWaveUp"];
            }
            else{
                NSLog(@"向右动－－－－－－－－－－－－－－－－－－－－－\n");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                                    object:@"MyoGestureWaveRight"];
            }
            
            break;
        case TLMPoseTypeFingersSpread:
            // Changes helloLabel's font to Chalkduster when the user is in a fingers spread pose.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyoCookbookGesture"
                                                                object:@"MyoGestureFingerSpread"];
            break;
    }
    
    // Unlock the Myo whenever we receive a pose
    if (pose.type == TLMPoseTypeUnknown || pose.type == TLMPoseTypeRest) {
        // Causes the Myo to lock after a short period.
        [pose.myo unlockWithType:TLMUnlockTypeTimed];
    } else {
        // Keeps the Myo unlocked until specified.
        // This is required to keep Myo unlocked while holding a pose, but if a pose is not being held, use
        // TLMUnlockTypeTimed to restart the timer.
        [pose.myo unlockWithType:TLMUnlockTypeHold];
        // Indicates that a user action has been performed.
        [pose.myo indicateUserAction];
    }
}

- (UINavigationController*)connectMyo {
    // Note that when the settings view controller is presented to the user, it must be in a UINavigationController.
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    // return controller
    return controller;
}
- (void) calibrateLR{
    _lrCalibration=1;
}
- (void) calibrateUD{
    _udCalibration=1;
}

@end
