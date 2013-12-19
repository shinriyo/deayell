//
//  TPTravelCell.h
//  TravelPhoto
//
//  Created by Yuuna Morisawa on 2013/06/24.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const float TP_TRAVEL_CELL_HEIGHT;


@interface TPTravelCell : UITableViewCell
@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UILabel *dateLabel;
@property(nonatomic,retain) UIImageView *titleImageView;

@end
