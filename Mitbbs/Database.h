//
//  Database.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-23.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ArticleList.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface Database : NSObject
{
    FMDatabase *mitbbsDatabase;
}

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;


-(NSString *)databasePath;
-(BOOL)openDatabase;
-(BOOL)insertDataToTable:(ArticleList *)article;
-(NSMutableArray *)getAllNewsData:(NSString *)menusNum and:(NSString *)categoryNum;
-(BOOL)isTableOK;
-(BOOL)createTable;

@end
