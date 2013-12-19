//
//  TPUserInfo.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/28.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPUserInfo.h"
#import "Travel.h"
#import "User.h"

@implementation TPUserInfo
+ (TPUserInfo *)sharedInstance {
    static TPUserInfo *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[TPUserInfo alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *)auth_token{
    if(_auth_token == NULL){
        _auth_token = [self loadAuthToken];
    }
    
    return _auth_token;
}

- (NSString *)loadEmail {
    NSString *email = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"email"];
    return email;
}

- (void)saveEmail:(NSString *)email{
    [[LUKeychainAccess standardKeychainAccess] setObject:email forKey:@"email"];
}


- (NSString *)loadPassword {
    NSString *email = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"password"];
    return email;
}

- (void)savePassword:(NSString *)password{
    [[LUKeychainAccess standardKeychainAccess] setObject:password forKey:@"password"];
    
}

- (NSString *)loadAuthToken {
    NSString *email = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"auth_token"];
    return email;
}

- (void)saveAuthToken:(NSString *)auth_token{
    [[LUKeychainAccess standardKeychainAccess] setObject:auth_token forKey:@"auth_token"];
    _auth_token = NULL;
    
}



- (void)clearUserInfo{
    [self saveEmail:nil];
    [self savePassword:nil];
    [self saveAuthToken:nil];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];;

    [Travel truncateAll];
    [User truncateAll];
    [context saveToPersistentStoreAndWait];


    
}


@end
