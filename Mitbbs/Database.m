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
         //[self openDatabase];
//    if (![self isTableOK])
//    {
//        [self createTable];
//    }
    FMResultSet *rs = [mitbbsDatabase executeQuery:@"SELECT * FROM ? WHERE ? = ?",TABLENAME,NEWSTITLE,article.articelTitle];
    if ([rs next])
    {
        [mitbbsDatabase executeUpdate:@"update ? set ? = ?, ? = ?, ? = ? where ? = ?",TABLENAME, MENUSID, article.menusId, CATEGORYID, article.categoryId, NEWSTITLE, article.articelTitle];
        NSLog(@"数据修改成功");
        return YES;
    }
    else
    {
        [mitbbsDatabase executeUpdate:@"INSERT INTO ? (?, ?, ?, ?) VALUES (?, ?, ?, ?)",TABLENAME, MENUSID, CATEGORYID, NEWSTITLE, NEWSURL, article.menusId, article.categoryId, article.articelTitle, article.articelUrl];
        NSLog(@"数据插入成功");
        return YES;
    }
    NSLog(@"数据插入失败");
    return NO;
//    if ([self openDatabase] == YES)
//    {
//        FMResultSet *rs = [mitbbsDatabase executeQuery:@"SELECT * FROM ? WHERE ? = ?",TABLENAME,NEWSTITLE,article.articelTitle];
//        if ([rs next])
//        {
//            [mitbbsDatabase executeUpdate:@"update ? set ? = ?, ? = ? where ? = ?",TABLENAME, MENUSID, article.menusId, CATEGORYID, article.categoryId, NEWSTITLE, article.articelTitle];
//            NSLog(@"数据修改成功");
//            return YES;
//        }
//        else
//        {
//            [mitbbsDatabase executeUpdate:@"INSERT INTO ? (?, ?, ?, ?) VALUES (?, ?, ?, ?)",TABLENAME, MENUSID, CATEGORYID, NEWSTITLE, NEWSURL, article.menusId, article.categoryId, article.articelTitle, article.articelUrl];
//            NSLog(@"数据插入成功");
//            return YES;
//        }
//        sqlite3_stmt *statement = NULL;
//        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@','%@','%@') VALUES ('%@', '%@', '%@','%@')",TABLENAME, MENUSID, CATEGORYID, NEWSTITLE, NEWSURL,article.menusId, article.categoryId, article.articelTitle, article.articelUrl];
//        [self execSql:insertSql];
//        int success = sqlite3_step(statement);
//        sqlite3_finalize(statement);
//        if (success == SQLITE_ERROR)
//        {
//            NSLog(@"Error:fail to insert into the database with message.");
//            return NO;
//        }
//        return YES;
//    }
//    else
//    {
//        NSLog(@"数据库打开失败");
//        return NO;
//    }
}

-(NSMutableArray *)getAllNewsData:(NSString *)menusNum and:(NSString *)categoryNum
{
     NSMutableArray *newsData = [[NSMutableArray alloc] init];
    [self openDatabase];
    if ([self isTableOK])
    {
        FMResultSet *rs = [mitbbsDatabase executeQuery:@"select * from ?",TABLENAME];
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
            return NULL;
        }
        return newsData;
    }
    return NULL;
//    if (!mitbbsDatabase)
//    {
//        [self openDatabase];
//    }
//    [mitbbsDatabase setShouldCacheStatements:YES];//设定存储，对效率有所帮助
//    if (![mitbbsDatabase tableExists:TABLENAME])
//    {
//        [self createTable];
//        return nil;
//    }
//    FMResultSet *rs = [mitbbsDatabase executeQuery:@"select * from ?",TABLENAME];
//    
//    while ([rs next])
//    {
//        ArticleList *article = [[ArticleList alloc] init];
//        article.menusId      = [rs stringForColumn:MENUSID];
//        article.categoryId   = [rs stringForColumn:CATEGORYID];
//        article.articelTitle = [rs stringForColumn:NEWSTITLE];
//        article.articelUrl   = [rs stringForColumn:NEWSURL];
//        [newsData addObject:article];
//    }
//    return newsData;
}

-(BOOL)isTableOK
{
    FMResultSet*rs = [mitbbsDatabase executeQuery:@"select * from ?",TABLENAME];
    if ([rs next])
    {
        NSLog(@"Table已经存在");
        return YES;
    }
    return NO;
}

@end
