//
//  TPTravelPhotoController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/03.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPTravelPhotoController.h"

@interface TPTravelPhotoController ()


@end

@implementation TPTravelPhotoController
@synthesize photo;

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
    self.view.backgroundColor = [UIColor whiteColor];
    UIScreen* screen = [UIScreen mainScreen];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                            0.0
                                                            ,0.0
                                                            ,screen.applicationFrame.size.width
                                                            ,screen.applicationFrame.size.height
                                                            )
                    ];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    [imageView setImageWithURL:[NSURL URLWithString:[photo valueForKey:@"image_url"]]];
    [self.view addSubview:imageView];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                            handler:^(id sender) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
    
    
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc]
                            initWithTitle:@"カバーに設定"
                            style:UIBarButtonItemStyleBordered
                            handler:^(id sender) {
                                TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
                                AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
                                NSString *url = [tp_api setCoverPhotoPath];
                                
                                [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
                                NSMutableURLRequest *request = [sharedClient requestWithMethod:@"POST"
                                                                                          path: url
                                                                                    parameters:@{@"id": photo[@"travel_id"],
                                                                                                @"photo_id": photo[@"id"]}
                                                                ];
                                
                                AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                                                     JSONRequestOperationWithRequest:request
                                                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                                                         
                                                                                                                                                
                                                                         [SVProgressHUD showSuccessWithStatus:@"登録が完了しました"];
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:TPReloadTravels object:self userInfo:nil];
                         
                                                                     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                         NSLog(@"Error: %@", error);
                                                                         
                                                                         [SVProgressHUD showErrorWithStatus:@"エラーが発生しました"];
                                                                         
                                                                     }];
                                [sharedClient enqueueHTTPRequestOperation:operation];
                                
                            }];
    
    
    self.navigationItem.rightBarButtonItems = @[btn,btn2];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
