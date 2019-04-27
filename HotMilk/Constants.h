//
//  Constants.h
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//
#import "HMFunction.h"


//常用的宏设定
#define IPHONEX_OR_LATER   [HMFunction iPhoneXorLater]   //是否iPhoneX或者更高 
#define STATUS_BAR_HEIGHT  ((IPHONEX_OR_LATER) ? 44.0f : 20.0f)

#define VIEW_WIDTH         [UIScreen mainScreen].bounds.size.width //页面可显示区域的宽度
#define VIEW_HEIGHT        [UIScreen mainScreen].bounds.size.height - STATUS_BAR_HEIGHT//导航条向下的所有区域高度

#define COLOR(x) [RDFunction colorFromHexString:x] //16进制颜色(html颜色值)字符串转为UIColor 如：@"#3300ff"

#define AT(x)           [JKFunction fixedPixel:x]           //把像素尺寸按设备不同等比例调整，基础尺寸为750x1334
#define IMAGE(str)      [UIImage imageNamed:str]            //快速创建一个图片对象


#define COLOR_PINK      [UIColor colorWithRed:255.0/255.0 green:163.0/255.0 blue:156.0/255.0 alpha:1.0]

 



