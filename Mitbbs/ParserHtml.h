//
//  ParserHtml.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-20.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ParserHtml : NSObject

@property (nonatomic, strong) NSMutableArray *articleString;
@property (nonatomic, strong) NSMutableArray *categoryData;//小分类信息
@property (nonatomic, strong) NSMutableArray *newsData;
@property (nonatomic, strong) NSMutableDictionary *newsListString;

-(NSMutableArray *)data;
@end
