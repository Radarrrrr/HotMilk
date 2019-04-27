//
//  BabyView.m
//  HotMilk
//
//  Created by radar on 2018/12/27.
//  Copyright © 2018 radar. All rights reserved.
//

#import "BabyView.h"
#import "RecordInputView.h"


@interface BabyView () <RDTableViewDelegate>

@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) RDTableView *listTable;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIButton *aduButton;
@property (nonatomic, strong) UIButton *gaiButton;
@property (nonatomic, strong) UIButton *tieButton;
@property (nonatomic, strong) UIButton *bianButton;

@property (nonatomic, strong) UILabel *totalCountsLabel;

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
        self.statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 140)];
        _statusView.backgroundColor = [UIColor whiteColor];
        _listTable.tableView.tableHeaderView = _statusView;
        
        //添加头像
        self.faceView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 80, 80)];
        _faceView.backgroundColor = [UIColor blueColor];
        [_statusView addSubview:_faceView];
        
        [RDFunction addRadiusToView:_faceView radius:CGRectGetWidth(_faceView.frame)/2];
        
        
        //添加营养按钮
        float btnW = 34.0;
        float btnY = CGRectGetMaxY(_faceView.frame)+10;
        
        //添加AD按钮
        self.aduButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _aduButton.backgroundColor = [UIColor whiteColor];
        _aduButton.frame = CGRectMake(10, btnY, btnW, btnW);
        _aduButton.tag = 1000;
        
        _aduButton.titleLabel.font = FONT(15);
        [_aduButton setTitle:@"AD" forState:UIControlStateNormal];
        [_aduButton setTitleColor:COLOR_TEXT_C forState:UIControlStateNormal];
        
        [_aduButton setBackgroundImage:IMAGE(@"icon_star") forState:UIControlStateDisabled];
        [_aduButton addTarget:self action:@selector(funcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [RDFunction addRadiusToView:_aduButton radius:btnW/2];
        [RDFunction addBorderToView:_aduButton color:RGB(112, 200, 217) lineWidth:1];
        [_statusView addSubview:_aduButton];
        
    
        //添加钙按钮
        self.gaiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gaiButton.backgroundColor = [UIColor whiteColor];
        _gaiButton.frame = CGRectMake(CGRectGetMaxX(_aduButton.frame)+6, btnY, btnW, btnW);
        _gaiButton.tag = 1001;
        
        _gaiButton.titleLabel.font = FONT(15);
        [_gaiButton setTitle:@"钙" forState:UIControlStateNormal];
        [_gaiButton setTitleColor:COLOR_TEXT_C forState:UIControlStateNormal];
        
        [_gaiButton setBackgroundImage:IMAGE(@"icon_star") forState:UIControlStateDisabled];
        [_gaiButton addTarget:self action:@selector(funcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [RDFunction addRadiusToView:_gaiButton radius:btnW/2];
        [RDFunction addBorderToView:_gaiButton color:RGB(112, 200, 217) lineWidth:1];
        [_statusView addSubview:_gaiButton];
        
        
        //添加铁按钮
        self.tieButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tieButton.backgroundColor = [UIColor whiteColor];
        _tieButton.frame = CGRectMake(CGRectGetMaxX(_gaiButton.frame)+6, btnY, btnW, btnW);
        _tieButton.tag = 1002;
        
        _tieButton.titleLabel.font = FONT(15);
        [_tieButton setTitle:@"铁" forState:UIControlStateNormal];
        [_tieButton setTitleColor:COLOR_TEXT_C forState:UIControlStateNormal];
        
        [_tieButton setBackgroundImage:IMAGE(@"icon_star") forState:UIControlStateDisabled];
        [_tieButton addTarget:self action:@selector(funcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [RDFunction addRadiusToView:_tieButton radius:btnW/2];
        [RDFunction addBorderToView:_tieButton color:RGB(112, 200, 217) lineWidth:1];
        [_statusView addSubview:_tieButton];
        
        
        //添加便便按钮
        self.bianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bianButton.backgroundColor = [UIColor whiteColor];
        _bianButton.frame = CGRectMake(CGRectGetMaxX(_tieButton.frame)+6, btnY, btnW, btnW);
        _bianButton.tag = 1003;
        
        _bianButton.titleLabel.font = FONT(15);
        [_bianButton setTitle:@"便" forState:UIControlStateNormal];
        [_bianButton setTitleColor:COLOR_TEXT_C forState:UIControlStateNormal];
        
        [_bianButton setBackgroundImage:IMAGE(@"icon_star") forState:UIControlStateDisabled];
        [_bianButton addTarget:self action:@selector(funcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [RDFunction addRadiusToView:_bianButton radius:btnW/2];
        [RDFunction addBorderToView:_bianButton color:RGB(112, 200, 217) lineWidth:1];
        [_statusView addSubview:_bianButton];
        
        
        //添加总量label
        UIImageView *countsV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-60-50, 33, 50, 50)];
        countsV.image = [UIImage imageNamed:@"milk_back"];
        countsV.userInteractionEnabled = NO;
        [_statusView addSubview:countsV];
        
        self.totalCountsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(countsV.frame)+39, 58, 60, 28)];
        _totalCountsLabel.backgroundColor = [UIColor clearColor];
        _totalCountsLabel.textAlignment = NSTextAlignmentLeft;
        _totalCountsLabel.textColor = COLOR_TEXT_C;
        _totalCountsLabel.font = FONT_B(18);
        _totalCountsLabel.text = @"980";
        _totalCountsLabel.userInteractionEnabled = NO;
        [_statusView addSubview:_totalCountsLabel];
        
        
        
        //添加记录按钮
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake((frame.size.width-80)/2, frame.size.height-20-60, 80, 80);
        [_addBtn setImage:[UIImage imageNamed:@"btn_addrecord"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addRecordAction) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.alpha = 0.0;
        [self addSubview:_addBtn];
        

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //绘制头像
    if([_babyname isEqualToString:@"dot"])
    {
        _faceView.image = [UIImage imageNamed:@"face_dotbao"];
        _statusView.backgroundColor = RGB(226, 254, 234);
    }
    else if([_babyname isEqualToString:@"six"])
    {
        _faceView.image = [UIImage imageNamed:@"face_sixbao"];
        _statusView.backgroundColor = RGB(250, 255, 221);
    }
    
    //控制添加按钮的显示
    if(_isToday)
    {
        _addBtn.alpha = 1.0;
    }
    
    
    //后面都是根据_babyRecord来操作的内容，需要提前判断是否为空
    if(!DICTIONARYVALID(_babyRecord)) return;
    
    //添加牛奶数据
    NSArray *milks = [_babyRecord objectForKey:@"milk"];
    if(!ARRAYVALID(milks)) return;
    
    [_listTable appendDataArray:milks useCell:@"BabyMilkCell" toSection:0];
    [_listTable refreshTable:^{
        
    }];
    
    //计算总奶量
    [self calculateTotalCounts];
    
    //设定功能区按钮状态
    [self setFuncBtnStatus];
}

- (void)addRecordAction
{
    //呼叫添加记录浮层
    [[RecordInputView sharedInstance] callRecordInputForBaby:_babyname completion:^{
        
    }];
}

- (void)calculateTotalCounts
{
    //计算总奶量
    NSArray *counts = [RDFunction findValuesForKey:@"count" inData:_babyRecord];
    if(!ARRAYVALID(counts)) return;
    
    NSInteger total = 0;
    for(NSString *cont in counts)
    {
        total += cont.integerValue;
    }
    
    _totalCountsLabel.text = [NSString stringWithFormat:@"%ld", total];
}

- (void)setFuncBtnStatus
{
    //设定功能区按钮状态
    if(!DICTIONARYVALID(_babyRecord)) return;
    
    NSString *adStatus = [_babyRecord objectForKey:@"AD"];
    NSString *gaiStatus = [_babyRecord objectForKey:@"gai"];
    NSString *tieStatus = [_babyRecord objectForKey:@"tie"];
    NSString *bianStatus = [_babyRecord objectForKey:@"bian"];
    
    _aduButton.enabled = !(adStatus.boolValue);
    _gaiButton.enabled = !(gaiStatus.boolValue);
    _tieButton.enabled = !(tieStatus.boolValue);
    _bianButton.enabled = !(bianStatus.boolValue);
}

- (void)funcBtnAction:(UIButton*)btn
{
    switch (btn.tag) {
        case 1000:  //AD
            {
                _aduButton.enabled = NO;
                //TO DO: 改写记录中的AD状态为1，并保存数据库
                
            }
            break;
        case 1001:  //钙
        {
            _gaiButton.enabled = NO;
            //TO DO: 改写记录中钙状态为1，并保存数据库
        }
            break;
        case 1002:  //铁
        {
            _tieButton.enabled = NO;
            //TO DO: 改写记录中 铁状态为1，并保存数据库
        }
            break;
        case 1003:  //便便
        {
            _bianButton.enabled = NO;
            //TO DO: 改写记录中便便状态为1，并保存数据库
        }
            break;
        default:
            break;
    }
}


@end
