//
//  NewsInDetailCell.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-30.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsInDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *dateOfIssue;
@property (weak, nonatomic) IBOutlet UITextView *newsConteont;

@property (nonatomic, strong) NSDictionary *data;

@end
