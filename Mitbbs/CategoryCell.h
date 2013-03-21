//
//  MitbbsTableViewCellCell.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-17.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleInformation.h"

@protocol CategoryCellDelegate;

@interface CategoryCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_CategoryCellTable;
    UILabel *_headLabel;
    NSMutableArray *_mitData;
    NSInteger _selectRowNum;
    id mitbbsTableViewCellDelegate;
}
@property (nonatomic, copy) NSString *headString;
@property (nonatomic, retain) NSString *mitClassifyUrl;
@property (nonatomic, assign) NSInteger selectRowsNum;
@property (nonatomic, strong) NSMutableDictionary *newsData;

@property (nonatomic, assign) id CategoryCellDelegate;
@end

@protocol CategoryCellDelegate <NSObject>

-(void)didSelectRows:(NSString *)url;

@end
