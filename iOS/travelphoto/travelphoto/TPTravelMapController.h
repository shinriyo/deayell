//
//  TPTravelMapController.h
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/04.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface TPTravelMapController : UIViewController <MKMapViewDelegate>
@property(nonatomic,retain) MKMapView *mapView;
@property(nonatomic,retain) NSArray *travels;

@end
