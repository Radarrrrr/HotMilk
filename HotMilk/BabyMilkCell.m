//
//  BabyMilkCell.m
//  HotMilk
//
//  Created by radar on 2018/12/27.
//  Copyright © 2018 radar. All rights reserved.
//

#import "BabyMilkCell.h"

@implementation BabyMilkCell

#pragma mark - 复写下面两个方法
- (void)setCellStyle
{
    //设定cell的样式，所有的组件都放在 self.contentView 上面，做成全局变量，用以支持 setCellData 里边来修改组件的数值
    
    //...复写此方法
}

-(NSNumber*)setCellData:(id)data atIndexPath:(NSIndexPath*)indexPath
{
    //根据data设定cell上组件的属性，并返回计算以后的cell高度, 用number类型装进去，[重要]cell高度必须要做计算并返回，如果返回nil就使用默认的44高度了
    
    //...复写此方法
    
    return nil;
}


@end
