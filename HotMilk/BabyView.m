//
//  BabyView.m
//  HotMilk
//
//  Created by radar on 2018/12/27.
//  Copyright © 2018 radar. All rights reserved.
//

#import "BabyView.h"


@interface BabyView () <RDTableViewDelegate>

@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) RDTableView *listTable;
@property (nonatomic, strong) UIView *statusView;

@end


@implementation BabyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        
        //添加列表
        self.listTable = [[RDTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _listTable.delegate = self;
        _listTable.backgroundColor = [UIColor clearColor];
        _listTable.tableView.backgroundColor = [UIColor clearColor];
        _listTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_listTable];
        
        //添加状态头区域
        self.statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 120)];
        _statusView.backgroundColor = [UIColor whiteColor];
        //[_listTable setSection:0 headerView:_statusView footerView:nil];
        _listTable.tableView.tableHeaderView = _statusView;
        
        //添加头像
        self.faceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _faceView.backgroundColor = [UIColor blueColor];
        [_statusView addSubview:_faceView];
        
        [RDFunction addRadiusToView:_faceView radius:CGRectGetWidth(_faceView.frame)/2];
        
        //分割线
        //[HMFunction addDotLineToView:_statusView fromPoint:CGPointMake(15, CGRectGetHeight(_statusView.frame)) toPoint:CGPointMake(CGRectGetWidth(_statusView.frame)-30, CGRectGetHeight(_statusView.frame))];

//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(_statusView.frame), CGRectGetWidth(_statusView.frame)-30, 1)];
//        line.backgroundColor = COLOR_LINE_B;
//        [_statusView addSubview:line];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //绘制头像
    if([_babyname isEqualToString:@"diandian"])
    {
        _faceView.image = [UIImage imageNamed:@"face_dotbao"];
        _statusView.backgroundColor = RGB(226, 254, 234);
    }
    else if([_babyname isEqualToString:@"liuliu"])
    {
        _faceView.image = [UIImage imageNamed:@"face_sixbao"];
        _statusView.backgroundColor = RGB(250, 255, 221);
    }
    
    
    //添加牛奶数据
    NSArray *milks = [_babyRecord objectForKey:@"milk"];
    if(!ARRAYVALID(milks)) return;
    
    [_listTable appendDataArray:milks useCell:@"BabyMilkCell" toSection:0];
    [_listTable refreshTable:^{
        
    }];
    
}




@end
