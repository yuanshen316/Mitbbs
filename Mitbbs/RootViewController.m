//
//  RootViewController.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-16.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "RootViewController.h"
#import "NewsInDetailViewController.h"
#import "ArticleList.h"
#import "TFHpple.h"

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
    //NSLog(@"sectionTitle = %@",sectionTitle[@"menustext"]);
	return sectionTitle[@"menustext"];
}
#pragma mark TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _categoryMessage = [_plistData objectAtIndex:_selectNum];
    //NSLog(@"categoryMessage = %@",_categoryMessage);
    return [_categoryMessage[@"classify"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    CategoryCell *mitbbsCell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:identity];
    
    NSMutableArray *categoryNew = [[NSMutableArray alloc] initWithCapacity:0];
    
    _mitDatabase = [[Database alloc] init];
    mitbbsCell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    mitbbsCell.CategoryCellDelegate = self;
    mitbbsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    mitbbsCell.headString = [_categoryMessage[@"classify"] objectAtIndex:indexPath.row][@"text"];//section的内容
    
    _categoryNews = [_mitDatabase getAllNewsData:[NSString stringWithFormat:@"%d",_selectNum] and:[NSString stringWithFormat:@"%d",indexPath.row]];
    if (_categoryNews.count == 0)
    {
        NSLog(@"数据库中没有数据");
        _categoryNews = [self newsData];
    }
    categoryNew = [self makeSureNewsForCategory:_categoryNews forRows:indexPath.row];
    mitbbsCell.newsData = categoryNew;//第indexPath.row个小类的全部新闻
    NSLog(@"RootViewController newdata = %@",mitbbsCell.newsData);
    return mitbbsCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(void)didSelectRows:(NSString *)url//点击cel进行页面跳转
{
    NewsInDetailViewController *newsInDetailView = [[NewsInDetailViewController alloc] initWithNibName:nil bundle:nil];
    newsInDetailView.newsUrl = url;
    [self.navigationController pushViewController:newsInDetailView animated:YES];
}

-(NSMutableArray *)newsData//当没有数据的时候，调用此方法来从网络获取数据
{
    NSMutableArray *newsListData = [[NSMutableArray alloc] init];
    _parser = [[ParserHtml alloc] init];
    _parser.menusID = [NSString stringWithFormat:@"%d",_selectNum];
    newsListData = [_parser selectMenusData:_categoryMessage];//获取所有无序的小分类数据
    ArticleList *ar = [[newsListData objectAtIndex:0] objectAtIndex:0];
    NSLog(@"ar.articleTitle = %@",ar.articelTitle);
    NSLog(@"ar.articleUrl = %@",ar.articelUrl);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self insertData:newsListData];
    });
    return newsListData;
}

-(void)insertData:(NSMutableArray *)newsData
{
    Database *mitDatabase = [[Database alloc] init];
    ArticleList *thisArticle = [[ArticleList alloc] init];
    [mitDatabase openDatabase];
    if (![mitDatabase isTableOK])
    {
        [mitDatabase createTable];
    }
    NSInteger categoryNum = newsData.count;
    NSLog(@"categoryNum = %d",categoryNum);
    for (int i = 0; i<categoryNum; i++)
    {
        NSMutableArray *categoryData = [newsData objectAtIndex:i];
        NSInteger newsNum = categoryData.count;
        NSLog(@"newsNum = %d",newsNum);
        for (int a = 0; a<newsNum; a++)
        {
            thisArticle = [categoryData objectAtIndex:a];
            //NSLog(@"thisArticleTitle = %@",thisArticle.articelTitle);
            [mitDatabase insertDataToTable:thisArticle];
        }
    }
}

-(NSMutableArray *)makeSureNewsForCategory:(NSMutableArray *)news forRows:(NSInteger)row
{
    ArticleList *article = [[ArticleList alloc] init];
    NSMutableArray *categoryData = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger categoryNum = news.count;
    for (int i = 0; i<categoryNum; i++)
    {
        NSMutableArray *categoryNews = [news objectAtIndex:i];
        article = [categoryNews objectAtIndex:0];
        if ([article.categoryId isEqualToString:[NSString stringWithFormat:@"%d",row]])
        {
            NSLog(@"articleTitle = %@",article.articelTitle);
            NSLog(@"CategoryId = %@",article.categoryId);
            NSLog(@"menusId = %@",article.menusId);
            NSLog(@"articleUrl = %@",article.articelUrl);
            [categoryData addObject:categoryNews];
        }
    }
    
    return categoryData;
}

@end
