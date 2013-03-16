//
//  MitbbsTableViewCell.h
//  plistDemo
//
//  Created by Yuan Junsheng on 13-3-5.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleInformation.h"

@protocol MitbbsTableViewCellDelegate;

@interface MitbbsTableViewCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableViewCellTable;
    UILabel *_headLabel;
    NSMutableArray *_mitData;
    NSMutableArray *_newsData;
    NSInteger _selectRowNum;
    id mitbbsTableViewCellDelegate;
}
@property (nonatomic, copy) NSString *headString;
@property (nonatomic, retain) NSString *mitClassifyUrl;
@property (nonatomic, assign) NSInteger selectRowsNum;

@property (nonatomic, assign) id mitbbsTableViewCellDelegate;
@end

@protocol MitbbsTableViewCellDelegate <NSObject>

-(void)didSelectRows;

@end