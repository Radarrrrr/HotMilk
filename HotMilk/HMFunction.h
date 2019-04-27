//
//  HMFunction.h
//  JKSchool
//
//  Created by radar on 2019/3/11.
//  Copyright © 2019 radar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMFunction : NSObject


+ (id)dataConveredFromBinary:(id)binaryData; //把二进制数据，转化成数组/字典格式数据 PS：前提是binaryData一定是二进制格式，并且一定是能转成json格式的二进制w数据，里边不做校验了

+ (BOOL)iPhoneXorLater; //是否iPhoneX以后的机型

+ (float)fixedPixel:(float)pixel; //把像素尺寸按设备不同等比例调整，基础尺寸为750x1334

+ (void)addShadowToView:(UIView*)hostView;      //在一个view的下面添加阴影背景，PS：hostview必须先有superview

+ (void)addLineOnView:(UIView *)view fromPoint:(CGPoint)startP toPoint:(CGPoint)endP useColor:(UIColor*)color isDot:(BOOL)isdot; //在一个view上画线，可选择是否虚线 PS:point是view上的相对坐标，目前只能支持横竖线，斜线暂不支持

@end

