//
//  HotMilkViewController.m
//  HotMilk
//
//  Created by radar on 2018/11/18.
//  Copyright © 2018年 radar. All rights reserved.
//

#import "HotMilkViewController.h"
#import "MoveableView.h"
#import "BabyView.h"

#define HM_STATUS_BAR_HEIGHT (HM_IPHONEX_OR_LATER) ? 44.0f : 20.0f    //状态条高度
#define HM_IPHONEX_OR_LATER  [HotMilkViewController iPhoneXorLater]   //是否iPhoneX或者更高
#define HM_VIEW_HEIGHT       SCR_HEIGHT-(HM_STATUS_BAR_HEIGHT)-44     //可用区域高度

#define HM_NUTRITION_HEIGHT  44
#define HM_DIAPER_HEIGHT     60
#define HM_MILK_HEIGHT       200


@interface HotMilkViewController () <RDTableViewDelegate, MoveableViewDelegate>

@property (nonatomic, strong) DDPageScrollView *contentScroll;
@property (nonatomic, strong) NSMutableArray *babyRecords;


@end



@implementation HotMilkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBS(220);
    self.navigationItem.title = @"HOT MILK";
    
    self.babyRecords = [[NSMutableArray alloc] init];
    

    //添加主容器
    self.contentScroll = [[DDPageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT-(HM_STATUS_BAR_HEIGHT)-44)];
    _contentScroll.backgroundColor = [UIColor clearColor]; //PS:如果设定bPageRoundRect=YES, 则backgroundColor必须为clearColor
    _contentScroll.delegate = self;
    _contentScroll.dataSource = self;
    
    _contentScroll.zoomEnabled = NO;
    _contentScroll.pageCtrlEnabled = YES;
    _contentScroll.pcBackEnabled = YES;
    _contentScroll.circleEnabled = NO;
    _contentScroll.ingoreMemory = NO;
    _contentScroll.loadingStyle = DDPageScrollLoadingStylePreLoading;
        
    [self.view addSubview:_contentScroll];
    
    
    //初始化数据
    [self loadBabyRecords];
   
    
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


- (void)loadBabyRecords
{
    //从数据库读取baby记录数据
    //测试数据
    NSArray *records =  @[
                        @{
                            @"date":@"2019-04-25",
                            @"data":@{
                                    @"dot":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"}
                                                    ]
                                            }
                                    }
                            },
                        @{
                            @"date":@"2019-04-24",
                            @"data":@{
                                    @"dot":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"8:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"8:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"}
                                                    ]
                                            }
                                    }
                            },
                        @{
                            @"date":@"2019-04-23",
                            @"data":@{
                                    @"dot":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"},
                                                    @{@"time":@"9:00", @"count":@"110ml"}
                                                    ]
                                            }
                                    }
                            }
                        ];
    
    [_babyRecords addObjectsFromArray:records];    
    
}


- (UIView*)createTwinsViewForRecord:(NSDictionary*)record atPageIndex:(NSInteger)pageIndex
{
    if(!record) return nil;
    
    //创建临时的双胞胎页面
    UIView *twinsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentScroll.frame), CGRectGetHeight(_contentScroll.frame))];
    
    if(pageIndex%2 == 0)
    {
        twinsView.backgroundColor = RGBS(250);
    }
    else
    {
        twinsView.backgroundColor = RGBS(240);
    }
    
    BabyView *dotView = [[BabyView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(twinsView.frame)/2, CGRectGetHeight(twinsView.frame))];
    dotView.babyname = @"diandian";
    dotView.babyRecord = [RDFunction valueOfData:record byPath:@"data.dot"];
    [twinsView addSubview:dotView];
    
    BabyView *sixView = [[BabyView alloc] initWithFrame:CGRectMake(CGRectGetWidth(twinsView.frame)/2, 0, CGRectGetWidth(twinsView.frame)/2, CGRectGetHeight(twinsView.frame))];
    sixView.babyname = @"liuliu";
    sixView.babyRecord = [RDFunction valueOfData:record byPath:@"data.six"];
    [twinsView addSubview:sixView];
        
    
    //中线
    [HMFunction addDotLineToView:twinsView fromPoint:CGPointMake(twinsView.center.x, 130) toPoint:CGPointMake(twinsView.center.x, CGRectGetHeight(twinsView.frame)-30)];
    
    
    return twinsView;
}



#pragma mark - 主容器相关方法
//DDPageScrollViewDataSource
- (NSInteger)numberOfPagesInPageScrollView:(DDPageScrollView*)pageScrollView
{
    return [_babyRecords count];
}
- (UIView*)pageScrollView:(DDPageScrollView*)pageScrollView viewForPageAtIndex:(NSInteger)pageIndex
{
    NSInteger recordIndex = _babyRecords.count -1 - pageIndex;
    NSDictionary *record = [_babyRecords objectAtIndex:recordIndex];
    
    UIView *twinsView = [self createTwinsViewForRecord:record atPageIndex:pageIndex];
    
    return twinsView;
}

//DDPageScrollViewDelegate
- (void)ddPageScrollViewDidChangeToPageIndex:(DDPageScrollView*)pageScrollView pageIndex:(NSInteger)index;
{
    NSLog(@"page changed to index: %ld", index);
    NSInteger  curPageIndex = [pageScrollView currentPageIndex];
    NSLog(@"当前获取到的页面index: %ld", curPageIndex);
}
- (void)ddPageScrollViewOverFirstPage:(DDPageScrollView*)pageScrollView
{
}
- (void)ddPageScrollViewOverLastPage:(DDPageScrollView*)pageScrollView
{
}




@end
