//
//  TPFriendSearchController.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/05.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPFriendSearchController : UITableViewController <UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) UISearchDisplayController *controller;
@property (retain, nonatomic) NSArray *searchUsers;
@property (retain, nonatomic) NSArray *following_ids;


@end
