//
//  ViewNewTripAlbumPhotoEdit.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelNewTripAlbumPhoto.h"

@interface ViewNewTripAlbumPhotoEdit : UIView

@property (nonatomic, strong) ModelNewTripAlbumPhoto *modelNewTripAlbumPhoto;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lbPhotoIndex;

@end
