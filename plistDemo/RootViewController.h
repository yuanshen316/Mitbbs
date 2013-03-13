//
//  RootViewController.h
//  plistDemo
//
//  Created by Yuan Junsheng on 13-2-26.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "FlickTableViewController.h"


@interface RootViewController : FlickTableViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_plistData;
    NSDictionary *_sectionText;
    NSInteger _selectNum;
    UITableView *_tableViews;
    NSInteger _mitbbsTableCellRowNum;
}


@end
