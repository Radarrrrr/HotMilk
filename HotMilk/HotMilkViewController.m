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
@property (nonatomic, strong) UILabel *dateLabel;

@end



@implementation HotMilkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBS(220);
    self.navigationItem.title = @"HOT MILK";

    self.babyRecords = [[NSMutableArray alloc] init];
    
    //左上角日期
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont boldSystemFontOfSize:13.0];
    _dateLabel.textColor = [UIColor whiteColor];
    
    UIBarButtonItem *dateItem = [[UIBarButtonItem alloc] initWithCustomView:_dateLabel];
    self.navigationItem.rightBarButtonItem = dateItem;
    
    //右上角设置
    

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
    
    //改变右上角日期
    [self changeDateForPageIndex:_babyRecords.count-1];
    
    
    //---test
    [[RDFMDBAgent sharedAgent] createSQLiteByName:@"babys.sqlite"];
    [[RDFMDBAgent sharedAgent] openSQLite:@"babys.sqlite"];
    
    [[RDFMDBAgent sharedAgent] createTableInSQLite:@"babys.sqlite" 
                                         tableName:@"dotbaby_records" 
                                           columns:@"day text not null",  //2019-05-09  
                                                   @"time text not null", //07:30
                                                   @"count integer",      //100 / 1 / 0 
                                                   @"type text not null", //milk / AD / gai / tie o/ bian
                                                   nil];
    
    [[RDFMDBAgent sharedAgent] createTableInSQLite:@"babys.sqlite" 
                                         tableName:@"sixbaby_records" 
                                           columns:@"day text not null",  //2019-05-09  
                                                   @"time text not null", //07:30
                                                   @"count integer",      //100 / 1 / 0 
                                                   @"type text not null", //milk / AD / gai / tie o/ bian
                                                   nil];

    //---------
    
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

- (void)changeDateForPageIndex:(NSInteger)pageIndex
{
    NSDictionary *record = [self recordForPageIndex:pageIndex];
    if(!DICTIONARYVALID(record)) return;
    
    NSString *dateStr = [record objectForKey:@"date"];
    
    NSDate *date = [RDFunction dateFromString:dateStr useFormat:@"yyyy-MM-dd"];
    NSString *showDate = [RDFunction stringFromDate:date useFormat:@"MM月dd日"];
        
    if([self checkRecordIsToday:record])
    {
        showDate = [showDate stringByAppendingString:@"(今天)"];
    }
    
    _dateLabel.text = showDate;
}

- (BOOL)checkRecordIsToday:(NSDictionary*)record
{
    if(!record) return NO;
    
    NSString *dateStr       = [record objectForKey:@"date"];
    NSString *todayDateStr  = [RDFunction stringFromDate:[NSDate date] useFormat:@"yyyy-MM-dd"];
    
    if([todayDateStr isEqualToString:dateStr])
    {
        return YES;
    }
    
    return NO;
}

- (void)loadBabyRecords
{
    //从数据库读取baby记录数据
    //测试数据
    NSArray *records =  @[
                          @{
                              @"date":@"2019-04-29",
                              @"data":@{
                                      @"dot":@{
                                              @"AD":@"1",
                                              @"gai":@"1",
                                              @"tie":@"0",
                                              @"bian":@"1",
                                              @"milk":@[
                                                      @{@"time":@"7:00", @"count":@"60"},
                                                      @{@"time":@"9:00", @"count":@"110"},
                                                      @{@"time":@"9:00", @"count":@"80"},
                                                      @{@"time":@"9:00", @"count":@"90"},
                                                      @{@"time":@"9:00", @"count":@"110"},
                                                      @{@"time":@"9:00", @"count":@"70"}
                                                      ]
                                              },
                                      @"six":@{
                                              @"AD":@"1",
                                              @"gai":@"1",
                                              @"tie":@"0",
                                              @"bian":@"0",
                                              @"milk":@[
                                                      @{@"time":@"7:00", @"count":@"70"},
                                                      @{@"time":@"9:00", @"count":@"90"},
                                                      @{@"time":@"9:00", @"count":@"110"},
                                                      @{@"time":@"9:00", @"count":@"105"},
                                                      @{@"time":@"9:00", @"count":@"60"},
                                                      @{@"time":@"9:00", @"count":@"80"}
                                                      ]
                                              }
                                      }
                            },
                        @{
                            @"date":@"2019-04-27",
                            @"data":@{
                                    @"dot":@{
                                            @"AD":@"1",
                                            @"gai":@"0",
                                            @"tie":@"1",
                                            @"bian":@"0",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"0",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            }
                                    }
                            },
                        @{
                            @"date":@"2019-04-26",
                            @"data":@{
                                    @"dot":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            }
                                    }
                            },
                        @{
                            @"date":@"2019-04-25",
                            @"data":@{
                                    @"dot":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
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
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
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
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            },
                                    @"six":@{
                                            @"AD":@"1",
                                            @"gai":@"1",
                                            @"tie":@"1",
                                            @"bian":@"1",
                                            @"milk":@[
                                                    @{@"time":@"7:00", @"count":@"70"},
                                                    @{@"time":@"9:00", @"count":@"90"},
                                                    @{@"time":@"9:00", @"count":@"110"},
                                                    @{@"time":@"9:00", @"count":@"105"},
                                                    @{@"time":@"9:00", @"count":@"60"},
                                                    @{@"time":@"9:00", @"count":@"80"}
                                                    ]
                                            }
                                    }
                            }
                        ];
    
    [_babyRecords addObjectsFromArray:records];    
    
}

