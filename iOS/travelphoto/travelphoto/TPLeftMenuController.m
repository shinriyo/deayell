//
//  TPLeftMenuController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/29.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPLeftMenuController.h"
#import "TPAppDelegate.h"


@interface TPLeftMenuController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * menuList;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation TPLeftMenuController

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
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Datam setter
- (NSArray *)menuList
{
    if (!_menuList) {
        _menuList = @[@[@"マイページ",@"TPMyPageController"],
                      @[@"旅",@"TPTravelController"],
                      @[@"友達",@"TPFriendController"],
                      @[@"友達を検索",@"TPFriendSearchController"],
                      @[@"友達の旅",@"TPFriendTravelController"],
                      @[@"設定",@"TPSettingController"]];
    }
    return _menuList;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =[UIColor darkGrayColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    // Configure the cell...
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.menuList[indexPath.row][0];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSDictionary *dic = @{@"CLASS": self.menuList[indexPath.row][1]};
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:TPShowPanel object:self userInfo:dic];

    
}

@end
