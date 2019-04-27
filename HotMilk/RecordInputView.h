//
//  RecordInputView.h
//  Home
//
//  Created by Radar on 2017/4/27.
//  Copyright © 2017年 Radar. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface RecordInputView : UIView

+ (instancetype)sharedInstance; //单实例

- (void)callRecordInputForBaby:(NSString*)babyname completion:(void (^)(void))completion;

@end
