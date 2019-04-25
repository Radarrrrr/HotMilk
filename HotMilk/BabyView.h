//
//  BabyView.h
//  HotMilk
//
//  Created by radar on 2018/12/27.
//  Copyright © 2018 radar. All rights reserved.
//

/*
  @{
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
*/


#import <UIKit/UIKit.h>

@interface BabyView : UIView <RDTableViewDelegate>

@property (nonatomic, strong) NSString *babyname; 
@property (nonatomic, copy)   NSDictionary *babyRecord;

@end
