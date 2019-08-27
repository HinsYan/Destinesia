//
//  ViewInviteWelcome.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewInviteWelcome.h"
#import "UIButton+DTSCategory.h"

@interface ViewInviteWelcome ()

@property (weak, nonatomic) IBOutlet UIButton *btnGotoCamera;

@end

@implementation ViewInviteWelcome

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
    
    _btnGotoCamera.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnGotoCamera.layer.borderWidth = 2.0f;
    _btnGotoCamera.layer.cornerRadius = 5.0f;
    
    _btnGotoCamera.backgroundColor = [UIColor whiteColor];
    [_btnGotoCamera cs_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnGotoCamera cs_setBackgroundColor:RGBHEX(0xEEEEEE) forState:UIControlStateHighlighted];
    
    return self;
}

- (IBAction)actionGotoCamera:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ViewInviteWelcomeActionGotoCamera)]) {
        [_delegate ViewInviteWelcomeActionGotoCamera];
    }
}

@end
