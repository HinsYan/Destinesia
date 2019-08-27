//
//  ViewNewTripAlbumPhotoEdit.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewNewTripAlbumPhotoEdit.h"

static NSString *const kNewTripAlbumPhotoEditDescPlaceholder = @" 这一刻的想法...";

@interface ViewNewTripAlbumPhotoEdit () <

    UITextViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *lbPlaceholder;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@end


static const CGFloat kLabelCornerRadius = 5.f;

@implementation ViewNewTripAlbumPhotoEdit

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ViewNewTripAlbumPhotoEdit" owner:nil options:nil];
        self = [arr firstObject];
        self.frame = frame;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_lbPhotoIndex.bounds
                                               byRoundingCorners: UIRectCornerBottomLeft
                                                     cornerRadii: (CGSize){kLabelCornerRadius, kLabelCornerRadius}].CGPath;
        _lbPhotoIndex.layer.mask = maskLayer;
        
        _lbPlaceholder.text = kNewTripAlbumPhotoEditDescPlaceholder;
        
        _textView.delegate = self;
        [_textView becomeFirstResponder];
    }
    return self;
}

- (void)setModelNewTripAlbumPhoto:(ModelNewTripAlbumPhoto *)modelNewTripAlbumPhoto
{
    _modelNewTripAlbumPhoto = modelNewTripAlbumPhoto;
    
    _lbPhotoIndex.text = [NSString stringWithFormat:@"%ld", (long)_modelNewTripAlbumPhoto.indexOfSelectedCell];
}

- (IBAction)actionBtnClose:(UIButton *)sender {
    [self didClose];
}

- (void)didClose {
    [_textView resignFirstResponder];
    
    [self removeFromSuperview];
}

- (IBAction)actionOK:(UIButton *)sender {
    _modelNewTripAlbumPhoto.photoPesc = _textView.text;
    
    [self didClose];
}

#pragma mark - <UITextViewDelegate>

// TODO: 封面不需要desc
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        _lbPlaceholder.text = kNewTripAlbumPhotoEditDescPlaceholder;
    } else {
        _lbPlaceholder.text = @"";
    }
}

@end
