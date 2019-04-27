//
//  HMFunction.m
//  JKSchool
//
//  Created by radar on 2019/3/11.
//  Copyright © 2019 radar. All rights reserved.
//

#import "HMFunction.h"

@implementation HMFunction


+ (id)dataConveredFromBinary:(id)binaryData
{
    if(!binaryData) return nil;
    
    NSString *jsonString = [[NSString alloc] initWithData:binaryData encoding:NSUTF8StringEncoding];  
    id data = [RDFunction dataFromJsonString:jsonString];
    
    return data;
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

+ (float)fixedPixel:(float)pixel
{
    //把像素尺寸按设备不同等比例调整，基础尺寸为750x1334
    float w = [[UIScreen mainScreen] currentMode].size.width;
    float k = w/750.0; //当前设备与750基础尺寸的比例

    return pixel*k;
}

+ (void)makeupShadowOnView:(UIView*)hostView
{
    //更新阴影状态
    CALayer *layer = hostView.layer;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
    layer.shadowPath = path.CGPath;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.2;
    layer.shadowRadius = 3;
}

+ (void)addShadowToView:(UIView*)hostView
{
    if(!hostView) return;
    if(![hostView superview]) return;
    
    CGRect hrect = hostView.frame;
    
    float x = hrect.origin.x;
    float y = hrect.origin.y;
    float w = hrect.size.width;
    float h = hrect.size.height;
    
    //shadow 位置：上1，左右2，下3
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(x+1, y+2, w-2, h-2)];
    shadow.backgroundColor = [UIColor clearColor];
    shadow.userInteractionEnabled = NO;
    [HMFunction makeupShadowOnView:shadow];
    
    //放在host下面
    [hostView.superview insertSubview:shadow belowSubview:hostView];
    
}

+ (void)addDotLineOnView:(UIView *)view fromPoint:(CGPoint)startP toPoint:(CGPoint)endP useColor:(UIColor*)color
{
    if(!view) return;
    if(!color) return;
    
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //  线条颜色
    border.strokeColor = color.CGColor; //[UIColor lightGrayColor].CGColor;
    border.fillColor = nil;
    
    UIBezierPath *pat = [UIBezierPath bezierPath];
    
    [pat moveToPoint:startP];
    [pat addLineToPoint:endP];
    
    border.path = pat.CGPath;
    border.frame = view.bounds;
    
    // 不要设太大 不然看不出效果
    border.lineWidth = 0.5;
    border.lineCap = @"butt";
    
    //  第一个是 线条长度   第二个是间距    nil时为实线
    border.lineDashPattern = @[@6, @6];
    [view.layer addSublayer:border];
}

+ (void)addLineOnView:(UIView *)view fromPoint:(CGPoint)startP toPoint:(CGPoint)endP useColor:(UIColor*)color isDot:(BOOL)isdot
{
    if(!view) return;
    if(!color) return;
    
    if(isdot)
    {
        [self addDotLineOnView:view fromPoint:startP toPoint:endP useColor:color];
    }
    else
    {
        float w = 0.5;
        float h = 0.5;
        
        if(startP.y == endP.y)
        {
            //划横线
            w = endP.x - startP.x;
        }
        else if(startP.x == endP.x)
        {
            //划竖线
            h = endP.y - startP.y;
        }
        else
        {
            //斜线暂不处理
            return;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(startP.x, startP.y, w, h)];
        line.userInteractionEnabled = NO;
        line.backgroundColor = color;
        [view addSubview:line];
    }
}


@end
