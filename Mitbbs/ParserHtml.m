//
//  ParserHtml.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-20.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "ParserHtml.h"
#import "TFHpple.h"
#import "ArticleList.h"
#import "FMDatabaseQueue.h"

@implementation ParserHtml

-(void)parserHtml:(NSString *)categoryUrl forNum:(NSInteger)categoryNum
{
    NSString *Num = [NSString stringWithFormat:@"%d",categoryNum];
    
    NSURL *url = [NSURL URLWithString:categoryUrl];
    NSData *getHtmlDatas = [NSData dataWithContentsOfURL:url];
    
    TFHpple *getHtmlParser = [TFHpple hppleWithHTMLData:getHtmlDatas];
    NSString *getHtmlXpathQueryString = @"//td[@height=26]/strong/a";
    
    NSArray *getHtmlNodes = [getHtmlParser searchWithXPathQuery:getHtmlXpathQueryString];
    if (getHtmlNodes.count < 1)
    {
        NSLog(@"url = %@ 中有无法解析",url);
        return;
    }
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    _articleData = [NSMutableArray new];
    for (TFHppleElement *getHtmlElement in getHtmlNodes)
    {
        NSLog(@"getHtmlElement = %@",getHtmlElement);
        ArticleList *getHtmlData  = [[ArticleList alloc] init];
        getHtmlData.menusId       = _menusID;
        getHtmlData.categoryId    = Num;
        getHtmlData.articelTitle  = [[getHtmlElement firstChild] content];
        getHtmlData.articelUrl    = [getHtmlElement objectForKey:@"href"];
        NSLog(@"articelTitle = %@",getHtmlData.articelTitle);
        NSLog(@"articleUrl = %@",getHtmlData.articelUrl);
//        if (getHtmlData.articelTitle = NULL)
//        {
//            [self parserHtml:categoryUrl forNum:categoryNum];
//        }
        //getHtmlData.articelUrl    = [getHtmlElement objectForKey:@"href"];
//        [db insertDataToTable:getHtmlData];
        [newArray addObject:getHtmlData];
    }
    _articleData = newArray;
}



//-(NSMutableDictionary *)getData:(NSMutableDictionary *)dic
//{
//    NSMutableDictionary *articleData = [[NSMutableDictionary alloc] initWithCapacity:0];
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(concurrentQueue, ^(void)
//                   {
//                       NSString *url = dic[@"url"];
//                       [self getHtmlData:[NSURL URLWithString:url]];
//                       //NSLog(@"i = %@",_articleString);
//                       for (int i = 0; i<_articleString.count; i++)
//                       {
//                           
//                       dispatch_async(dispatch_get_main_queue(), ^(void)
//                            {
//                                NSString *keys = [NSString stringWithFormat:@"article%d",i];
//                                [articleData setObject:[_articleString objectAtIndex:i] forKey:keys];
//                            });
//                       }
//                   });
//    //NSLog(@"articelData = %@",articleData);
//    return articleData;
//}

-(NSMutableArray *)selectMenusData:(NSMutableDictionary *)dict
{
    NSInteger categoryCount = [dict[@"classify"] count];
    
    ArticleList *article = [[ArticleList alloc] init];

    NSMutableArray *newsList = [[NSMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (int sectionNum = 0; sectionNum < categoryCount; sectionNum ++)
    {
        dispatch_group_async(group, queue, ^
        {
            NSString *url = [dict[@"classify"] objectAtIndex:sectionNum][@"url"];
            [self parserHtml:url forNum:sectionNum];
            while (_articleData.count == 0)
            {
                [self parserHtml:url forNum:sectionNum];
            }
            [newsList addObject: _articleData];
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    article = [_articleData objectAtIndex:1];
    return newsList;
}

@end
