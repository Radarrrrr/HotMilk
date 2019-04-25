//
//  DDPageScrollView.m
//  DangDangHD
//
//  Created by Radar on 12-11-16.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
//


#import "DDPageScrollView.h"




#pragma mark -
#pragma mark in use properties and functions
@interface DDPageScrollView ()

@property (nonatomic) NSInteger currentScrollIndex;  //当前scrollview中页面的index
@property (nonatomic, retain) NSMutableArray *pages;

- (void)updatePageForScrollIndex:(NSInteger)scrollIndex;
- (void)loadPageForScrollIndex:(NSInteger)scrollIndex; 
- (void)clearPageForScrollIndex:(NSInteger)scrollIndex;

- (void)loadAllPages;
- (void)clearAllPages;

- (NSInteger)pageIndexForScrollIndex:(NSInteger)scrollIndex; //根据页面的scrollIndex找到对应的页面index

@end




@implementation DDPageScrollView
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize pages = _pages;
@synthesize currentScrollIndex = _currentScrollIndex;
@synthesize zoomEnabled = _zoomEnabled;
@synthesize pageCtrlEnabled = _pageCtrlEnabled;
@synthesize circleEnabled = _circleEnabled;
@dynamic ingoreMemory;
@dynamic loadingStyle;
@synthesize scrollView = _scrollView;
@synthesize pcBackView = _pcBackView;
@dynamic currentPageIndex;
@dynamic pcBackEnabled;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = NO;
        
        //init some setting param
		_currentScrollIndex = 0;
        _zoomEnabled = NO;
        _pageCtrlEnabled = YES;
        _pcBackEnabled = NO;
        _circleEnabled = NO;
        _ingoreMemory = YES;
        _loadingStyle = DDPageScrollLoadingStylePreLoading;
        
        
        // Initialization code.
		self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)] autorelease];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		_scrollView.pagingEnabled = YES;
		_scrollView.backgroundColor = [UIColor clearColor];
		_scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        //_scrollView.clipsToBounds = NO;
		[self addSubview:_scrollView];
        
        //add _spinner
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.frame = CGRectMake((frame.size.width-25)/2, (frame.size.height-25)/2, 25, 25);
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        _spinner.hidesWhenStopped = YES;
        [_spinner startAnimating];
        [self addSubview:_spinner];
        
        
        //add _pcBackView
        self.pcBackView = [[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-16, frame.size.width, 12)] autorelease];
        _pcBackView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _pcBackView.backgroundColor = [UIColor blackColor];
        _pcBackView.alpha = 0.3;
        _pcBackView.layer.cornerRadius = 6;
        _pcBackView.layer.masksToBounds = YES;
        _pcBackView.hidden = YES;
        [self addSubview:_pcBackView];
        
        //add pagectrl
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        _pageCtrl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _pageCtrl.hidesForSinglePage = YES;
        _pageCtrl.userInteractionEnabled = NO;
        _pageCtrl.numberOfPages = 1;
        [self addSubview:_pageCtrl];
        
        if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        {
            _pageCtrl.pageIndicatorTintColor = [UIColor colorWithRed:(float)220/255 green:(float)220/255 blue:(float)220/255 alpha:.7];
            _pageCtrl.currentPageIndicatorTintColor = RGB(255, 70, 60);
        }
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //stop waiting
    [_spinner stopAnimating];
    _spinner.hidden = YES;
    
    //reload
    [self reloadPages];
}

- (void)dealloc 
{
    if(_scrollView)
    {
        _scrollView.delegate = nil;
        [_scrollView release];
    }
	[_pages release];
    [_pageCtrl release];
    [_spinner release];
    [_pcBackView release];
    
    [super dealloc];
}


- (NSInteger)currentPageIndex
{
    NSInteger cpIndex = [self pageIndexForScrollIndex:_currentScrollIndex];
    return cpIndex;
}



- (void)setLoadingStyle:(DDPageScrollLoadingStyle)loadingStyle
{
    _loadingStyle = loadingStyle;
    
    //全部加载风格下，强制设定忽略内存
    if(_loadingStyle == DDPageScrollLoadingStyleInitLoadingAll)
    {
        _ingoreMemory = YES;
    }
}
- (DDPageScrollLoadingStyle)loadingStyle
{
    return _loadingStyle;
}

