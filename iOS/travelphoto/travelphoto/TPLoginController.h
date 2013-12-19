//
//  TPLoginController.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/30.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "QuickDialogController.h"
#import "TPRegistController.h"

@interface TPLoginController : QuickDialogController 

- (void)onRegistFacebook:(NSString *)email uid:(NSString *)uid;

@end
