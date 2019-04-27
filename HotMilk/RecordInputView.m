//
//  RecordInputView.m
//  Home
//
//  Created by Radar on 2017/4/27.
//  Copyright © 2017年 Radar. All rights reserved.
//


#define RecordInputView_container_height       600

#define RecordInputView_container_position_up      SCR_HEIGHT - RecordInputView_container_height
#define RecordInputView_container_position_down    RecordInputView_container_position_up + 200


//#define RecordInputView_container_position_down    SCR_HEIGHT - RecordInputView_container_height
//#define RecordInputView_container_position_up      RecordInputView_container_position_down - 200


static float inputLastPosition;


#import "RecordInputView.h"
#import "MoveableView.h"


@interface RecordInputView () <MoveableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) MoveableView *containerView;

@property (nonatomic, copy)   NSString *forBaby; //为哪个宝宝打开的本页面
@property (nonatomic, strong) UIImageView *faceView; //宝宝头像

@property (nonatomic, strong) void (^closeHandler)(void);


@end


@implementation RecordInputView


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static RecordInputView *instance;
    dispatch_once(&onceToken, ^{
        instance = [[RecordInputView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
    });
    return instance;
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.backgroundColor = [UIColor clearColor];//DDCOLOR_BLUE_GRAY_BACK_GROUND;
        
    
        //添加背景遮罩
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.0;
        [self addSubview:_backView];
        
        //添加点击事件
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction:)];
        [_backView addGestureRecognizer:tapGesture];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [_backView addGestureRecognizer:swipeGesture];
        
        
        //添加输入内容浮层
        self.containerView = [[MoveableView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, RecordInputView_container_height)];
        _containerView.backgroundColor = COLOR_BLUE_GRAY_BACK_GROUND;
        _containerView.verticalOnly = YES;
        _containerView.delegate = self;
        [RDFunction addRadiusToView:_containerView radius:6];
        [self addSubview:_containerView];
        
        
        //添加额外扩展区域分割线
        [HMFunction addLineOnView:_containerView fromPoint:CGPointMake(30, RecordInputView_container_height-200) toPoint:CGPointMake(SCR_WIDTH-30, RecordInputView_container_height-200) useColor:COLOR_LINE_A isDot:NO];
        
        
        //添加键盘落下按钮
        UIButton *kbColoseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        kbColoseBtn.frame = CGRectMake(frame.size.width-8-38, 12, 38, 38);
        [kbColoseBtn setBackgroundImage:[UIImage imageNamed:@"icon_close_keyboard"] forState:UIControlStateNormal];
        [kbColoseBtn addTarget:self action:@selector(closeKeyBoardAction) forControlEvents:UIControlEventTouchUpInside];
        [RDFunction addRadiusToView:kbColoseBtn radius:19];
        [_containerView addSubview:kbColoseBtn];
        
        //添加输入框和其他组件
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(8, 12, frame.size.width-16, 38)]; 
        _inputField.backgroundColor = COLOR_PINK;
        _inputField.textColor = [UIColor whiteColor];
        _inputField.font = FONT_B(20);
        _inputField.borderStyle = UITextBorderStyleRoundedRect;
        _inputField.returnKeyType = UIReturnKeyDone;
        _inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _inputField.delegate = self;
        _inputField.placeholder = @"自行输入奶量 @^_^@  =>";
        _inputField.textAlignment = NSTextAlignmentLeft;
        [_containerView addSubview:_inputField];
        
        //添加拉动条
        UIView *dragLine = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_containerView.frame)-40)/2, 4, 40, 4)];
        dragLine.backgroundColor = RGBS(190);
        [RDFunction addRadiusToView:dragLine radius:2];
        [_containerView addSubview:dragLine];
        
        //添加奶量选择按钮
        [self addCountButtons];
        
        //添加头像
        float w = 280;
        float x = (SCR_WIDTH-w)/2;
        float y = (SCR_HEIGHT - (RecordInputView_container_height-200) -w)/2;
        self.faceView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        _faceView.userInteractionEnabled = NO;
        _faceView.backgroundColor = [UIColor clearColor];
        _faceView.alpha = 0.0;
        [RDFunction addRadiusToView:_faceView radius:w/2];
        [self addSubview:_faceView];
        
    }
    return self;
}