- (void)setIngoreMemory:(BOOL)ingoreMemory
{
    _ingoreMemory = ingoreMemory;
    
    //全部加载风格下，强制设定忽略内存
    if(_loadingStyle == DDPageScrollLoadingStyleInitLoadingAll)
    {
        _ingoreMemory = YES;
    }
}
- (BOOL)ingoreMemory
{
    return _ingoreMemory;
}

- (void)setPcBackEnabled:(BOOL)pcBackEnabled
{
    _pcBackEnabled = pcBackEnabled;
    _pcBackView.hidden = !_pcBackEnabled;
    if(_pageCtrl.numberOfPages == 1)
    {
        _pcBackView.hidden = YES;
    }
}
- (BOOL)pcBackEnabled
{
    return _pcBackEnabled;
}





#pragma mark -
#pragma mark in use functions
-(void)updatePageForScrollIndex:(NSInteger)scrollIndex
{
    //移动pagectrl的指示
    NSInteger pageIndex = [self pageIndexForScrollIndex:scrollIndex];
     _pageCtrl.currentPage = pageIndex;
    
    
    //刷新页面
	NSInteger count =  _scrollCount;
	
	//加载当前页
	[self loadPageForScrollIndex:scrollIndex];
    
    //如果是预加载风格的，才会加载前后两个
    //当前+前2+后2进行判断    
    if(_loadingStyle == DDPageScrollLoadingStylePreLoading)
    {
        if(scrollIndex-1 >= 0)
        {
            [self loadPageForScrollIndex:(scrollIndex-1)];
        }
        if(scrollIndex+1 <= count-1)
        {
            [self loadPageForScrollIndex:(scrollIndex+1)];
        }
        
        if(scrollIndex-2 >= 0)
        {
            [self clearPageForScrollIndex:(scrollIndex-2)];
        }
        if(scrollIndex+2 <= count-1)
        {
            [self clearPageForScrollIndex:(scrollIndex+2)];
        }
    }
    else if(_loadingStyle == DDPageScrollLoadingStyleImmediateLoading)
    {
        //@Radar 即时加载风格只释放当前页的下一页，前一页不释放
//        if(scrollIndex-1 >= 0)
//        {
//            [self clearPageForScrollIndex:(scrollIndex-1)];
//        }
        if(scrollIndex+1 <= count-1)
        {
            [self clearPageForScrollIndex:(scrollIndex+1)];
        }
    }
    
    
    
    //如果是循环播放，则额外读取一张边界图片
    if(_circleEnabled && _loadingStyle == DDPageScrollLoadingStylePreLoading)
    {
        if(scrollIndex == 1)
        {
            [self loadPageForScrollIndex:(count-2)];
        }
        else if(scrollIndex == count-2)
        {
            [self loadPageForScrollIndex:1];
        }
    }
    
}
-(void)loadPageForScrollIndex:(NSInteger)scrollIndex
{
    NSInteger pageIndex = [self pageIndexForScrollIndex:scrollIndex];
    
    id page = [_pages objectAtIndex:scrollIndex];
	if([page isKindOfClass:[NSNull class]])
	{
        //创建scrollview容器
		float page_w = self.frame.size.width;
		float page_h = self.frame.size.height;
		CGRect pageRect = CGRectMake(page_w*scrollIndex, 0.0, page_w, page_h);
		
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:pageRect];
        scrollV.multipleTouchEnabled = YES;
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        scrollV.delegate = self;
        scrollV.clipsToBounds = NO;
        [scrollV setMinimumZoomScale:minZoomScale];
        [scrollV setMaximumZoomScale:maxZoomScale];
        [scrollV setZoomScale:1.0];
        
        
        //从datasource获取要显示的页面内容,如果外部不设定，默认空白页面
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(pageScrollView:viewForPageAtIndex:)])
        {
            //pageView应该为autorelease类型
            UIView *pageView = (UIView*)[self.dataSource pageScrollView:self viewForPageAtIndex:pageIndex];
            pageView.frame = CGRectMake(0, 0, page_w, page_h);
            pageView.tag = 100;
            [scrollV addSubview:pageView];
        }
        
        
        //管理页面队列
		[_pages replaceObjectAtIndex:scrollIndex withObject:scrollV];
		[_scrollView addSubview:scrollV];
        [scrollV release];
	}
    else if([page isKindOfClass:[UIScrollView class]])
    {
        //判断当前index的page是否zoom的比例不是1.0, 如果不是，则恢复为1.0
        UIScrollView *tpage = (UIScrollView*)page;
        if(tpage.zoomScale != 1.0)
        {
            [tpage setZoomScale:1.0];
            
            //还原位置
            float page_w = self.frame.size.width;
            float page_h = self.frame.size.height;
            CGRect pageRect = CGRectMake(page_w*scrollIndex, 0.0, page_w, page_h);
            tpage.frame = pageRect;
        }
    }
}

