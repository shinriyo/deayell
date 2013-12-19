//
//  TPTravelPhotoCell.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/03.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPTravelPhotoCell.h"

@implementation TPTravelPhotoCell
@synthesize imageView;

- (id)initWithFrame:(CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        UILabel *label = [[UILabel alloc]initWithFrame: CGRectMake(10,10,50,50)];
        label.text = @"hoge";
        [self.contentView addSubview:label];
        [self.contentView addSubview:imageView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0, 80, 80) ;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}


@end
