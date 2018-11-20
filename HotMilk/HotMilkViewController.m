//
//  HotMilkViewController.m
//  HotMilk
//
//  Created by radar on 2018/11/18.
//  Copyright © 2018年 radar. All rights reserved.
//

#import "HotMilkViewController.h"
#import "MoveableView.h"

#define HM_STATUS_BAR_HEIGHT (HM_IPHONEX_OR_LATER) ? 44.0f : 20.0f    //状态条高度
#define HM_IPHONEX_OR_LATER  [HotMilkViewController iPhoneXorLater]   //是否iPhoneX或者更高
#define HM_VIEW_HEIGHT       SCR_HEIGHT-(HM_STATUS_BAR_HEIGHT)-44     //可用区域高度

#define HM_NUTRITION_HEIGHT  44
#define HM_DIAPER_HEIGHT     60
#define HM_MILK_HEIGHT       200


@interface HotMilkViewController () <RDTableViewDelegate, MoveableViewDelegate>

//@property (nonatomic, strong) UIScrollView *contentScroll;

@property (nonatomic, strong) UIImageView *faceViewDot;        //头像区域
@property (nonatomic, strong) UIImageView *faceViewSix;        //头像区域

@property (nonatomic, strong) MoveableView *milkView;   //奶操作区
@property (nonatomic, strong) MoveableView *diaperView; //尿布操作区
@property (nonatomic, strong) MoveableView *nutritionView; //营养操作区
@property (nonatomic, strong) UIView *tipsView;   //状态提示区

@end

@implementation HotMilkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"HOT MILK";
    
    //添加头像区域
    self.faceViewDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH/2, SCR_WIDTH/2)];
    _faceViewDot.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_faceViewDot];
    
    self.faceViewSix = [[UIImageView alloc] initWithFrame:CGRectMake(SCR_WIDTH/2, 0, SCR_WIDTH/2, SCR_WIDTH/2)];
    _faceViewSix.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_faceViewSix];
    
    
    //添加营养操作区
    self.nutritionView = [[MoveableView alloc] initWithFrame:CGRectMake(0, HM_VIEW_HEIGHT-HM_NUTRITION_HEIGHT, SCR_WIDTH, HM_NUTRITION_HEIGHT)];
    _nutritionView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_nutritionView];
    
    
    //添加尿布操作区
    self.diaperView = [[MoveableView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_nutritionView.frame)-HM_DIAPER_HEIGHT, SCR_WIDTH, HM_DIAPER_HEIGHT)];
    _diaperView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_diaperView];
    
    //添加奶操作区
    self.milkView = [[MoveableView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_diaperView.frame)-HM_MILK_HEIGHT, SCR_WIDTH, HM_MILK_HEIGHT)];
    _milkView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_milkView];
    
    
    //添加状态提示区
    self.tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_faceViewDot.frame), SCR_WIDTH, CGRectGetMinY(_milkView.frame)-CGRectGetMaxY(_faceViewDot.frame))];
    _tipsView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_tipsView];
    
    
    
    
//    //添加主容器
//    self.contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT-(HM_STATUS_BAR_HEIGHT)-44)];
//    _contentScroll.pagingEnabled = YES;
//    _contentScroll.scrollEnabled = YES;
//    _contentScroll.contentSize = CGSizeMake(SCR_WIDTH*2, CGRectGetWidth(_contentScroll.frame));
//    [self.view addSubview:_contentScroll];
    
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT-(HM_STATUS_BAR_HEIGHT)-44)];
//    view1.backgroundColor = [UIColor redColor];
//    [_contentScroll addSubview:view1];
//    
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(SCR_WIDTH, 0, SCR_WIDTH, SCR_HEIGHT-(HM_STATUS_BAR_HEIGHT)-44)];
//    view2.backgroundColor = [UIColor grayColor];
//    [_contentScroll addSubview:view2];
        
    
    
    //添加主列表
//    RDTableView *table = [[RDTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
//    table.delegate = self;
//    table.tag = 1000;
//    table.loadMoreStyle = LoadMoreStyleLoading;
//    table.refreshStyle = RefreshStyleDropdown;
//    table.multiSelectEnabled = YES;
//    table.editRowEnabled = NO;
//    table.moveRowEnabled = NO;
}

+ (BOOL)iPhoneXorLater
{
    if([UIScreen instancesRespondToSelector:@selector(currentMode)])
    {
        float w = [[UIScreen mainScreen] currentMode].size.width;
        float h = [[UIScreen mainScreen] currentMode].size.height;
        float k = h/w; //屏幕高宽比
        
        if(k > 2) 
        {
            return YES;
        }
    }
    
    return NO;
}


@end
