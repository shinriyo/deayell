//
//  TravelPhotoAPI.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/30.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TravelPhotoAPI.h"

@implementation TravelPhotoAPI

@synthesize networkStatus = _networkStatus;

+ (TravelPhotoAPI *)sharedInstance {
    static TravelPhotoAPI *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[TravelPhotoAPI alloc] init];
    });
    [sharedInstance checkNetworkStatus];
    return sharedInstance;
}



+ (AFHTTPClient *)sharedClient {
    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",S_API_BASE]]];
    });
    return _sharedClient;
}

- (void)checkNetworkStatus{
        
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
        [SVProgressHUD showErrorWithStatus:@"ネットワーク接続ができません"];
        self.networkStatus = [NSNumber numberWithBool:NO];
    }
    self.networkStatus = [NSNumber numberWithBool:YES];
}

- (NSString *)signInPath {
    return @"/api/users/sign_in";
    //[NSString stringWithFormat:@"%@/api/users", S_API_BASE];

}

- (NSString *)signUpPath {
    return @"/api/users";
}
- (NSString *)signInFacebookPath {
    return @"/api/users/auth_facebook";
}

- (NSString *)photoCreatePath {
    return [NSString stringWithFormat:
            @"/api/photo?auth_token=%@",[[TPUserInfo sharedInstance]auth_token]];
    
}

- (NSString *)searchFriendPath{
    return [NSString stringWithFormat:
            @"/api/friend/search?auth_token=%@",[[TPUserInfo sharedInstance]auth_token]];

}


- (NSString *)photoPath {
    return [NSString stringWithFormat:
            @"/api/photo?auth_token=%@",[[TPUserInfo sharedInstance]auth_token]];
    
}
- (NSString *)travelMapPath {
    return [NSString stringWithFormat:
            @"/api/travel/map?auth_token=%@",[[TPUserInfo sharedInstance]auth_token]];
    
}

- (NSString *)travelCreatePath {
    return [NSString stringWithFormat:
            @"/api/travel?auth_token=%@",[[TPUserInfo sharedInstance]auth_token]];
    
}



- (NSString *)travelPath {
    return [NSString stringWithFormat:
            @"/api/travel?auth_token=%@",[[TPUserInfo sharedInstance]auth_token]];
    
}

- (NSString *)setCoverPhotoPath {
    return [NSString stringWithFormat:
            @"/api/travel/cover_photo?auth_token=%@",[[TPUserInfo sharedInstance]auth_token]];
    
}

- (NSString *)sendPasswordUrl {
    return [NSString stringWithFormat:@"%@/users/password/new", S_API_BASE];
}
@end
