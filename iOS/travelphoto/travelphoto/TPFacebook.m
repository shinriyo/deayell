//
//  TPFacebook.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/08.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPFacebook.h"

@implementation TPFacebook

@synthesize session = _session;
@synthesize permissions = _permissions;


+ (TPFacebook *)sharedInstance {
    static TPFacebook *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[TPFacebook alloc] init];
        sharedInstance.permissions = [NSArray arrayWithObjects:@"email", @"read_friendlists",@"user_about_me", nil];

        
    });
    return sharedInstance;
}


- (void)openFacebook:(NSString *)notificationName{
    
    if(FBSession.activeSession.isOpen){
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:nil];
    }
    else{
        [FBSession openActiveSessionWithReadPermissions:[TPFacebook sharedInstance].permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          
                                          
                                          if(status == FBSessionStateOpen){
                                              [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:nil];
                                              
                                              
                                          }
                                          
                                          
                                          
                                      }];
    }



}

@end
