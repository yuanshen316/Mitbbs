//
//  RootViewController.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-16.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "FlickTableViewController.h"
#import "ParserHtml.h"
#import "CategoryCell.h"

@interface RootViewController : FlickTableViewController<UITableViewDataSource, UITableViewDelegate, CategoryCellDelegate>
{
    NSMutableArray *_plistData;
    NSDictionary *_categoryMessage;
    NSInteger _selectNum;
    UITableView *_tableViews;
}
@property (nonatomic, strong) NSMutableArray *categoryNews;
@property (nonatomic, strong) ParserHtml *parserHtml;
-(void)didSelectRows;
@end
