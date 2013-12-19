//
//  TPTravelMapController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/04.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPTravelMapController.h"

@interface TPTravelMapController ()

@end

@implementation TPTravelMapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //_mapView.showsUserLocation=TRUE;
	[self.view addSubview:_mapView];
    
    [self getData];
}

- (void)getData
{
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    NSString *url = [tp_api travelMapPath];
    
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [sharedClient requestWithMethod:@"GET"
                                                              path: url
                                                        parameters:nil
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             
                                             
                                             _travels = [JSON valueForKeyPath:@"travels"];
                                             if([_travels count] > 0){
                                             
                                             for (NSDictionary * travel in _travels) {
                                                NSLog(@"%@",travel);
                                                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                                                NSString *lat = (NSString *)travel[@"lat"];
                                                NSString *lon = (NSString *)travel[@"lon"];

                                                point.coordinate = CLLocationCoordinate2DMake([lat doubleValue],[lon doubleValue]);
                                                 point.title = travel[@"title"];
                                                
                                                 [_mapView addAnnotation:point];
                                                 
                                                 
                                                 
                                             }
                                            //初期表示用
                                             NSDictionary *travel = _travels[0];
                                             NSString *lat = (NSString *)travel[@"lat"];
                                             NSString *lon = (NSString *)travel[@"lon"];
                                             CLLocationCoordinate2D co;
                                             co.latitude = [lat doubleValue];
                                             co.longitude = [lon doubleValue];
                                             [_mapView setCenterCoordinate:co animated:YES];

                                             MKCoordinateRegion cr = _mapView.region;
                                             cr.center = co;
                                             cr.span.latitudeDelta = 0.5;
                                             cr.span.longitudeDelta = 0.5;
                                             [_mapView setRegion:cr animated:YES];
                                             }

                                             
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);
                                             
                                             [SVProgressHUD showErrorWithStatus:@"エラーが発生しました"];
                                             
                                         }];
    [sharedClient enqueueHTTPRequestOperation:operation];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
