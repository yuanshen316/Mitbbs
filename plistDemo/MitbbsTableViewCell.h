//
//  MitbbsTableViewCell.h
//  plistDemo
//
//  Created by Yuan Junsheng on 13-3-5.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutorial.h"

@interface MitbbsTableViewCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableViewCellTable;
    UILabel *_headLabel;
    NSMutableArray *_mitData;
    NSMutableArray *_newsData;
    NSInteger _selectRowNum;
}
@property (nonatomic, copy) NSString *headString;
@property (nonatomic, retain) NSString *mitClassifyUrl;
@property (nonatomic, assign) NSInteger selectRowsNum;

@end
