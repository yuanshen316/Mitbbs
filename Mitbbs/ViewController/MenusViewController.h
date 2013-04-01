//
//  MenusViewController.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-31.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenusViewController : UITableViewController
{
    UITableView *menusTable;
}

@property (strong, nonatomic) NSArray *menus;

@end
