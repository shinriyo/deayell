//
//  TPFriendSearchController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/07/05.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPFriendSearchController.h"

@interface TPFriendSearchController ()

@end

@implementation TPFriendSearchController

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
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    self.tableView.tableHeaderView = searchBar;
    
    // we need to be the delegate so the cancel button works
    searchBar.delegate = self;
    searchBar.placeholder = @"友達を検索";
    
    // create the Search Display Controller with the above Search Bar
    _controller = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    _controller.searchResultsDataSource = self;
    _controller.searchResultsDelegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:TPReloadFriendsSearch object:nil];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFacebook) name:TPSearchFriendFacebook object:nil];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                            handler:^(id sender) {
                                [[TPFacebook sharedInstance] openFacebook:TPSearchFriendFacebook];
                                
                                
                            }];
    self.navigationItem.rightBarButtonItems = @[btn];
    
    
}

- (void)searchFacebook{
    [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        NSMutableArray *friend_uid_list = [[NSMutableArray alloc]init];
        for (NSDictionary *friend in result[@"data"]){
            [friend_uid_list addObject:friend[@"id"]];
            
        }
        NSString *friend_uid = [friend_uid_list componentsJoinedByString:@","];
        //これをpostして受け取るところを記述
    }];
    
    
    
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
    NSLog(@"s:%d",[_searchUsers count]);

    if(tableView == self.searchDisplayController.searchResultsTableView && [_searchUsers count] > 0){

        return [_searchUsers count];
        
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Configure the cell...
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if(tableView == self.searchDisplayController.searchResultsTableView){
        NSUInteger index = [_following_ids indexOfObject:[_searchUsers[indexPath.row] valueForKeyPath:@"id"]];
        
        // 要素があったか?
        if (index != NSNotFound) { // yes
            cell.textLabel.textColor = [UIColor orangeColor];
        }
        cell.textLabel.text = [_searchUsers[indexPath.row] valueForKeyPath:@"username"];
    }
    return cell;
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"callSearch:%@", searchText);
    NSDictionary *dic = @{@"username": searchText};
    [[NSNotificationCenter defaultCenter] postNotificationName:TPReloadFriendsSearch object:self userInfo:dic];
}



- (void)getData:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSString *username = [userInfo valueForKeyPath:@"username"];
    
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    NSString *url = [tp_api searchFriendPath];
    
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [sharedClient requestWithMethod:@"POST"
                                                              path: url
                                                        parameters:  @{@"username": username}

                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             
                                             _searchUsers = nil;
                                             if([[JSON valueForKeyPath:@"users"] count] > 0){
                                                 _searchUsers = [JSON valueForKeyPath:@"users"];
                                                 [self.searchDisplayController.searchResultsTableView reloadData];

                                             }
                                            _following_ids = [JSON valueForKeyPath:@"following_ids"];
                                             [self.searchDisplayController.searchResultsTableView reloadData];
                                            
                                         
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);
                                             
                                             [SVProgressHUD showErrorWithStatus:@"エラーが発生しました"];
                                             
                                         }];
    [sharedClient enqueueHTTPRequestOperation:operation];
    
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
}

@end
