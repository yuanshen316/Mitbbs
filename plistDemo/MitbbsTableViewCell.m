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

@implementation MitbbsTableViewCell

-(NSMutableArray *)getHtmlData:(NSURL *)url
{
    NSData *getHtmlDatas = [NSData dataWithContentsOfURL:url];
    TFHpple *getHtmlParser = [TFHpple hppleWithHTMLData:getHtmlDatas];
    NSString *getHtmlXpathQueryString = @"//a[@class='news1']";
    
    NSArray *getHtmlNodes = [getHtmlParser searchWithXPathQuery:getHtmlXpathQueryString];
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *getHtmlElement in getHtmlNodes)
    {
        Tutorial *tutorial = [[Tutorial alloc] init];
        [newArray addObject:tutorial];
        
        tutorial.title = [[getHtmlElement firstChild] content];
        tutorial.url   = [getHtmlElement objectForKey:@"href"];
    }
    return newArray;
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
    return 20;
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
    _mitData = [self getHtmlData:[NSURL URLWithString:_mitClassifyUrl]];
    Tutorial *thisTutorial = [_mitData objectAtIndex:indexPath.row];
    [[cell textLabel] setText:thisTutorial.title];
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
    SecondViewController *secondView = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:secondViewController animated:YES completion:^(void){}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
