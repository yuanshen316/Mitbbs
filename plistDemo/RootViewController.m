//
//  RootViewController.m
//  plistDemo
//
//  Created by Yuan Junsheng on 13-2-26.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "RootViewController.h"
#import "MitbbsTableViewCell.h"
#import "SecondViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"plistdemo" ofType:@"plist"];
    _plistData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Mitbbs";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarBackBlack.png"] forBarMetrics:UIBarMetricsDefault];
    //NSLog(@"controlData = %@",_plistData);
    UIBarButtonItem *selfBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profileBarButton.png"] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItem = selfBtn;

    _tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
    _tableViews.dataSource = self;
    _tableViews.delegate = self;
    [self.view addSubview:_tableViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark FlickTabView Delegate & Data Source

- (void)scrollTabView:(FlickTabView*)scrollTabView didSelectedTabAtIndex:(NSInteger)index {
    _selectNum = index;
	[self.tableView reloadData];
}

- (NSInteger)numberOfTabsInScrollTabView:(FlickTabView*)scrollTabView {
	return _plistData.count;
}

- (NSString*)scrollTabView:(FlickTabView*)scrollTabView titleForTabAtIndex:(NSInteger)index {
    
    NSDictionary *sectionTitle = [_plistData objectAtIndex:index];
    NSLog(@"sectionTitle = %@",sectionTitle[@"text"]);
	return sectionTitle[@"text"];
}

#pragma mark TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _sectionText = [_plistData objectAtIndex:_selectNum];
    return [_sectionText[@"classify"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    MitbbsTableViewCell *mitbbsCell = (MitbbsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identity];
//    if (mitbbsCell == nil)
//    {
        mitbbsCell = [[MitbbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
//    }
//    else
//    {
//        mitbbsCell = [[MitbbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
//    }
    mitbbsCell.mitbbsTableViewCellDelegate = self;
    mitbbsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    mitbbsCell.headString = [_sectionText[@"classify"] objectAtIndex:indexPath.row][@"text"];
    //NSLog(@"section = %@",mitbbsCell.headString);
    mitbbsCell.mitClassifyUrl = [_sectionText[@"classify"] objectAtIndex:indexPath.row][@"url"];
    return mitbbsCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(void)didSelectRows
{
    SecondViewController *secondViewController = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:secondViewController animated:YES];
}

@end
