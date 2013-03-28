//
//  RootViewController.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-16.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "FlickTableViewController.h"
#import "CategoryCell.h"
#import "Database.h"
#import "ParserHtml.h"

@interface RootViewController : FlickTableViewController<UITableViewDataSource, UITableViewDelegate, CategoryCellDelegate>
{
    NSMutableArray *_plistData;
    NSMutableDictionary *_categoryMessage;
    NSInteger _selectNum;
    UITableView *_tableViews;
}
@property (nonatomic, strong) NSMutableArray *plistData;
@property (nonatomic, strong) NSMutableArray *categoryNews;
@property (nonatomic, strong) Database *mitDatabase;
@property (nonatomic, strong) ParserHtml *parser;
-(void)didSelectRows:(NSString *)url;
@end
