//
//  Database.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-23.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "Database.h"
#import "FMDatabaseAdditions.h"

#define DATABASENAME @"database.sqlite"
#define TABLENAME    @"ListOfNews"
#define MENUSID      @"menusID"
#define CATEGORYID   @"categoryID"
#define NEWSTITLE    @"newsTitle"
#define NEWSURL      @"newsUrl"

@implementation Database

-(NSString *)databasePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDatabaseName = [path objectAtIndex:0];
    NSString *databasePath = [pathDatabaseName stringByAppendingPathComponent:DATABASENAME];
    //NSLog(@"databasePath = %@",databasePath);
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    return databasePath;
}

-(BOOL)openDatabase
{
    mitbbsDatabase = [FMDatabase databaseWithPath:[self databasePath]];
    if ([mitbbsDatabase open])
    {
        NSLog(@"数据库打开成功");
        return YES;
    }
    else
    {
        [mitbbsDatabase close];
        NSLog(@"数据库打开失败");
        return NO;
    }
}

-(BOOL)createTable
{
    if ([self openDatabase] == YES)
    {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ListOfNews (ID INTEGER PRIMARY KEY AUTOINCREMENT, menusID INTEGER, categoryID INTEGER, newsTitle TEXT, newsUrl TEXT)"];
        if ([mitbbsDatabase executeUpdateWithFormat:createTable] == YES)
        {
            NSLog(@"数据库表创建成功");
            return YES;
        }
        //NSString *CreateTableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, menusID INTEGER, categoryID INTEGER, newsTitle TEXT, newsUrl TEXT)",TABLENAME];
//        [self execSql:CreateTableSql];
//        return YES;
        else
        {
            [mitbbsDatabase close];
            NSLog(@"table create faild");
            return NO;
        }
    }
    return NO;
}

-(BOOL)insertDataToTable:(ArticleList *)article
{
    FMResultSet *rs = [mitbbsDatabase executeQuery:@"SELECT * FROM ListOfNews WHERE newsTitle = ?",article.articelTitle];
    if ([rs next])
    {
        BOOL update = [mitbbsDatabase executeUpdate:@"UPDATE ListOfNews SET menusID = ?, categoryID = ?, newsUrl = ? where newsTitle = ?", article.menusId, article.categoryId, article.articelUrl, article.articelTitle];
        if (update)
        {
            NSLog(@"数据修改成功");
            return YES;
        }
        NSLog(@"数据插入失败");
        return NO;
    }
    else
    {
        BOOL insert = [mitbbsDatabase executeUpdate:@"INSERT INTO ListOfNews (menusID, categoryID, newsTitle, newsUrl) VALUES (?, ?, ?, ?)", article.menusId, article.categoryId, article.articelTitle, article.articelUrl];
        if (insert) {
            NSLog(@"数据插入成功");
            return YES;
        }
        NSLog(@"数据插入失败");
        return NO;
    }
    NSLog(@"数据插入失败");
    return NO;
}

-(NSMutableArray *)getAllNewsData:(NSString *)menusNum and:(NSString *)categoryNum
{
     NSMutableArray *newsData = [[NSMutableArray alloc] init];
    [self openDatabase];
    if ([self isTableOK])
    {
        NSLog(@"表已存在,开始查询");
        FMResultSet *rs = [mitbbsDatabase executeQuery:@"SELECT * FROM ListOfNews"];
        while ([rs next])
        {
            
            ArticleList *article = [[ArticleList alloc] init];
            article.menusId      = [rs stringForColumn:MENUSID];
            article.categoryId   = [rs stringForColumn:CATEGORYID];
            article.articelTitle = [rs stringForColumn:NEWSTITLE];
            article.articelUrl   = [rs stringForColumn:NEWSURL];
            if ([menusNum isEqualToString: article.menusId] && [categoryNum isEqualToString: article.categoryId])
            {
                [newsData addObject:article];
            }
        }
        if (newsData.count == 0)
        {
            [mitbbsDatabase close];
            return NULL;
        }
        [mitbbsDatabase close];
        NSLog(@"newsData count = %d",newsData.count);
        return newsData;
    }
    [mitbbsDatabase close];
    return NULL;
}

-(BOOL)isTableOK
{
    FMResultSet*rs = [mitbbsDatabase executeQuery:@"SELECT * FROM ListOfNews"];
    if ([rs next])
    {
        NSLog(@"Table已经存在");
        return YES;
    }
    return NO;
}

@end
