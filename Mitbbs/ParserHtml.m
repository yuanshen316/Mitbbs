//
//  ParserHtml.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-20.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "ParserHtml.h"
#import "ArticleInformation.h"
#import "TFHpple.h"


@implementation ParserHtml

-(void)getHtmlData:(NSURL *)url
{
    NSData *getHtmlDatas = [NSData dataWithContentsOfURL:url];
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    NSString *getString = [NSString stringWithContentsOfURL:url encoding:enc error:nil];
    TFHpple *getHtmlParser = [TFHpple hppleWithHTMLData:getHtmlDatas];
    NSString *getHtmlXpathQueryString = @"//td[@height=26]/strong/a[@class='news1']";
    
    NSArray *getHtmlNodes = [getHtmlParser searchWithXPathQuery:getHtmlXpathQueryString];
    if (getHtmlNodes.count < 1)
    {
        NSLog(@"url = %@ 中有无法解析",url);
        return;
    }
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *getHtmlElement in getHtmlNodes)
    {
        ArticleInformation *getHtmlData = [[ArticleInformation alloc] init];
        [newArray addObject:getHtmlData];
        getHtmlData.title = [[getHtmlElement firstChild] content];
        getHtmlData.url   = [getHtmlElement objectForKey:@"href"];
    }
    _articleString = newArray;
    
}

-(NSMutableDictionary *)getData:(NSMutableDictionary *)dic
{
    NSMutableDictionary *articleData = [[NSMutableDictionary alloc] initWithCapacity:0];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^(void)
                   {
                       NSString *url = dic[@"url"];
                       [self getHtmlData:[NSURL URLWithString:url]];
                       //NSLog(@"i = %@",_articleString);
                       for (int i = 0; i<_articleString.count; i++)
                       {
                           
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                NSString *keys = [NSString stringWithFormat:@"article%d",i];
                                [articleData setObject:[_articleString objectAtIndex:i] forKey:keys];
                            });
                       }
                   });
    //NSLog(@"articelData = %@",articleData);
    return articleData;
}

-(NSMutableArray *)data
{
    NSInteger categoryCount = _categoryData.count;
    for (int i = 0; i<categoryCount; i++)
    {
        _newsListString = [self getData : [_categoryData objectAtIndex:i]];
        [_newsData addObject:_newsListString];
    }
    //NSLog(@"newsData = %@",_newsData);
    return _newsData;
}

@end
