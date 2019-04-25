//
//  BabyMilkCell.m
//  HotMilk
//
//  Created by radar on 2018/12/27.
//  Copyright © 2018 radar. All rights reserved.
//

#import "BabyMilkCell.h"


@interface BabyMilkCell ()

@property (nonatomic, strong) UILabel *tLabel;
@property (nonatomic, strong) UILabel *cLabel;

@end


@implementation BabyMilkCell

#pragma mark - 复写下面两个方法
- (void)setCellStyle
{
    //设定cell的样式，所有的组件都放在 self.contentView 上面，做成全局变量，用以支持 setCellData 里边来修改组件的数值
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //add _tLabel
    self.tLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, 40)];
    _tLabel.backgroundColor = [UIColor clearColor];
    _tLabel.textAlignment = NSTextAlignmentLeft;
    _tLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _tLabel.textColor = COLOR_TEXT_A;
    [self.contentView addSubview:_tLabel];
    
    //add _cLabel
    self.cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH/2-25, 40)];
    _cLabel.backgroundColor = [UIColor clearColor];
    _cLabel.textAlignment = NSTextAlignmentRight;
    _cLabel.font = [UIFont boldSystemFontOfSize:14.0];
    _cLabel.textColor = COLOR_TEXT_B;
    [self.contentView addSubview:_cLabel];
    
    //add line
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCR_WIDTH/2-20, 2)];
//    line.backgroundColor = COLOR_LINE_B;
//    [self.contentView addSubview:line];
}

-(NSNumber*)setCellData:(id)data atIndexPath:(NSIndexPath*)indexPath
{
    //@{@"time":@"9:00", @"count":@"110ml"}
    //根据data设定cell上组件的属性，并返回计算以后的cell高度, 用number类型装进去，[重要]cell高度必须要做计算并返回，如果返回nil就使用默认的44高度了
    
    if(!DICTIONARYVALID(data)) return nil;
    
    NSDictionary *milkDic = (NSDictionary*)data;
    _tLabel.text = [milkDic objectForKey:@"time"];
    _cLabel.text = [milkDic objectForKey:@"count"];
    
    return [NSNumber numberWithFloat:44.0];
}


@end