- (void)dealloc
{
}

- (void)addCountButtons;
{
    //添加奶量选择按钮
    NSArray *counts = @[@"20", @"30", @"35", @"40", 
                        @"50", @"60", @"70", @"80", 
                        @"90", @"100", @"110", @"120"
                       ];
    
    for(int i=0; i<counts.count; i++)
    {
        NSString *cout = [counts objectAtIndex:i];
        
        UIButton *cbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cbtn.backgroundColor = RGBS(200);//RGB(255, 252, 247);
        [cbtn setTitle:cout forState:UIControlStateNormal];
        [cbtn setTitleColor:COLOR_TEXT_B forState:UIControlStateNormal];
        
        cbtn.titleLabel.font = FONT_B(16);
        cbtn.tag = cout.integerValue;
        [cbtn addTarget:self action:@selector(countBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [RDFunction addRadiusToView:cbtn radius:15];
        
        int han = i/4; //行
        int lie = i%4; //列
        
        float offw = (SCR_WIDTH-10)/4;
        float offh = 80;
        
        float x = 10 + lie*offw; 
        float y = 65 + han*offh;
        
        NSLog(@"(%f, %f)", x, y);
        
        cbtn.frame = CGRectMake(x, y, offw-10, offh-10);
        [_containerView addSubview:cbtn];
        
        
        [cbtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 252, 247) andSize:CGSizeMake(offw-10, offh-10)] forState:UIControlStateNormal];
        
    }
}



#pragma mark - 页面移动相关
- (void)moveContainerViewToY:(float)toY
{
    CGRect cframe = _containerView.frame;
    cframe.origin.y = toY;
    _containerView.frame = cframe;
}

- (void)callRecordInputForBaby:(NSString*)babyname completion:(void (^)(void))completion
{
    self.closeHandler = completion;
    self.forBaby = babyname;
    
    //设定头像
    if([_forBaby isEqualToString:@"dot"])
    {
        _faceView.image = [UIImage imageNamed:@"ma+diandian"];
    }
    else if([_forBaby isEqualToString:@"six"])
    {
        _faceView.image = [UIImage imageNamed:@"ma+liuliu"];
    }
    
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    if(![self superview])
    {
        [topWindow addSubview:self];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self->_backView.alpha = 0.5;
        
        [self moveContainerViewToY:RecordInputView_container_position_down];
        inputLastPosition = RecordInputView_container_position_down;
            
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self->_faceView.alpha = 1.0;
        }];
    }];
}

- (void)closeAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self->_backView.alpha = 0.0;
        self->_faceView.alpha = 0.0;
        
        [self moveContainerViewToY:SCR_HEIGHT];
        
        [self->_inputField resignFirstResponder];
        self->_inputField.text = nil;
        
    } completion:^(BOOL finished) {
        
        if([self superview])
        {
            [self removeFromSuperview];
        }
        
        if(self->_closeHandler)
        {
            self->_closeHandler();
        }
    }];
}

//MoveableViewDelegate
- (void)MoveableViewTouchUp:(MoveableView*)theView
{
    if(!theView) return;
    
    
    float moveToY;
    
    if(inputLastPosition == RecordInputView_container_position_down)
    {
        if(theView.frame.origin.y < RecordInputView_container_position_down-50)
        {
            //向上打开
            moveToY = RecordInputView_container_position_up;
        }
        else
        {
            //恢复向下关闭
            moveToY = RecordInputView_container_position_down;
        }
    }
    else 
    {
        if(theView.frame.origin.y < RecordInputView_container_position_up+50)
        {
            //恢复向上打开
            moveToY = RecordInputView_container_position_up;
        }
        else
        {
            //向下关闭
            moveToY = RecordInputView_container_position_down;
        }
    }
    

    [UIView animateWithDuration:0.15 animations:^{
        
        [self moveContainerViewToY:moveToY];
        inputLastPosition = moveToY;
        
    }];
    
}

- (void)closeKeyBoardAction
{
    //增加输入框长度
    [self showColoseKeyboardBtn:NO];
    
    //收起键盘
    if([_inputField isFirstResponder])
    {
        [_inputField resignFirstResponder];
    }
}

