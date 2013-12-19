//
//  TPTravelShowController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/03.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPTravelShowController.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "TPTravelPhotoController.h"
#import <Social/Social.h>

@interface TPTravelShowController ()

@end

@implementation TPTravelShowController
@synthesize travel_id;
@synthesize photos;


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
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                            handler:^(id sender) {
                                ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] init];
                                ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
                                [albumController setParent:imagePicker];
                                [imagePicker setDelegate:self];
                                
                                [self presentViewController:imagePicker
                                                   animated:YES
                                                 completion:nil];

                                
                                
                            }];
    
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemSave handler:^(id sender) {
                                    SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                     [slComposeViewController setInitialText:@"Travel"];
                                     [slComposeViewController addURL:[NSURL URLWithString:@"http://localhost:3000"]];
                                     [self presentViewController:slComposeViewController animated:YES completion:nil];
                             }];
    
    self.navigationItem.rightBarButtonItems = @[btn,btn2];
    
    
    self.gridView = [[AQGridView alloc] init];
    // Grid View
    self.gridView.backgroundColor = [UIColor whiteColor];
    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 44, 0);
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self getData];
    [self.gridView reloadData];
    
    
}




#pragma mark - grid view delegate
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView {
    return [self.photos count];
    
    
}



- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    TPTravelPhotoCell *cell = (TPTravelPhotoCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];

    if (cell == nil){
        cell = [[ TPTravelPhotoCell alloc] initWithFrame:CGRectMake(0, 0, 80, 80)
                                      reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = AQGridViewCellSelectionStyleNone;
    NSDictionary *photo = self.photos[index];
    NSLog(@"%@",[photo valueForKey:@"thumb_url"]);
    [cell.imageView setImageWithURL:[NSURL URLWithString:[photo valueForKey:@"thumb_url"]]];
    return cell;
    
}



- (void)getData
{
    
    
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    NSString *url = [tp_api photoPath];
    
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [sharedClient requestWithMethod:@"GET"
                                                              path: url
                                                        parameters:@{@"travel_id": self.travel_id}
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             
                                             
                                            self.photos = [JSON valueForKeyPath:@"photos"];

                                             [self.gridView reloadData];
                                             
                                             
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);
                                             
                                             [SVProgressHUD showErrorWithStatus:@"エラーが発生しました"];
                                             
                                         }];
    [sharedClient enqueueHTTPRequestOperation:operation];
    
}


- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    
    
    TPTravelPhotoController *travelPhoto = [[TPTravelPhotoController alloc] init];
    travelPhoto.photo = photos[index];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:travelPhoto];
    
    [self presentViewController:navi animated:YES completion:nil];
    [self.gridView deselectItemAtIndex:index animated:YES];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([info count]<1) {
        return;
    }
    for(NSDictionary *dict in info) {
        NSURL *asset_url = [dict objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        
        [lib assetForURL:asset_url resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];

            NSUInteger size = [representation size];
            uint8_t *buff = (uint8_t *)malloc(sizeof(uint8_t)*size);
            if(buff != nil){
                NSError *error = nil;
                NSUInteger bytesRead = [representation getBytes:buff fromOffset:0 length:size error:&error];
                if (bytesRead && !error) {
                    NSData *image = [NSData dataWithBytesNoCopy:buff length:bytesRead freeWhenDone:YES];
                    [self uploadImage:image];

                }
            }
        
        } failureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"エラーが発生しました"];
        }];
    }
    
        
}

- (void)uploadImage:(NSData *)image{
    

    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    if([tp_api.networkStatus boolValue] == NO){
        return;
    }
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    NSDictionary *userDic = @{@"photo[travel_id]": self.travel_id};
    NSString *path = [tp_api photoCreatePath];
    
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         
                                         JSONRequestOperationWithRequest:[sharedClient multipartFormRequestWithMethod:@"POST"
                                                                                                    path: path
                                                                                              parameters: userDic
                                                                               constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                                                   [formData appendPartWithFileData:image name:@"photo[image]" fileName:[NSString stringWithFormat:@"image_%lf.png",[[[NSDate alloc] init] timeIntervalSince1970]] mimeType:@"image/jpeg"];
                                                                                
                                                                               }]
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             
                                             WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"画像のUploadに成功しました"];
                                             [notice show];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);

                                             
                                             
                                             WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Network Error" message:@"Check your network connection."];
                                             [notice show];
                                             
                                             
                                             
                                         }];
    [sharedClient enqueueHTTPRequestOperation:operation];

}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
