//
//  NewsInDetailCell.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-30.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "NewsInDetailCell.h"
#import "TFHpple.h"

@implementation NewsInDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data
{
    self.categoryName.text = data[@"category"];
    _newsTitle.text    = data[@"title"];
    _author.text       = data[@"author"];
    _dateOfIssue.text  = data[@"time"];
    _newsConteont.text  = data[@"content"];
    _newsTitle.numberOfLines = 0;
    _author.numberOfLines = 0;
    _dateOfIssue.numberOfLines = 0;
    _newsConteont.editable = NO;
}


@end