-(void)clearPageForScrollIndex:(NSInteger)scrollIndex
{	
    if(_ingoreMemory) return;
    
    id page = [_pages objectAtIndex:scrollIndex];
	if(page && [page isKindOfClass:[UIScrollView class]])
	{        
        UIView *pageView = (UIView*)[page viewWithTag:100];
        if(pageView && [pageView superview])
        {
            [pageView removeFromSuperview];
		}
        
        [(UIScrollView*)page setDelegate:nil];
        [page removeFromSuperview];
		[_pages replaceObjectAtIndex:scrollIndex withObject:[NSNull null]];
	}
}

- (void)loadAllPages
{
    for(int i=0; i<_scrollCount; i++)
    {
        [self loadPageForScrollIndex:i];
    }
}
- (void)clearAllPages
{
    for(int i=0; i<_scrollCount; i++)
    {
        if(!_pages || [_pages count] == 0) return;
        
        id page = [_pages objectAtIndex:i];
        if(page && [page isKindOfClass:[UIScrollView class]])
        {        
            UIView *pageView = (UIView*)[page viewWithTag:100];
            if(pageView && [pageView superview])
            {
                [pageView removeFromSuperview];
            }
            
            [page removeFromSuperview];
            [_pages replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
}

- (NSInteger)pageIndexForScrollIndex:(NSInteger)scrollIndex
{
//    6,0,1,2,3,4,5,6,0
//    0,1,2,3,4,5,6,7,8
    
    NSInteger pindex;
    
    if(!_circleEnabled)
    {
        pindex = scrollIndex;
    }
    else
    {
        NSInteger count = _pageCount;
        pindex = scrollIndex-1;
        
        if(pindex < 0)
        {
            pindex = count-1;
        }
        else if(pindex >= count)
        {
            pindex = 0;
        }
    }
    
    return pindex;
}




#pragma mark -
#pragma mark out use functions
- (void)reloadPages
{    
    //清空所有page
    [self clearAllPages];
    
    //从datasource获取page个数
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPagesInPageScrollView:)])
    {
        _pageCount = [self.dataSource numberOfPagesInPageScrollView:self];
    }
    
    //如果输入的page数量为0，或者没有实现datasource，则什么都不干，直接返回
    if(_pageCount == 0) return;
    
    
    //修改pagectrl的属性
    _pageCtrl.numberOfPages = _pageCount;
    _pageCtrl.currentPage = 0;

    //设定pagectrlor的显示状态
    if(_pageCount <= 1)
    {
        _pageCtrl.hidden = YES;
        _pcBackView.hidden = YES;
    }
    else
    {
        if(_pageCtrlEnabled)
        {
            _pageCtrl.hidden = NO;
        }
        else
        {
            _pageCtrl.hidden = YES;
        }
        
        if(_pcBackEnabled)
        {
            _pcBackView.hidden = NO;
        }
        else
        {
            _pcBackView.hidden = YES;
        }
    }

    
    
    //修改pagectrl的样式,这里要使用背景色
    CGSize psize = [_pageCtrl sizeForNumberOfPages:_pageCount];
    CGRect pframe = _pcBackView.frame;
    pframe.origin.x = (self.frame.size.width-psize.width-20)/2;
    pframe.size.width = psize.width+20;
    _pcBackView.frame = pframe;
        
    
	
	//create pages
	NSMutableArray *pagesArr = [[[NSMutableArray alloc] init] autorelease];
	
	float content_w = 0.0;
	float page_w = self.frame.size.width;
	_scrollCount = _pageCount;
    
    //如果循环开启，则队列前后分别多加1个空白page
    if(_circleEnabled)
    {
        _scrollCount += 2;
    }
    
	for(int i=0; i<_scrollCount; i++)
	{
		[pagesArr addObject:[NSNull null]];
		content_w += page_w;
	}
    

    //重置self.pages
	self.pages = pagesArr;
	_scrollView.contentSize = CGSizeMake(content_w, self.frame.size.height);
    
    
	//判断是否把所有页面一次性全部读取完毕
    if(_loadingStyle == DDPageScrollLoadingStyleInitLoadingAll)
    {
        [self loadAllPages];
    }

    
    //跳转到第一页，如果不忽略内存，则顺便读取该页内容
    [self scrollToPageIndex:0 animated:NO];
}


- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated
{
    //计算当前要调转到的_currentScrollIndex
    _currentScrollIndex = pageIndex;
	if(_circleEnabled)
    {
        _currentScrollIndex = pageIndex+1;
    }

    
	CGPoint contentOffset = _scrollView.contentOffset;
	float page_w = self.frame.size.width;
	contentOffset.x = _currentScrollIndex *page_w;
	
	[_scrollView setContentOffset:contentOffset animated:animated];
	
	[self updatePageForScrollIndex:_currentScrollIndex];
}






#pragma mark -
#pragma mark delegate functions
//UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{    
    if(scrollView == _scrollView) return nil;
    
    if(!_zoomEnabled) return nil;
    
    UIView *pageView = (UIView*)[scrollView viewWithTag:100];
    return pageView;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView != _scrollView) return;
    
	//计算当前content offset, 用以计算当前处在哪个page上
	float page_w = self.frame.size.width;
	_currentScrollIndex = _scrollView.contentOffset.x/page_w;
    
	
	//刷新一下当前页面image
    if(!_circleEnabled)
    {
        [self updatePageForScrollIndex:_currentScrollIndex];
	}
    else
    {
        if(_currentScrollIndex <= 0)
        {
            [self scrollToPageIndex:(_pageCount-1) animated:NO];
        }
        else if(_currentScrollIndex >= _scrollCount-1)
        {
            [self scrollToPageIndex:0 animated:NO];
        }
        else
        {
            [self updatePageForScrollIndex:_currentScrollIndex];
        }
    }
    
	//返回给代理当前的page编号
    NSInteger pagaIndex = [self pageIndexForScrollIndex:_currentScrollIndex];
	if(self.delegate && [self.delegate respondsToSelector:@selector(ddPageScrollViewDidChangeToPageIndex:pageIndex:)])
	{
		[self.delegate ddPageScrollViewDidChangeToPageIndex:self pageIndex:pagaIndex];
	}
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //不支持首尾相接
    if(_circleEnabled) return;
    if(scrollView != _scrollView) return;
    
    NSInteger pageIndex = [self pageIndexForScrollIndex:_currentScrollIndex];
    //NSLog(@"抬起手的时候,当前页的pageIndex是:%d", pageIndex);
    
    //抬手的时候，计算当前页是否处于第一张继续向前或者最后一张继续向后，然后返回相关事件
    
    if(pageIndex == 0)
    {
        //第一页
        if(_scrollView.contentOffset.x < -over_blank_limit)
        {            
            //返回代理
            if(self.delegate && [self.delegate respondsToSelector:@selector(ddPageScrollViewOverFirstPage:)])
            {
                [self.delegate ddPageScrollViewOverFirstPage:self];
            }
        }
    }
    else if(pageIndex == _pageCount-1)
    {
        //最后一页
        float page_w = self.frame.size.width;
        float over = _scrollView.contentOffset.x + page_w - _scrollView.contentSize.width;
        if(over > over_blank_limit)
        {
            //返回代理
            if(self.delegate && [self.delegate respondsToSelector:@selector(ddPageScrollViewOverLastPage:)])
            {
                [self.delegate ddPageScrollViewOverLastPage:self];
            }
        }
    }
    
}



@end
