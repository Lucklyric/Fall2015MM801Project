//
//  LoginViewController.m
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-18.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentEditing = nil;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginButton:(id)sender {
    if ([self.userNameTextField.text isEqualToString:@"801test1"] && [self.userPwdTextField.text isEqualToString:@"111111"]) {
        /*Jump to Main Panel*/
        [self performSegueWithIdentifier:@"LoginToHomePage" sender:self];
    }else{
        /*Show warnning*/
        NSLog(@"Login Field");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Password or Username incorrect!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Retry"
                                                  otherButtonTitles:nil];
        [alertView setTag:1];
        [alertView show];

    }
}

#pragma mark - TextFied Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.currentEditing = textField;
    NSLog(@"NameEdition");
    return YES;
}

- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float offset = 0;
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (self.currentEditing == self.userNameTextField){
        
        offset = -150;
    }else if(self.currentEditing == self.userPwdTextField){
        offset = -230;
    }
    
    self.view.frame = CGRectMake(offset, 0 , self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif{
    //NSDictionary *info = [notif userInfo];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    // keyboardWasShown = NO;
    self.currentEditing = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
