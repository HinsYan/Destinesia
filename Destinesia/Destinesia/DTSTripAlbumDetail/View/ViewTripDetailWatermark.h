//
//  ViewTripDetailWatermark.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/15.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewBaseXXNibBridge.h"

@interface ViewTripDetailWatermark : ViewBaseXXNibBridge

@property (weak, nonatomic) IBOutlet UILabel *lbAuthor;
@property (weak, nonatomic) IBOutlet UIImageView *iconUserGrade;

@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbProvince;
@property (weak, nonatomic) IBOutlet UILabel *lbCountry;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@end
