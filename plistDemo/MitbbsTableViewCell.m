//
//  MitbbsTableViewCell.m
//  plistDemo
//
//  Created by Yuan Junsheng on 13-3-5.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "MitbbsTableViewCell.h"
#import "TFHpple.h"
#import "SecondViewController.h"
//#import "CellsTableViewCell.h"

@implementation MitbbsTableViewCell
@synthesize mitbbsTableViewCellDelegate = _mitbbsTableViewCellDelegate;

-(void)getHtmlData:(NSURL *)url
{
    NSData *getHtmlDatas = [NSData dataWithContentsOfURL:url];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *htmlData = [[NSString alloc] initWithData:getHtmlDatas encoding:enc];
//    NSData *newHtmlDataWithUTF8 = [htmlData dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"newHtmlDataWithUTF8 = %@",newHtmlDataWithUTF8);
    TFHpple *getHtmlParser = [TFHpple hppleWithHTMLData:getHtmlDatas];
    NSString *getHtmlXpathQueryString = @"//a[@class='news1']";
    
    NSArray *getHtmlNodes = [getHtmlParser searchWithXPathQuery:getHtmlXpathQueryString];
    NSLog(@"getHtmlNodes = %@",getHtmlNodes);
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *getHtmlElement in getHtmlNodes)
    {
        ArticleInformation *getHtmlData = [[ArticleInformation alloc] init];
        [newArray addObject:getHtmlData];
        
        getHtmlData.title = [[getHtmlElement firstChild] content];
        getHtmlData.url   = [getHtmlElement objectForKey:@"href"];
    }
    _mitData = newArray;
    [_tableViewCellTable reloadData];
}

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
        //_headLabel.backgroundColor = [UIColor clearColor];
        _headLabel.textColor = [UIColor whiteColor];
        //_headLabel.contentMode = UIViewContentModeLeft;
        _headLabel.contentMode = UIViewContentModeScaleToFill;
        [image addSubview:_headLabel];
        
        _tableViewCellTable = [[UITableView alloc] initWithFrame:CGRectMake(110, -75, 110, 320) style:UITableViewStylePlain];
        _tableViewCellTable.delegate = self;
        _tableViewCellTable.dataSource = self;
        _tableViewCellTable.showsHorizontalScrollIndicator = NO;
        _tableViewCellTable.showsVerticalScrollIndicator = NO;
        _tableViewCellTable.transform = CGAffineTransformMakeRotation(M_PI / 2 * 3);
        
        [self addSubview:image];
        [self addSubview:_tableViewCellTable];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
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
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^(void)
                   {
                       [self getHtmlData:[NSURL URLWithString:_mitClassifyUrl]];
                       ArticleInformation *thisArticleInformation = [_mitData objectAtIndex:indexPath.row];
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          NSString *titleText = [thisArticleInformation.title stringByReplacingOccurrencesOfString:@"●" withString:@""];
                                          cell.textLabel.text = titleText;
                                      });
                   });
    //cell.newsUrl = _mitClassifyUrl;
//    [[cell textLabel] setText:thisTutorial.title];
    cell.textLabel.numberOfLines = 0;//相当于无行数限制
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectRowNum = [indexPath row];
    NSLog(@"点击%d",_selectRowNum);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_mitbbsTableViewCellDelegate didSelectRows];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
