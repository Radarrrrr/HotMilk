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


@end



@implementation HotMilkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBS(220);
    self.navigationItem.title = @"HOT MILK";
    

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

- (UIView*)createTwinsViewForData:(NSDictionary*)data atIndex:(NSInteger)index
{
    //创建临时的双胞胎页面
    UIView *twinsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentScroll.frame), CGRectGetHeight(_contentScroll.frame))];
    
    if(index%2 == 0)
    {
        twinsView.backgroundColor = RGBS(250);
    }
    else
    {
        twinsView.backgroundColor = RGBS(240);
    }
    
    BabyView *dotView = [[BabyView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(twinsView.frame)/2, CGRectGetHeight(twinsView.frame))];
    [twinsView addSubview:dotView];
    
    BabyView *sixView = [[BabyView alloc] initWithFrame:CGRectMake(CGRectGetWidth(twinsView.frame)/2, 0, CGRectGetWidth(twinsView.frame)/2, CGRectGetHeight(twinsView.frame))];
    [twinsView addSubview:sixView];
        
    
    //中线
    [HMFunction addDotLineToView:twinsView fromPoint:CGPointMake(twinsView.center.x, 0) toPoint:CGPointMake(twinsView.center.x, CGRectGetHeight(twinsView.frame))];
    
    
    return twinsView;
}



#pragma mark - 主容器相关方法
//DDPageScrollViewDataSource
- (NSInteger)numberOfPagesInPageScrollView:(DDPageScrollView*)pageScrollView
{
    return 2;
}
- (UIView*)pageScrollView:(DDPageScrollView*)pageScrollView viewForPageAtIndex:(NSInteger)pageIndex
{
    //测试数据
    NSArray *datas =  @[
                         @{
                             @"date":@"2019-04-24",
                             @"record":@{
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
                             },
                             @{
                                 @"date":@"2019-04-25",
                                 @"record":@{
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
    
    
    NSDictionary *data = [datas objectAtIndex:pageIndex];
    
    UIView *twinsView = [self createTwinsViewForData:data atIndex:pageIndex];
    //if(pageIndex == 0) twinsView.backgroundColor = [UIColor grayColor];
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
