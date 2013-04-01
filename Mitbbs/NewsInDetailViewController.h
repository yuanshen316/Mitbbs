//
//  NewsInDetailViewController.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-17.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsInDetailViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_newsTable;
}

@property (nonatomic, copy) NSString *newsUrl;
@property (nonatomic, strong) NSMutableArray *newsData;
@end
