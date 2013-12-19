//
//  TPFacebook.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/08.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>



@interface TPFacebook : NSObject
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSArray *permissions;
+ (TPFacebook *)sharedInstance;
- (void)openFacebook:(NSString *)notificationName;

@end
