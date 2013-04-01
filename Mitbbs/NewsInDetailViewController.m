//
//  NewsInDetailViewController.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-17.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "NewsInDetailViewController.h"
#import "TFHpple.h"
#import "NewsInDetailCell.h"

#define MITURL @"http://www.mitbbs.com"

@interface NewsInDetailViewController ()

@end

@implementation NewsInDetailViewController

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
    _newsData = [self parserNewsPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"RowCount = %d",_newsData.count);
    return _newsData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    NewsInDetailCell *cell = (NewsInDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:@"NewsInDetail" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentify];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    }
    cell.data = [_newsData objectAtIndex:indexPath.row];

    return cell;
}

-(NSMutableArray *)parserNewsPage
{
    NSMutableArray *newsDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *newsUrlString = [MITURL stringByAppendingString:_newsUrl];
    NSURL *url = [NSURL URLWithString:newsUrlString];
    NSData *getHtmlPage = [NSData dataWithContentsOfURL:url];
    
    TFHpple *newsHtmlParser = [TFHpple hppleWithHTMLData:getHtmlPage];
    NSArray *newsElement = [newsHtmlParser searchWithXPathQuery:@"//td[@class='jiawenzhang-type']/p"];
    for (TFHppleElement *newsHtmlElement in newsElement)
    {
        NSArray *nameAndCategory = [[[newsHtmlElement firstChild] content] componentsSeparatedByString:@", "];
        NSString *authorName = [nameAndCategory objectAtIndex:0];
        NSString *category = [nameAndCategory objectAtIndex:1];
        NSArray *newsArray = [newsHtmlElement children];
        NSLog(@"newsContenta = %@",newsArray);
        
        NSString *newsTitle = [[newsArray objectAtIndex:2] content];
        NSString *newsTime = [[newsArray objectAtIndex:4] content];
        
        NSInteger newsContentCount = newsArray.count;
        NSString *newsContent = [[NSString alloc] init];
        for (int i = 7; i<newsContentCount; i++)
        {
            NSString *newsConte = [[newsArray objectAtIndex:i] content];
            if (newsConte == NULL)
            {
                newsConte = @"\n";
            }
            
            newsContent = [newsContent stringByAppendingFormat:@"%@",newsConte];
        }
        NSMutableDictionary *newsData = [[NSMutableDictionary alloc] init];
        [newsData setObject:authorName forKey:@"author"];
        [newsData setObject:category forKey:@"category"];
        [newsData setObject:newsTitle forKey:@"title"];
        [newsData setObject:newsTime forKey:@"time"];
        [newsData setObject:newsContent forKey:@"content"];
        [newsDataArray addObject:newsData];
    }
    return newsDataArray;
}

@end