- (void)showColoseKeyboardBtn:(BOOL)show
{
    CGRect inputLongRect  = CGRectMake(8, 12, self.frame.size.width-16, 38);
    CGRect inputshortRect = CGRectMake(8, 12, self.frame.size.width-16-38-4, 38);
    
    [UIView animateWithDuration:0.25 animations:^{
        if(show)
        {
            self->_inputField.frame = inputshortRect;
        }
        else
        {
            self->_inputField.frame = inputLongRect;
        }
    }];
}


#pragma mark - 数据保存相关
//判断是否为纯int类型
- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    int val; 
    return [scan scanInt:&val] && [scan isAtEnd];
}

//UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //缩短输入框长度
    [self showColoseKeyboardBtn:YES];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text && ![textField.text isEqualToString:@""])
    {
        NSString *countStr = textField.text;
        if(![self isPureInt:countStr]) return NO;
        
        [self saveCountToDB:countStr];
        return YES;
    }
    
    return NO;
}

- (void)countBtnAction:(UIButton*)btn
{
    NSInteger count = btn.tag;
    _inputField.text = [NSString stringWithFormat:@"%ld", (long)count];
    
    if(![_inputField isFirstResponder])
    {
        [_inputField becomeFirstResponder];
    }
}

- (void)saveCountToDB:(NSString*)count
{
    //TO DO: 保存数据到数据库
    //_forBaby
    //[NSDate date]
    
    
    [self closeAction:nil];
}

//- (NSDictionary *)assemblePayload:(NSString *)message attach:(NSString *)attach msgtype:(NSString*)msgtype//attach就是一个url，无论上传了什么都是一个url
//{    
////#define MSG_TYPE_MESSAGE        @"message"      //标准信息
////#define MSG_TYPE_CONFIRM        @"confirm"      //确认信息
////#define MSG_TYPE_ATTENTION      @"attention"    //提醒注意信息
//    
//    
//    if(!STRVALID(message)) message = @"";
//    if(!STRVALID(attach)) attach = @"";
//    if(!STRVALID(msgtype)) msgtype = MSG_TYPE_MESSAGE;
//    
//    NSString *sendtime = [DDFunction stringFromDate:[NSDate date] useFormat:@"YY-MM-dd HH:mm:ss"];
//    
//    //用from_token+to_token+sendtime做MD5,生成验证码
//    NSString *ntokenString = [NSString stringWithFormat:@"%@_%@_%@", _selfToken, _pushToToken, sendtime];
//    NSString *notifyToken = [DDFunction md5FormString:ntokenString];
//    
//    
//    //根据不同消息类型，设定声音, mutable-content状态等
//    NSString *sound = @"default";
//    NSString *mutcontent = @"1";
//    
//    //修改设定
//    if([msgtype isEqualToString:MSG_TYPE_MESSAGE])
//    {
//        sound = @"default";
//        mutcontent = @"1";
//    }
//    else if([msgtype isEqualToString:MSG_TYPE_CONFIRM])
//    {
//        sound = @"Submarine.aiff";
//        mutcontent = @"0";
//    }
//    else if([msgtype isEqualToString:MSG_TYPE_ATTENTION])
//    {
//        sound = @"msg_new.mp3";
//        mutcontent = @"0";
//    }
//    
//    
//    
//    //组合payload
//    NSDictionary *payload = 
//    @{
//        @"aps":
//        @{
//            @"alert":
//            @{
//                @"title":@"",
//                @"subtitle":@"",
//                @"body":message
//            },
//            @"badge":@1,
//            @"sound":sound,
//            @"mutable-content":mutcontent,
//            @"category":@"myNotificationCategory",
//            @"attach":attach,
//            @"from_token":_selfToken,
//            @"from_userid":_selfUserId,
//            @"to_token":_pushToToken
//        },
//        @"goto_page":@"",
//        @"sendtime":sendtime,
//        
//        @"notifytoken":notifyToken, 
//        
//        @"msgtype":msgtype,
//        @"confirm_notifyid":@""
//        
//    };
//
//    return payload;
//}





@end