- (NSDictionary *)recordForPageIndex:(NSInteger)pageIndex
{
    if(!ARRAYVALID(_babyRecords)) return nil;
    
    NSInteger recordIndex = _babyRecords.count -1 - pageIndex;
    NSDictionary *record = [_babyRecords objectAtIndex:recordIndex];
    
    return record;
}


- (UIView*)createTwinsViewForRecord:(NSDictionary*)record atPageIndex:(NSInteger)pageIndex
{
    if(!record) return nil;
    
    //创建临时的双胞胎页面
    UIView *twinsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentScroll.frame), CGRectGetHeight(_contentScroll.frame))];
    
    
    //改变背景色
    NSInteger todayPageIndex = _babyRecords.count-1;
    float color = 230.0 + (todayPageIndex-pageIndex)*5.0;
    if(color > 255.0) color = 255.0;
    
    twinsView.backgroundColor = RGBS(color);
    
    BOOL isToday = [self checkRecordIsToday:record];
    
    
    BabyView *dotView = [[BabyView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(twinsView.frame)/2, CGRectGetHeight(twinsView.frame))];
    dotView.babyname = @"dot";
    dotView.babyRecord = [RDFunction valueOfData:record byPath:@"data.dot"];
    dotView.isToday = isToday;
    [twinsView addSubview:dotView];
    
    BabyView *sixView = [[BabyView alloc] initWithFrame:CGRectMake(CGRectGetWidth(twinsView.frame)/2, 0, CGRectGetWidth(twinsView.frame)/2, CGRectGetHeight(twinsView.frame))];
    sixView.babyname = @"six";
    sixView.babyRecord = [RDFunction valueOfData:record byPath:@"data.six"];
    sixView.isToday = isToday;
    [twinsView addSubview:sixView];
        
    
    //中线
    [HMFunction addLineOnView:twinsView fromPoint:CGPointMake(twinsView.center.x, 150) toPoint:CGPointMake(twinsView.center.x, CGRectGetHeight(twinsView.frame)-30) useColor:RGBS(200) isDot:YES];
    
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
    NSDictionary *record = [self recordForPageIndex:pageIndex];
    
    UIView *twinsView = [self createTwinsViewForRecord:record atPageIndex:pageIndex];
    
    return twinsView;
}

//DDPageScrollViewDelegate
- (void)ddPageScrollViewDidChangeToPageIndex:(DDPageScrollView*)pageScrollView pageIndex:(NSInteger)index;
{
//    NSLog(@"page changed to index: %ld", index);
//    NSInteger  curPageIndex = [pageScrollView currentPageIndex];
//    NSLog(@"当前获取到的页面index: %ld", curPageIndex);
    
    //改变右上角日期
    [self changeDateForPageIndex:index];
}
- (void)ddPageScrollViewOverFirstPage:(DDPageScrollView*)pageScrollView
{
}
- (void)ddPageScrollViewOverLastPage:(DDPageScrollView*)pageScrollView
{
}




@end
