//
//  TravelPhotoAPI.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/30.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "Reachability.h"


#ifdef DISTRIBUTION
#define API_BASE @"http://travelphoto.herokuapp.com"
#define S_API_BASE @"https://travelphoto.herokuapp.com"
#define WEB_BASE @"http://travelphoto.herokuapp.com"
#define S_WEB_BASE @"https://travelphoto.herokuapp.com"
#else
#define API_BASE @"http://localhost:3000"
#define S_API_BASE @"http://localhost:3000"
#define WEB_BASE @"http://localhost:3000"
#define S_WEB_BASE @"http://localhost:3000"
#endif


@interface TravelPhotoAPI : NSObject

@property (strong, nonatomic) NSNumber* networkStatus;


+ (TravelPhotoAPI *)sharedInstance;
+ (AFHTTPClient *)sharedClient;

- (void)checkNetworkStatus;

- (NSString *)signInPath;
- (NSString *)signUpPath;
- (NSString *)travelCreatePath;
- (NSString *)signInFacebookPath;


- (NSString *)sendPasswordUrl;
- (NSString *)travelPath;
- (NSString *)photoCreatePath;
- (NSString *)photoPath;
- (NSString *)travelMapPath;

- (NSString *)setCoverPhotoPath;

- (NSString *)searchFriendPath;

@end
