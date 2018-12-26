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
@property (nonatomic, strong) UITextView *statusView;

@end


@implementation BabyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        
        //添加头像
        self.faceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _faceView.backgroundColor = [UIColor redColor];
        [self addSubview:_faceView];
        
        [RDFunction addRadiusToView:_faceView radius:CGRectGetWidth(_faceView.frame)/2];
        
        //添加列表
        self.listTable = [[RDTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _listTable.delegate = self;
        [self addSubview:_listTable];
        
        //添加状态头
        self.statusView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, CGRectGetWidth(_faceView.frame))];
        _statusView.backgroundColor = [UIColor grayColor];
        [_listTable setSection:0 headerView:_statusView footerView:nil];
        
        //把头像提到上层
        [self bringSubviewToFront:_faceView];
        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}




@end
