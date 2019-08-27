//
//  DTSLoginViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/8.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSLoginViewController.h"
#import "DTSRegisterViewController.h"
#import "RealmAccountManager.h"

@interface DTSLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lbLogin;
@property (weak, nonatomic) IBOutlet UIView *btnForgetPasswd;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UILabel *lbErrorUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswd;
@property (weak, nonatomic) IBOutlet UILabel *lbErrorPasswd;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@end

@implementation DTSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_textFieldUsername becomeFirstResponder];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_textFieldUsername]) {
        NSLog(@"username");
    } else if ([textField isEqual:_textFieldPasswd]) {
        NSLog(@"passwd");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_textFieldUsername] && [self checkUsername:textField.text]) {
        [_textFieldPasswd becomeFirstResponder];
    } else if ([textField isEqual:_textFieldPasswd] && [self checkPasswd:textField.text]) {
        [self login];
    }
    
    return YES;
}

#pragma mark - complete user info

- (BOOL)checkUsername:(NSString *)username {
    
    return YES;
}

- (BOOL)checkPasswd:(NSString *)passwd {
    
    return YES;
}

- (void)login {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [[DTSAccountManager sharedInstance] loginWithUsername:_textFieldUsername.text
                                                   passwd:_textFieldPasswd.text
                                      withCompletionBlock:^(id responseObject) {
             
              if (responseObject && [responseObject objectForKey:@"token"]) {
                  
                  // 更新token
                  [DTSUserDefaults setUserToken:[responseObject objectForKey:@"token"]];
                  
                  [RealmAccountManager loginWithUsername:_textFieldUsername.text
                                                  passwd:_textFieldPasswd.text
                                               userGrade:[[responseObject objectForKey:@"grade"] integerValue]];
                  
                  [self dismissViewControllerAnimated:YES completion:^{
                      [DTSToastUtil toastWithText:@"Login OK."];
                      
                      if (_delegate && [_delegate respondsToSelector:@selector(DTSLoginViewControllerDelegateLoginOK)]) {
                          [_delegate DTSLoginViewControllerDelegateLoginOK];
                      }
                  }];
                  
              } else {
              
                  [DTSToastUtil toastWithText:@"Login Failed."];
                  
                  if (_delegate && [_delegate respondsToSelector:@selector(DTSLoginViewControllerDelegateLoginFail)]) {
                      [_delegate DTSLoginViewControllerDelegateLoginFail];
                  }
                  
              }
         } withErrorBlock:^(id responseObject) {
             if (![responseObject isKindOfClass:[NSError class]]) {
                 DTSLog(@"%@", [responseObject objectForKey:@"code"]);
                 [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
             } else {
                 
             }
         }];
}

#pragma mark - Actions

- (IBAction)actionBack:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionForgetPasswd:(UIButton *)sender {
}

- (IBAction)actionLogin:(UIButton *)sender {
    if ([self checkUsername:_textFieldUsername.text] && [self checkPasswd:_textFieldPasswd.text]) {
        [self login];
    }
}

- (IBAction)actionRegister:(UIButton *)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DTSRegisterViewController *registerVC = [main instantiateViewControllerWithIdentifier:@"DTSRegisterViewController"];
    [self presentViewController:registerVC animated:YES completion:nil];
}

@end
