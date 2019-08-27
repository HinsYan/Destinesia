//
//  ViewInviteUserInfo.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewInviteUserInfo.h"
#import "DTSUserInfoManager.h"

@interface ViewInviteUserInfo ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswd;

@property (weak, nonatomic) IBOutlet UILabel *lbCompleteUserInfoError;

@end

@implementation ViewInviteUserInfo

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        if (array.count < 1 || ![[array objectAtIndex:0] isKindOfClass:[self class]]) {
            return nil;
        }
        
        self = [array objectAtIndex:0];
    }
    
    _lbCompleteUserInfoError.hidden = YES;
    
    [self addTapGesture];
    
    return self;
}

- (void)beginInputUsername {
    [_textFieldUsername becomeFirstResponder];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_textFieldUsername]) {
        NSLog(@"username");
    } else if ([textField isEqual:_textFieldEmail]) {
        NSLog(@"email");
    } else if ([textField isEqual:_textFieldPasswd]) {
        NSLog(@"passwd");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_textFieldUsername] && [self checkUsername:textField.text]) {
        [_textFieldEmail becomeFirstResponder];
    } else if ([textField isEqual:_textFieldEmail] && [self checkEmail:textField.text]) {
        [_textFieldPasswd becomeFirstResponder];
    } else if ([textField isEqual:_textFieldPasswd] && [self checkPasswd:textField.text]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [self completeUserInfo];
    }
    
    return YES;
}

#pragma mark - complete user info

- (BOOL)checkUsername:(NSString *)username {

    return YES;
}

- (BOOL)checkEmail:(NSString *)email {
    
    return YES;
}

- (BOOL)checkPasswd:(NSString *)passwd {
    
    return YES;
}

- (BOOL)completeUserInfo {
    NSString *username = _textFieldUsername.text;
    NSString *email = _textFieldEmail.text;
    NSString *passwd = _textFieldPasswd.text;
    DTSLog(@"username: %@, email: %@, passwd: %@", username, email, passwd);
    
    if (![self checkUsername:username] ||
        ![self checkEmail:email] ||
        ![self checkPasswd:passwd]) {
        _lbCompleteUserInfoError.hidden = NO;
        return NO;
    }
    
    [[DTSAccountManager sharedInstance] registerWithUsername:username
                                                           email:email
                                                          passwd:passwd
                                         withCompletionBlock:^(id responseObject) {
             
                 if (responseObject && [responseObject objectForKey:@"token"]) {
                     // 注册之后就已经登录了
//                     [[DTSAccountManager sharedInstance] loginWithUsername:username passwd:passwd];
                     
                     // 更新token
                     [DTSUserDefaults setUserToken:[responseObject objectForKey:@"token"]];
                     
                     _lbCompleteUserInfoError.hidden = YES;
                     
                     if (_delegate && [_delegate respondsToSelector:@selector(ViewInviteUserInfoActionDone)]) {
                         [_delegate ViewInviteUserInfoActionDone];
                     }
                 } else {
                     _lbCompleteUserInfoError.hidden = NO;
                 }
             
         } withErrorBlock:^(id responseObject) {
             if (![responseObject isKindOfClass:[NSError class]]) {
                 DTSLog(@"%@", [responseObject objectForKey:@"code"]);
                 [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
             } else {
                 
             }
         }];
    return YES;
}

@end
