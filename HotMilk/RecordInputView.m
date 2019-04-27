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
        
        
        
        //添加输入框和其他组件
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(8, 12, frame.size.width-16, 38)]; 
        _inputField.backgroundColor = COLOR_PINK;
        _inputField.borderStyle = UITextBorderStyleRoundedRect;
        _inputField.returnKeyType = UIReturnKeySend;
        _inputField.delegate = self;
        _inputField.placeholder = @"自行输入奶量 @^_^@  =>";
        [_containerView addSubview:_inputField];
        
        //添加拉动条
        UIView *dragLine = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_containerView.frame)-40)/2, 4, 40, 4)];
        dragLine.backgroundColor = RGBS(190);
        [RDFunction addRadiusToView:dragLine radius:2];
        [_containerView addSubview:dragLine];
        
        
        
    }
    return self;
}

- (void)dealloc
{
}

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
    
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    if(![self superview])
    {
        [topWindow addSubview:self];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self->_backView.alpha = 0.5;
        
        [self moveContainerViewToY:RecordInputView_container_position_down];
        inputLastPosition = RecordInputView_container_position_down;
        
        //[self->_inputField becomeFirstResponder];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self->_backView.alpha = 0.0;
        
        [self moveContainerViewToY:SCR_HEIGHT];
        
        [self->_inputField resignFirstResponder];
        
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


//UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text && ![textField.text isEqualToString:@""])
    {
        //NSString *count = textField.text;
        
        return YES;
    }
    
    return NO;
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




