//
//  TPLoginController.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/30.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "QuickDialogController.h"
#import "TPRegisterController.h"

@interface TPLoginController : QuickDialogController 

//- (void)onRegisterFacebook:(NSString *)email uid:(NSString *)uid;
- (void)onRegisterFacebook:(NSString *)email uid:(NSString *)uid username:(NSString *)username;
@end
