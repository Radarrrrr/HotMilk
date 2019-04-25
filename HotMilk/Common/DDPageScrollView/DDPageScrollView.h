//
//  DDPageScrollView.h
//  DangDangHD
//
//  Created by Radar on 12-11-16.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
//

//PS: 使用本模块，需要添加 QuartzCore.framework

//使用方法:
/*
//1. 创建 pageScrollView
DDPageScrollView *pageScrollView = [[DDPageScrollView alloc] initWithFrame:CGRectMake((1024-675)/2, (748-245)/2, 675, 245)];
pageScrollView.backgroundColor = [UIColor clearColor]; //PS:如果设定bPageRoundRect=YES, 则backgroundColor必须为clearColor
pageScrollView.delegate = self;
pageScrollView.dataSource = self;
 
pageScrollView.zoomEnabled = YES;
pageScrollView.pageCtrlEnabled = YES;
pageScrollView.pcBackEnabled = YES;
pageScrollView.circleEnabled = NO;
pageScrollView.ingoreMemory = NO;
pageScrollView.loadingStyle = DDPageScrollLoadingStylePreLoading;
 
[self.view addSubview:pageScrollView];
[pageScrollView release];

//2. 实现 dataSource 方法，设定要现实的page页数和每页的内容
//DDPageScrollViewDataSource
- (NSInteger)numberOfPagesInPageScrollView:(DDPageScrollView*)pageScrollView
{
    return 4;
}
- (UIView*)pageScrollView:(DDPageScrollView*)pageScrollView viewForPageAtIndex:(NSInteger)pageIndex
{
    NSArray *colors = [NSArray arrayWithObjects:
                        [UIColor redColor], 
                        [UIColor greenColor], 
                        [UIColor yellowColor], 
                        [UIColor blueColor], 
                        nil];

    UIView *pageView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 765, 245)] autorelease];
    pageView.backgroundColor = (UIColor*)[colors objectAtIndex:pageIndex];
    return pageView;
}
 
//3. 实现对应的代理方法
//DDPageScrollViewDelegate
- (void)ddPageScrollViewDidChangeToPageIndex:(DDPageScrollView*)pageScrollView pageIndex:(NSInteger)index;
{
    NSLog(@"page changed to index: %d", index);
    NSInteger  curPageIndex = [pageScrollView currentPageIndex];
    NSLog(@"当前获取到的页面index: %d", curPageIndex);
}
- (void)ddPageScrollViewOverFirstPage:(DDPageScrollView*)pageScrollView
{
}
- (void)ddPageScrollViewOverLastPage:(DDPageScrollView*)pageScrollView
{
}
*/




#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define minZoomScale 1.0  //最小缩放比例
#define maxZoomScale 4.0  //最大缩放比例

#define over_blank_limit 60 //第一张和最后一张能容忍的空白区域宽度大小，用于反馈是否到第一张最前和最后一张最后的情况



typedef enum {
    DDPageScrollLoadingStylePreLoading = 0,     //预加载风格
    DDPageScrollLoadingStyleImmediateLoading,   //即时加载风格
    DDPageScrollLoadingStyleInitLoadingAll      //初始化就加载全部页面风格 //全部加载的时候，_ingoreMemory属性自动设置为YES，不可以释放所有的页面
} DDPageScrollLoadingStyle; //加载风格



@class DDPageScrollView;

//delegate方法
@protocol DDPageScrollViewDelegate<NSObject>
@optional
//切换到某一个page的时候，返回当前切换到的page的index
- (void)ddPageScrollViewDidChangeToPageIndex:(DDPageScrollView*)pageScrollView pageIndex:(NSInteger)index; 

//返回本类是否越过了第一张过多，或者越过了最后一张过多，标准是：over_blank_limit
- (void)ddPageScrollViewOverFirstPage:(DDPageScrollView*)pageScrollView;
- (void)ddPageScrollViewOverLastPage:(DDPageScrollView*)pageScrollView;

@end


//datasource方法
@protocol DDPageScrollViewDataSource<NSObject>
@optional

//设定page有多少页
- (NSInteger)numberOfPagesInPageScrollView:(DDPageScrollView*)pageScrollView;

//设定每个page页面要显示的view
//PS: 请注意，如果circleEnabled=YES，
//    则通过此方法获得的view必须为autorelease类型，且必须是临时创建的view，不能使用字典写好一个view的数组然后使用index选取的方式!
//    否则可能会因为重复添加子view和释放多余页面过度而导致首尾相接部分的page出现空白页面。
//    因为从原理上来看，不循环的时候，page和数组是一一对应的，而循环的时候，page要比数组多了两个。
- (UIView*)pageScrollView:(DDPageScrollView*)pageScrollView viewForPageAtIndex:(NSInteger)pageIndex;

@end




@interface DDPageScrollView : UIView <UIScrollViewDelegate> {

	UIScrollView *_scrollView;
	NSMutableArray *_pages;
    UIPageControl *_pageCtrl;
    UIView *_pcBackView; //pagectrl的背景图片
    UIActivityIndicatorView *_spinner;
    
    NSInteger _pageCount;  //页面数量 对应 pageIndex
    NSInteger _scrollCount;//滚动descroll上面的分页数量，对应 scrollIndex
	NSInteger _currentScrollIndex; //当前scroll上页面的index，如果是circle模式，需要转换成数据源的index，这两个间有偏差
    
	BOOL _zoomEnabled;
    BOOL _pageCtrlEnabled;
    BOOL _pcBackEnabled;
    BOOL _circleEnabled;
    BOOL _ingoreMemory;  
    DDPageScrollLoadingStyle _loadingStyle;
    
@private
	id _delegate;		
    id _dataSource;
}


@property (assign) id <DDPageScrollViewDelegate> delegate;
@property (assign) id <DDPageScrollViewDataSource> dataSource;

@property (nonatomic) BOOL zoomEnabled;          //图片是否可以缩放  default is NO
@property (nonatomic) BOOL pageCtrlEnabled;      //是否可以显示并使用pagectrl default is YES
@property (nonatomic) BOOL pcBackEnabled;        //是否可以显示pagectrl的背景色 default is NO
@property (nonatomic) BOOL circleEnabled;        //是否首尾相连循环轮播 default is NO //PS: 此参数必须初始化时指定，且中途不可以切换
@property (nonatomic) BOOL ingoreMemory;         //是否忽略内存，default is YES //用于页数不多的情况下，滑动以后不做任何释放，为了保证页面使用的最流畅效果。
@property (nonatomic) DDPageScrollLoadingStyle loadingStyle; //加载风格 default is DDPageScrollLoadingStylePreLoading


@property (nonatomic) NSInteger currentPageIndex;       //当前页面的pageIndex，供外部获取使用
@property (nonatomic, retain) UIScrollView *scrollView; //内部容器
@property (nonatomic, retain) UIView *pcBackView;       //pagectrl的背景图片


- (void)reloadPages; //刷新全部页面, 并直接回到第一个page。

//滚动到指定index对应的页面，用于外部计时器驱动自动滚动，或者外部点击滚动
//PS: 强制滚动到的pageIndex，不返回代理事件
- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated;    



@end



