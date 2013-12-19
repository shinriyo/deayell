//
//  TPTravelShowController.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/03.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "AQGridView.h"
#import "AQGridViewController.h"
#import "TPTravelPhotoCell.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

@interface TPTravelShowController : AQGridViewController <ELCImagePickerControllerDelegate,AQGridViewDelegate, AQGridViewDataSource>

@property(nonatomic, retain) NSNumber *travel_id;
@property(nonatomic, retain) NSArray *photos;

-(void)uploadImage:(NSData *)image;
@end
