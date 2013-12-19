//
//  TPTravelController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/29.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPTravelController.h"
#import "TPTravelCreateController.h"
#import "TPTravelShowController.h"
#import "TPTravelMapController.h"

#import "User.h"
#import "Travel.h"

@interface TPTravelController ()


@end

@implementation TPTravelController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self.view setBackgroundColor:[UIColor blueColor]];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                            handler:^(id sender) {
                                QRootElement *root = [[QRootElement alloc] init];
                                root.grouped = YES;
                                TPTravelCreateController *viewController = (TPTravelCreateController *) [[TPTravelCreateController alloc] initWithRoot:root];
                                [self.navigationController pushViewController:viewController animated:YES];

                                
                            }];
    
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                             target:self action:@selector(getData)];
 
    UIBarButtonItem *btn3 = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                             handler:^(id sender) {

                                 TPTravelMapController *viewController =  [[TPTravelMapController alloc] init];
                                 [self.navigationController pushViewController:viewController animated:YES];
                                 
                                 
                             }];
    self.navigationItem.rightBarButtonItems = @[btn,btn2,btn3];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:TPReloadTravels object:nil];
    _travels = [Travel findAllSortedBy:@"id" ascending:NO];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(dataRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}
- (void)dataRefresh:(UIRefreshControl *)sender
{

    [[NSNotificationCenter defaultCenter] postNotificationName:TPReloadTravels object:self userInfo:nil];
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:1.0];

}

- (void)finishRefresh
{
    [self.refreshControl endRefreshing];
}


- (void)reloadData
{
    
    [self getData];
    _travels = [Travel findAllSortedBy:@"id" ascending:NO];
    [self.tableView reloadData];

}

- (void)getData
{
    

    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    NSString *url = [tp_api travelPath];
    
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [sharedClient requestWithMethod:@"GET"
                                                              path: url
                                                        parameters:nil
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             
                                             
                                             NSArray *travels = [JSON valueForKeyPath:@"travels"];
                                             NSDictionary *user = [JSON valueForKeyPath:@"user"];
                                             
                                             NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
                                            
                                             
                                             User *user_model = [User findFirstByAttribute:@"id" withValue:[user valueForKey:@"id"]];

                                             if(user_model == NULL){
                                                 user_model = [User createEntity];
                                             }
                                             
                                             user_model.id = [user valueForKey:@"id"];
                                             user_model.username = [user valueForKey:@"username"];
                                             
                                             [context saveToPersistentStoreAndWait];

                                             
                                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                             [formatter setDateFormat:@"yyyy-MM-dd"];

                                             for (NSDictionary * travel in travels) {
                                                 Travel *travel_model = [Travel findFirstByAttribute:@"id" withValue:[travel valueForKey:@"id"]];
                                                 if(travel_model == NULL){
                                                     travel_model = [Travel createEntity];
                                                 }
                                                // NSLog(@"%@",travel);
                                                 travel_model.id = [travel valueForKey:@"id"];
                                                 travel_model.title = [travel valueForKey:@"title"];
                                                 travel_model.startdate = [formatter dateFromString:[travel valueForKey:@"startdate"]];
                                                 travel_model.enddate = [formatter dateFromString:[travel valueForKey:@"enddate"]];
                                                 travel_model.user = user_model;
                                                 if ([[travel valueForKey:@"photo_url"] isEqual:[NSNull null]]){
                                                     travel_model.photo_url = @"";

                                                 }
                                                 else{
                                                     travel_model.photo_url = [travel valueForKey:@"photo_url"];

                                                 }
                                                // NSLog(@"%@",travel_model);
                                                 [context saveToPersistentStoreAndWait];

                                             }
                                         
                                         _travels = [Travel findAllSortedBy:@"id" ascending:NO];
                                         [self.tableView reloadData];

                                         
                                             
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [_travels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Travel *travel =  _travels[indexPath.row];
    
    TPTravelCell *cell;
    if(!cell){
        cell =[[TPTravelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelCell"];
    }
    [cell.titleImageView setImageWithURL:[NSURL URLWithString:travel.photo_url]];
    cell.titleLabel.text = travel.title;
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyy/MM/dd"];

    cell.dateLabel.text = [NSString stringWithFormat:@"%@から%@",[df stringFromDate:travel.startdate],[df stringFromDate:travel.enddate]];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TP_TRAVEL_CELL_HEIGHT;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    TPTravelShowController *travel_show = [[TPTravelShowController alloc]init];
    Travel *travel = _travels[indexPath.row];
    travel_show.travel_id = travel.id;
    
    
    [self.navigationController pushViewController:travel_show animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
