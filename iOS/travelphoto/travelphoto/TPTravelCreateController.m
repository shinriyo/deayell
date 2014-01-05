//
//  TPTravelCreateController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/01.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPTravelCreateController.h"
#import "QDateTimeElement.h"


@interface TPTravelCreateController ()

@end

@implementation TPTravelCreateController

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
    
    UIBarButtonItem *submitButtonItem =    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"TPTravelCreateControllerRegiser", nil)
                                                                            style:UIBarButtonItemStyleDone
                                                                           target:self action:@selector(onSubmit)];
    [self.navigationItem setRightBarButtonItem:submitButtonItem];
    
    self.root.title = NSLocalizedString(@"TPTravelCreateControllerCreateTripInfo", nil);
    
    QSection *section = [[QSection alloc] init];
    QEntryElement *title = [[QEntryElement alloc] initWithKey:@"title"];
    title.keyboardType = UIKeyboardAppearanceDefault;
    title.placeholder = NSLocalizedString(@"TPTravelCreateControllerInputTitle", nil);
    title.bind = @"textValue:title";
    title.title = NSLocalizedString(@"TPTravelCreateControllerTitle", nil);
    
    QDateTimeInlineElement *startdate = [[QDateTimeInlineElement alloc] initWithDate:[NSDate date] andMode:UIDatePickerModeDate];
    startdate.title = NSLocalizedString(@"TPTravelCreateControllerStartDate", nil);
    startdate.key = @"startdate";


    QDateTimeInlineElement *enddate = [[QDateTimeInlineElement alloc] initWithDate:[NSDate date] andMode:UIDatePickerModeDate];
    enddate.title = NSLocalizedString(@"TPTravelCreateControllerEndDate", nil);
    enddate.key = @"enddate";
    
    [section addElement:title];
    [section addElement:startdate];
    [section addElement:enddate];

    [self.root addSection:section];
    
}

- (void)onSubmit
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"TPTravelCreateControllerSending", nil) maskType:SVProgressHUDMaskTypeBlack];
    QEntryElement *title = (QEntryElement *)[self.root elementWithKey:@"title"];
    QDateTimeInlineElement *startdate = (QDateTimeInlineElement *)[self.root elementWithKey:@"startdate"];
    QDateTimeInlineElement *enddate = (QDateTimeInlineElement *)[self.root elementWithKey:@"enddate"];

    if(startdate.dateValue == NULL || enddate.dateValue == NULL ||title.textValue == NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"CommonNoFormData", nil)];
        return;
    }

    if([startdate.dateValue compare:enddate.dateValue] == NSOrderedDescending){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"TPTravelCreateControllerInvalidDate", nil)];
        return;

    }
    
    // 通信処理
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    
    if([tp_api.networkStatus boolValue] == NO){
        return;
    }
    
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    
    
    NSDictionary *userDic = @{@"travel[title]": title.textValue ,
                              @"travel[startdate]": startdate.dateValue,
                                @"travel[enddate]": enddate.dateValue};

    NSString *path = [tp_api travelCreatePath];
    NSLog(@"%@",path);
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         
                                         JSONRequestOperationWithRequest:[sharedClient requestWithMethod:@"POST"
                                                                                                    path: path
                                                                                              parameters: userDic
                                                                          
                                                                          ]
                                         
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             
                                             [[NSNotificationCenter defaultCenter] postNotificationName:TPReloadTravels object:self userInfo:nil];


                                             [self.navigationController popToRootViewControllerAnimated:TRUE];

                                             [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CommonCreateDone", nil)];

                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);
//                                             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"エラーが発生しました" message:@"メールアドレスまたはパスワードが間違っています"
                                               UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"CommonErrorHappened", nil) message:@"おかしい"                                                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"CommonConfirm", nil) otherButtonTitles:nil];
                                             
                                             [alertView show];
                                             
                                             
                                             [SVProgressHUD dismiss];
                                             
                                             
                                         }];
    [sharedClient enqueueHTTPRequestOperation:operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
