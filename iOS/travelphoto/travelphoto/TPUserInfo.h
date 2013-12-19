//
//  TPUserInfo.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/28.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUKeychainAccess.h"




@interface TPUserInfo : NSObject
@property(nonatomic, strong) NSString *auth_token;

+ (TPUserInfo *)sharedInstance;


- (NSString *)loadEmail;
- (void)saveEmail:(NSString *)email;
- (NSString *)loadPassword;
- (void)savePassword:(NSString *)password;
- (NSString *)loadAuthToken;
- (void)saveAuthToken:(NSString *)auth_token;

- (void)clearUserInfo;
@end
