//
//  MitbbsTableViewCellCell.m
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-17.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import "CategoryCell.h"
#import "TFHpple.h"

@implementation CategoryCell

@synthesize CategoryCellDelegate = _CategoryCellDelegate;

//-(void)getHtmlData:(NSURL *)url
//{
//    NSData *getHtmlDatas = [NSData dataWithContentsOfURL:url];
////    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
////    NSString *getString = [NSString stringWithContentsOfURL:url encoding:enc error:nil];
//    TFHpple *getHtmlParser = [TFHpple hppleWithHTMLData:getHtmlDatas];
//    NSString *getHtmlXpathQueryString = @"//td[@height=26]/strong/a[@class='news1']";
//    
//    NSArray *getHtmlNodes = [getHtmlParser searchWithXPathQuery:getHtmlXpathQueryString];
//    if (getHtmlNodes.count < 1)
//    {
//        NSLog(@"url = %@ 中有无法解析",url);
//        return;
//    }
//    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
//    for (TFHppleElement *getHtmlElement in getHtmlNodes)
//    {
//        ArticleInformation *getHtmlData = [[ArticleInformation alloc] init];
//        [newArray addObject:getHtmlData];
//        getHtmlData.title = [[getHtmlElement firstChild] content];
//        getHtmlData.url   = [getHtmlElement objectForKey:@"href"];
//    }
//    _mitData = newArray;
//    [_tableViewCellTable reloadData];
//}

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
    NSString *keys = [NSString stringWithFormat:@"article%d",indexPath.row];
    ArticleInformation *thisArticleInformation = _newsData[keys];
    //NSLog(@"thisarticleinformation = %@",thisArticleInformation);
    //ArticleInformation *thisArticleInformation = _newsData[keys];
                       //[self getHtmlData:[NSURL URLWithString:_mitClassifyUrl]];
    NSString *titleText = (NSString *)[thisArticleInformation.title substringFromIndex:1];
    cell.textLabel.text = titleText;
    //NSLog(@"titleText = %@",titleText);
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
    ArticleInformation *thisArticleInformation = [_mitData objectAtIndex:_selectRowNum];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_CategoryCellDelegate didSelectRows:thisArticleInformation.url];
}

@end
