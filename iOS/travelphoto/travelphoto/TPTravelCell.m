//
//  PSOrderHistoryCell.m
//  PhotoStamp
//
//  Created by Yuuna Morisawa on 2013/04/24.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPTravelCell.h"

const float TP_TRAVEL_CELL_HEIGHT = 80.0f;


@implementation TPTravelCell
@synthesize titleImageView,titleLabel,dateLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
    titleLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:32.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.highlightedTextColor= [UIColor whiteColor];
    [self.contentView addSubview:titleLabel];
    
    dateLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    dateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.highlightedTextColor= [UIColor whiteColor];
    [self.contentView addSubview:dateLabel];
    
    titleImageView = [[UIImageView alloc]initWithImage:nil];
    [self.contentView addSubview:titleImageView];
    
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    CGRect bounds;
    bounds =  self.contentView.bounds;
    
    self.titleImageView.frame = CGRectMake(0,0, 80, 80) ;
    //self.titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLabel.frame = CGRectMake(100,15,200,30);
    self.dateLabel.frame = CGRectMake(100,60,200,15);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
