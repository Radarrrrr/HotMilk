//
//  HotMilkViewController.m
//  HotMilk
//
//  Created by radar on 2018/11/18.
//  Copyright © 2018年 radar. All rights reserved.
//

#import "HotMilkViewController.h"

@interface HotMilkViewController () <RDTableViewDelegate>

@end

@implementation HotMilkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"HOT MILK";
    
    //添加主列表
//    RDTableView *table = [[RDTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
//    table.delegate = self;
//    table.tag = 1000;
//    table.loadMoreStyle = LoadMoreStyleLoading;
//    table.refreshStyle = RefreshStyleDropdown;
//    table.multiSelectEnabled = YES;
//    table.editRowEnabled = NO;
//    table.moveRowEnabled = NO;
}


@end
