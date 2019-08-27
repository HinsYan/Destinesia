//
//  ViewInviteCode.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewInviteCode.h"
#import "DTSUserInfoManager.h"

@interface ViewInviteCode () <

    UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *textFieldInviteCode;

@property (weak, nonatomic) IBOutlet UILabel *lbVerifyCodeError;

@end

@implementation ViewInviteCode

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
    
    _lbVerifyCodeError.hidden = YES;
    
    [self addTapGesture];
    
    return self;
}

- (void)beginInputInviteKey {
    [_textFieldInviteCode becomeFirstResponder];
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
    _lbVerifyCodeError.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self verifyInviteCode];
    
    return YES;
}

- (BOOL)verifyInviteCode
{
    [[DTSAccountManager sharedInstance] verifyInviteCode:_textFieldInviteCode.text
                                     withCompletionBlock:^(id responseObject) {
        
        if (responseObject && [responseObject objectForKey:@"grade"]) {
            _lbVerifyCodeError.hidden = YES;
            
            if (_delegate && [_delegate respondsToSelector:@selector(ViewInviteCodeActionDone:)]) {
                [_delegate ViewInviteCodeActionDone:_textFieldInviteCode.text];
            }
        } else {
            _lbVerifyCodeError.hidden = NO;
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
