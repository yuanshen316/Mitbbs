//
//  NewsInDetailViewController.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-17.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "NewsInDetailViewController.h"
#import "TFHpple.h"
#import "ArticleInformation.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNewsData:(NSString *)url
{
    NSData *newsData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    TFHpple *newsHtmlParser = [TFHpple hppleWithHTMLData:newsData];
    NSString *htmlXpathQueryString = @"";
    NSArray *newsHtmlNodes = [newsHtmlParser searchWithXPathQuery:htmlXpathQueryString];
    if (newsHtmlNodes.count < 1)
    {
        NSLog(@"url = %@ 中有无法解析",url);
        return;
    }
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *newsElement in newsHtmlNodes)
    {
        ArticleInformation *thisArticle = [[ArticleInformation alloc] init];
        [newArray addObject:thisArticle];
        thisArticle.title = [[newsElement firstChild] content];
    }
    _newsData = newArray;
}

@end
