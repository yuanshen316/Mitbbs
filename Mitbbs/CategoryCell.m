//
//  MitbbsTableViewCellCell.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-17.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize CategoryCellDelegate = _CategoryCellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        image.backgroundColor = [UIColor clearColor];
        image.image = [UIImage imageNamed:@"cancel-button-background.png"];
        
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 25)];
        _headLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pagecornerlarge-prefs.png"]];
        _headLabel.textColor = [UIColor whiteColor];
        _headLabel.contentMode = UIViewContentModeScaleToFill;
        [image addSubview:_headLabel];
        
        _CategoryCellTable = [[UITableView alloc] initWithFrame:CGRectMake(110, -75, 110, 320) style:UITableViewStylePlain];
        _CategoryCellTable.delegate = self;
        _CategoryCellTable.dataSource = self;
        _CategoryCellTable.showsHorizontalScrollIndicator = NO;
        _CategoryCellTable.showsVerticalScrollIndicator = NO;
        _CategoryCellTable.transform = CGAffineTransformMakeRotation(M_PI / 2 * 3);
        
        [self addSubview:image];
        [self addSubview:_CategoryCellTable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
        _headLabel.text = _headString;
    }
    _article = [[ArticleList alloc] init];
    _article = [_newsData objectAtIndex:indexPath.row];
    NSLog(@"当前cell中的新闻 = %@",[_newsData objectAtIndex:indexPath.row]);
    NSString *titleName = (NSString *)_article.articelTitle;
    if (titleName == NULL)
    {
        cell.textLabel.text = NULL;
    }
    else
    {
        NSString *titleText = [titleName substringFromIndex:1];
        cell.textLabel.text = titleText;
    }
    
    cell.textLabel.numberOfLines = 0;//相当于无行数限制
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectRowNum = [indexPath row];
    NSLog(@"点击%d",_selectRowNum);
    ArticleList *thisArticle = [_newsData objectAtIndex:_selectRowNum];
    NSLog(@"thisArticle = %@",thisArticle.articelUrl);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_CategoryCellDelegate didSelectRows:thisArticle.articelUrl];
}

@end
