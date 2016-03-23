//
//  ViewController.m
//  RedPacket
//
//  Created by mistong on 16/1/15.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AFNetworking/AFNetworking.h"
#import "ClickModel.h"


@interface ViewController ()<SFCountdownViewDelegate>
{
    UIView      *bgView; //奖品展示背景
    UIView *bg;
    UIImageView *imageViewOne; //奖品展示One
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
    UIImageView *imageViewFour;
    UIView *viewOne;//中奖名单展示
    UIView *viewTwo;//中奖名单展示
    UILabel *giftLabel; //什么奖项  比如幸运奖
    UIView *allView;//bandsView
    BOOL firstClick;     //奖品展示yes, no
    BOOL startClick;     //红包继续和开始
    NSInteger number;    //计数
//    NSInteger headerNumber;    //技术头像个数, 最多20
    NSInteger headerLeft;    //技术头像个数, 最多20
    NSInteger headerRight;    //技术头像个数, 最多20
    NSMutableArray *_imagesArray;
    NSInteger tagValue;
    NSMutableArray *_imagesLayer;
    
    NSTimer *myTimer;
    
    
    //以下为: 圣旨显示名单所以得声明
    UIView* _contentView;
    UIImageView* _leftView;
    UIImageView* _rightView;
    UIImageView* _backImgView;
    UIImageView* _textImgView;
    NSMutableArray *bgViewArr; //存放所有的中奖view
    CGFloat _step;
    UIImageView *clickImage;   //点击得到红包效果
    
    //接口
    UILabel   *timesLabel; //用于显示每轮中奖的几个
    NSInteger speeds;      //请求的数据, 红包雨下落得速度
    NSInteger luckynum;    //每轮获奖的总认识
    CGPoint   clickFrame;  //点击红包的frame
    BOOL      clickSuccess;//接口成功或者失败
    NSMutableArray *clickArr; //点击数据储存
    NSString *workNumber;  //工号
    NSMutableArray *giftImageArr; //奖品image数组
    NSString *giftImageName;      //奖品类别
    NSInteger curtindex;         //奖品展示时让哪个照片突出显示
    NSInteger imageCount;        //奖品数量
    
}
@property(nonatomic,strong)AVAudioPlayer *player;
@property (assign, nonatomic)NSInteger headerNumber;   //每轮获奖的总人数
@property (strong, nonatomic)CALayer *movingLayer;
@property (nonatomic, strong)SFCountdownView *sfCountdownView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     number = 0;
    speeds = 0;
    luckynum = 0;
    self.headerNumber = -1;
    headerLeft = -1;
    headerRight = -1;
    firstClick = YES;
    startClick = YES;
    clickSuccess = NO;
    _imagesLayer = [NSMutableArray arrayWithCapacity:0];
    bgViewArr = [NSMutableArray arrayWithCapacity:0];
    _imagesArray = [[NSMutableArray alloc] init];
    clickArr = [NSMutableArray arrayWithCapacity:0];
    //giftImageArr = [NSMutableArray arrayWithCapacity:0];
    
    UIImageView *imagBigView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imagBigView.tag = 10068;
    imagBigView.image = [UIImage imageNamed:@"主KV改(2048-1536).jpg"];
    [self.view addSubview:imagBigView];
    
    for (int i = 1; i <= 20; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bao.png"]];
        imageView.frame = CGRectMake(IMAGE_X, -80, 80, 80);
        [self.view addSubview:imageView];
        [_imagesArray addObject:imageView];
    }

    
    
    [self addObserver:self forKeyPath:@"headerNumber" options:NSKeyValueObservingOptionNew context:@"112222221"];
    //猴子gif
    [self theMonkeyGifOne];
    [self theMonkeyGifTwo];
    //button
    [self buttonUI];
    
    //开始动画, 打广告
    [self performSelector:@selector(startTheAnimation) withObject:self afterDelay:2];

    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:tap];


        // Do any additional setup after loading the view, typically from a nib.
}



- (void)theMonkeyGifOne {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, SCREEN_HEIGHT - 150, 120, 120)];
    imageView.tag = 1066;
    [self.view addSubview:imageView];
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=1; i<4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.tiff",i]];
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
    imageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    imageView.animationDuration = 4*0.2;
    //动画重复次数 （0为重复播放）
    imageView.animationRepeatCount = 0;
    //开始播放动画
    [imageView startAnimating];
 
}

- (void)theMonkeyGifTwo {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 5, SCREEN_HEIGHT - 150, 120, 120)];
    imageView.tag = 1067;
    [self.view addSubview:imageView];
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=1; i<3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1%d.tiff",i]];
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
    imageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    imageView.animationDuration = 4*0.2;
    //动画重复次数 （0为重复播放）
    imageView.animationRepeatCount = 0;
    //开始播放动画
    [imageView startAnimating];
    
    
}

- (void)buttonUI {
    CGFloat with = (SCREEN_WIDTH - 80 * 5)/6;
    [self buttonWithFrame:CGRectMake(with*2 + 80, SCREEN_HEIGHT - 50, 80, 50) tag:1002 title:@"奖品展示"];
    [self buttonWithFrame:CGRectMake(with*3 + 80*2, SCREEN_HEIGHT - 50, 80, 50) tag:1003 title:@"抽奖"];
    [self buttonWithFrame:CGRectMake(with*4 + 80*3, SCREEN_HEIGHT - 50, 80, 50) tag:1004 title:@"初始化"];
}

- (void)buttonWithFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

/**
 *  每个按钮的不同显示
 */
-(void)clickButton:(UIButton *)send {
    switch (send.tag) {
        case 1001:
            //开场动画
            //[self startTheAnimationTT];
            break;
        case 1002:
            //奖品展示
            [self awardsShow];
            break;
        case 1003:
            //抽奖
            [self beganToDraw];
            break;
        case 1004:
            //初始化
            [self theWinners];
            break;
        case 1005:
            //获奖名单
            //[self theEndOfTheAnimation];
            break;
        default:
            break;
    }
    
}

/**
 *  开场动画
 */
- (void)startTheAnimation {
    
        [APP_DELEGATE aksInfoMessageFor:3 withMessage:@"铭师堂2016年团拜会抽奖" withFontSize:55 ShowTextOnly:YES IsAnimationRequired:YES ClearPreviousMessages:YES ColorWithR:244 G:166 B:0 IsBlinking:NO IsWritingAnimation:YES Frame:CGRectMake(0, 450, SCREEN_WIDTH, 160)];
        //[self performSelector:@selector(openOtherTitle) withObject:self afterDelay:2];
}

- (void)openOtherTitle {
    
    [APP_DELEGATE infoMessageFor:3 withMessage:@"@升学e网通 研发部 移动端产品部" withFontSize:25 ShowTextOnly:YES IsAnimationRequired:YES ClearPreviousMessages:YES ColorWithR:244 G:166 B:0 IsBlinking:NO IsWritingAnimation:YES Frame:CGRectMake(500, 530, 500, 60)];
}
#pragma mark 奖品展示
/**
 *  奖品展示
 */
- (void)awardsShow {
    
    
    [giftImageArr removeAllObjects];
    
    if (firstClick == YES) {
        
        [self networkRequestWithDifferentInterface:@"image"];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH - 240, 0)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        bgView.tag = 2001;
        [self.view addSubview:bgView];
        
        giftLabel  = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, bgView.frame.size.width - 100, 30)];
        giftLabel.textColor = RGB(250, 197, 3);
        giftLabel.font = KFont(35);
        giftLabel.text = giftImageName;
        giftLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:giftLabel];
        
        CGFloat bgViewWith = bgView.frame.size.width;
        CGFloat with = (bgViewWith - 100)/3;
        
        //第一张
        imageViewFour = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, with, 0)];
        imageViewFour.alpha = 0.5;
        [bgView addSubview: imageViewFour];
         //第二张
        imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(50+with, 0, with, 0)];
        imageViewTwo.alpha = 0.5;
        [bgView addSubview:imageViewTwo];
        //第三张
        imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(75+with*2, 0, with, 0)];
        imageViewThree.alpha = 0.5;
        [bgView addSubview:imageViewThree];

        
        
        imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, with, 0)];
        [bgView addSubview:imageViewOne];
        
        NSMutableArray *imgArray = [NSMutableArray array];
        for (int i=1; i<13; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"猴子%d.tiff",i]];
            [imgArray addObject:image];
        }
        //把存有UIImage的数组赋给动画图片数组
        imageViewOne.animationImages = imgArray;
        //设置执行一次完整动画的时长
        imageViewOne.animationDuration = 12*0.15;
        //动画重复次数 （0为重复播放）
        imageViewOne.animationRepeatCount = 0;
        //开始播放动画
        [imageViewOne startAnimating];
        
        
        [UIView animateWithDuration:4.0
                              delay:0.0
             usingSpringWithDamping:0.7
              initialSpringVelocity:3.0
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             //
                             bgView.frame = CGRectMake(120, 0, SCREEN_WIDTH - 240, SCREEN_HEIGHT - 120);
                             imageViewOne.frame = CGRectMake(25, 170, with, with);
                             imageViewFour.frame = CGRectMake(25, 170, with, with);
                             imageViewTwo.frame = CGRectMake(50+with, 170, with, with);
                             imageViewThree.frame = CGRectMake(75+with*2, 170, with, with);
                             
                             

                             firstClick = NO;
                             
                          
                             
                             [self performSelector:@selector(theMonkeyRanFast) withObject:nil afterDelay:3.0];
                         } completion:^(BOOL finished) {
                             //
                         }];
    }
    
    
}

- (void)theMonkeyRanFast {
    
    if (curtindex == 0) {
        imageViewFour.alpha = 1;
    } else if (curtindex == 1) {
        imageViewTwo.alpha = 1;
    } else if (curtindex == 2) {
        imageViewThree.alpha = 1;
    }
    
    
    CGFloat bgViewWith = bgView.frame.size.width;
    CGFloat with = (bgViewWith - 100)/3;
    if (number<imageCount) {
        number ++;
    }
    
    
    [UIView animateWithDuration:3.0
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:3.0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         giftLabel.text = giftImageName;
                         if (number<imageCount) {
                             imageViewOne.frame = CGRectMake(25 + (with + 25)*number, 170, with, with);
                         } else {
                             imageViewOne.frame = CGRectMake(25 + (with + 25)*2, 0, with, 0);
                         }
                         
                         if (number == 1) {
                             
                             [imageViewFour sd_setImageWithURL:[NSURL URLWithString:giftImageArr[0]]];
                         } else if (number == 2) {
                             
                              [imageViewTwo sd_setImageWithURL:[NSURL URLWithString:giftImageArr[1]]];
                         } else if (number == 3) {
                             
                              [imageViewThree sd_setImageWithURL:[NSURL URLWithString:giftImageArr[2]]];
                         }
                         
                         
                         
                     } completion:^(BOOL finished) {
                         //
                     }];
    if (number<imageCount) {
     [self performSelector:@selector(theMonkeyRanFast) withObject:nil afterDelay:3.0];
    }
}

- (void)loadingImageView:(UIView *)view {
    CGFloat bgViewWith = view.frame.size.width;
    CGFloat with = (bgViewWith - 100)/3;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25+(with+25)*i, 170, with, with)];
        imageView.image = [UIImage imageNamed:@"bg1234.jpg"];
        [view addSubview:imageView];
    }
    
}

- (void)tapGesture{
    firstClick = YES;
    CGFloat bgViewWith = bgView.frame.size.width;
    CGFloat with = (bgViewWith - 100)/3;
    [UIView animateWithDuration:4.0
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:3.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         //
                         bgView.frame = CGRectMake(120, 0, SCREEN_WIDTH - 240, 0);
                         imageViewFour.frame = CGRectMake(25, 0, with, 0);
                         imageViewOne.frame = CGRectMake(25, 0, with, 0);
                         imageViewTwo.frame = CGRectMake(50+with, 0, with, 0);
                         imageViewThree.frame = CGRectMake(75+with*2, 0, with, 0);
                         number = 0;
                         [self performSelector:@selector(removeViewFromeSuperView) withObject:nil afterDelay:1.0];
                     } completion:^(BOOL finished) {
                         //
                     }];
    
}

- (void)removeViewFromeSuperView {

    [self removeViewWithFormeView:self.view Tag:2001];
}

- (void)removeViewWithFormeView:(UIView *)view Tag:(NSInteger)tag {
    
    for(id tmpView in [view subviews])
    {
        //找到要删除的子视图的对象
        if([tmpView isKindOfClass:[UIView class]])
        {
            UIView *view = (UIView *)tmpView;
            if(view.tag == tag)   //判断是否满足自己要删除的子视图的条件
            {
                [view removeFromSuperview]; //删除子视图
                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
            }
        }
    }
}

#pragma mark 开始触发, 发奖

- (void)beganToDraw {
    UIButton *button = (UIButton *)[self.view viewWithTag:1003];
    button.enabled = NO;
    [clickArr removeAllObjects];
    [self networkRequestWithDifferentInterface:@"times"];
    [self theCountdown];
    [self.sfCountdownView start];
    
}

- (void)theCountdown {
    self.sfCountdownView = [[SFCountdownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.sfCountdownView.delegate = self;
    self.sfCountdownView.backgroundAlpha = 0.2;
    self.sfCountdownView.countdownColor = RGB(253, 254, 198);
    self.sfCountdownView.countdownFrom = 3;
    self.sfCountdownView.tag = 2002;
    self.sfCountdownView.finishText = @"GO";
    [self.sfCountdownView updateAppearance];
    [self.view addSubview:_sfCountdownView];
}

- (void) countdownFinished:(SFCountdownView *)view
{
    [self.sfCountdownView removeFromSuperview];
    [self.view setNeedsDisplay];    
    
    if (startClick == YES) {
        //开始落钱包
        myTimer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
        startClick = NO;
    } else {
        [myTimer setFireDate:[NSDate distantPast]];
    }
}


//初始化红包雨
static int i = 0;
- (void)makeSnow
{
    i = i + 1;
    if ([_imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        imageView.tag = i;
        [_imagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }
}

//红包雨
- (void)snowFall:(UIImageView *)aImageView
{
    self.view.userInteractionEnabled = YES;
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];//arc4random()%6+3
    NSInteger arc = arc4random()%(9-speeds) + speeds;
    [UIView setAnimationDuration:arc];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
    [_imagesLayer addObject:aImageView];
    [UIView commitAnimations];
}

//红包超出屏幕
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
    float x = IMAGE_WIDTH;
    imageView.hidden = NO;
    imageView.frame = CGRectMake(IMAGE_X, -80, x, x);
    [_imagesArray addObject:imageView];
    [_imagesLayer removeObjectAtIndex:0];
}

#pragma mark -- 点击红包
/**
 *  点击获取layer 并把layer区域范围内的红包隐藏掉
 */
-(void)click:(UITapGestureRecognizer *)tapGesture {
    
    if (firstClick == NO) {
        //
        [self tapGesture];
    }
    
    if (_headerNumber >= luckynum - 1) {//如果超过20就不让点击同时关闭红包
        [myTimer setFireDate:[NSDate distantFuture]];
    } else {
        
        //调取接口
        
        
        
        
        CGPoint touchPoint = [tapGesture locationInView:self.view];
        clickFrame = touchPoint;
        for (int i = 0; i < _imagesLayer.count; i++) {
            UIImageView *imageView = _imagesLayer[i];
            
            CALayer *movingLayer = imageView.layer;
            if ([movingLayer.presentationLayer hitTest:touchPoint]) {
                imageView.hidden = YES;
                
                
                [self networkRequestWithDifferentInterface:@"click"];
               
                clickImage = [[UIImageView alloc] initWithFrame:CGRectMake(touchPoint.x - 120, touchPoint.y - 100, 240, 200)];
                clickImage.image = [UIImage imageNamed:@"宝箱-1.png"];
                clickImage.tag = 2220;
                [self.view addSubview:clickImage];
                
                
               
            }
        }
    }
    
}


#pragma mark - 18 为请求出的数字
/**
 *  检测, 如果headerNumber>18则停止红包并实现现实所有的中奖名单
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    
    if (self.headerNumber>=luckynum - 1) {
        
         [myTimer setFireDate:[NSDate distantFuture]];
        for (int i = 0; i< _imagesLayer.count; i++) {
            UIImageView *imageView = [_imagesLayer objectAtIndex:i];
            imageView.hidden = YES;
        }
        [self performSelector:@selector(hiddenView) withObject:self afterDelay:2];
       
    }
}

/**
 *  两侧头像移除
 */
- (void)hiddenView {
    
    self.headerNumber = -1;
    headerLeft = -1;
    headerRight = -1;
    
    [self removeViewWithFormeView:self.view Tag:2200];
    [self removeViewWithFormeView:self.view Tag:2201];
    //展示获奖名单
    [self createdToShowTheWinningListView];
}



/**
 *  创建展示获奖名单View
 */
- (void)createdToShowTheWinningListView {

    UIImage* image;
    _step = 2.5;
    
    image = [UIImage imageNamed:@"卷轴-1.png"];
    _leftView = [[UIImageView alloc] initWithImage:image];
    [_leftView setFrame:CGRectMake(450, 60, 70, 600)];
    _leftView.tag = 2020;
    [self.view addSubview:_leftView];
    image = nil;
    
    image = [UIImage imageNamed:@"mid_background.png"];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame) - 13, 120, 5,  440)];
    [_contentView setClipsToBounds:YES];
    _contentView.tag = 2021;
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    
    image = [UIImage imageNamed:@"卷轴-2.png"];
    _textImgView = [[UIImageView alloc] initWithImage:image];
    _textImgView.backgroundColor = [UIColor clearColor];
    _textImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 800);
    [_contentView addSubview:_textImgView];
    
    UIImageView *carView = [[UIImageView alloc] initWithFrame:CGRectMake(120 * 3 + 20, 380, 515/2, 86/2)];
    carView.image = [UIImage imageNamed:@"获奖名单-2.png"];
    [_textImgView addSubview:carView];
    

    image = nil;
    
    image = [UIImage imageNamed:@"卷轴-3.png"];
    _rightView = [[UIImageView alloc] initWithImage:image];
    [_rightView setFrame:CGRectMake(CGRectGetMaxX(_contentView.frame)-20, 60, 70, 600)];
    _rightView.tag = 2022;
    [self.view addSubview:_rightView];
    
    image = nil;
    [NSTimer scheduledTimerWithTimeInterval:1.0/120 target:self selector:@selector(timerFunction:) userInfo:nil repeats:YES];
}

/**
 *  圣旨展示动画
 *
 *  @param timer 圣旨
 */
- (void)timerFunction:(NSTimer *)timer
{
    
    [_rightView setCenter:CGPointMake(_rightView.center.x+_step, _rightView.center.y)];
    [_leftView setCenter:CGPointMake(_leftView.center.x-_step, _leftView.center.y)];
    [_contentView setFrame:CGRectMake(_contentView.frame.origin.x-_step, _contentView.frame.origin.y, _contentView.bounds.size.width+_step*2, _contentView.bounds.size.height)];
    
    _textImgView.center = CGPointMake(_contentView.bounds.size.width/2.0, _contentView.bounds.size.height);
    
    //圣旨展开边界
    if (_leftView.frame.origin.x <= 75 || _rightView.frame.origin.x >= 1024-_rightView.bounds.size.width) {
        [timer invalidate];
        
        for (int i = 0; i< bgViewArr.count; i++) {
            //找到每个奖品view
            UIView *view = bgViewArr[i];
            view.tag = 2100 + i;
            ClickModel *clickModel = clickArr[i];
            //找到奖品view上的image并增大frame
            for(id tmpView in [view subviews])
            {
                //找到要删除的子视图的对象
                if([tmpView isKindOfClass:[UIImageView class]])
                {
                    UIImageView *imageView = (UIImageView *)tmpView;
                    CGRect frome = imageView.frame;
                    frome.size.height += 10;
                    imageView.frame = frome;

                }
                //改变label的颜色和显示
                if([tmpView isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)tmpView;
                    label.text = [NSString stringWithFormat:@"%@ %@", clickModel.userNo, clickModel.userName];
                    label.textColor = [UIColor blackColor];
                    label.frame = CGRectMake(0, SCREEN_HEIGHT/10, 100, 10);
                    break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                    
                }
            }

            //改变名单位置
            [UIView animateWithDuration:1
                             animations:^{
                                 int row=i/7;//行号
                                 int loc=i%7;//列号
                                 view.frame = CGRectMake(125 + loc*110, 230  + 100*row, 100, 100);
                             }];
        }
    }
}


/**
 *  圣旨上创建的view
 *
 *  @param bgHeadView bgView
 */
- (void)createView:(UIView *)bgHeadView f:(int)i{
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgHeadView.frame.size.width, bgHeadView.frame.size.height - 20)];
    image.image = [UIImage imageNamed:@"5.jpg"];
    [bgHeadView addSubview:image];
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(image.frame)+2.5, bgHeadView.frame.size.width - 10, 15)];
    label.text = [NSString stringWithFormat:@"7*%d", i];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = KFont(15);
    label.textColor = [UIColor blackColor];
    [bgHeadView addSubview:label];
    //    return view;
}

#pragma mark 初始化
- (void)theWinners {
    
    //删除圣旨
    for (int i = 0; i < 3; i++) {
        NSInteger tag = 2020 + i;
        [self removeViewWithFormeView:self.view Tag:tag];
    }
    
    //删除中奖名单
    for (int i = 0; i < bgViewArr.count; i++) {
        NSInteger tag = 2100 + i;
        [self removeViewWithFormeView:APP_DELEGATE.window Tag:tag];
    }
    
    //移除数组
    [bgViewArr removeAllObjects];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1003];
    button.enabled = YES;
    
}
#pragma mark  网络请求 根据不同的接口请求
- (void)networkRequestWithDifferentInterface:(NSString *)inter {
    
    NSString *str = @"";
    if ([inter isEqualToString:@"times"]) {//用于显示第几轮第几个
        str=[NSString stringWithFormat:@"http://10.0.0.242:8128/apilucky/getroundata.htm"];
    } else if ([inter isEqualToString:@"person"]) {//获奖人名单
        str=[NSString stringWithFormat:@"http://10.0.0.242:8128/apilucky/getluckyperson.htm"];
    } else if ([inter isEqualToString:@"click"]) {//点击触发接口
        str=[NSString stringWithFormat:@"http://10.0.0.242:8128/apilucky/singlelucky.htm"];
    } else if ([inter isEqualToString:@"image"]) {//奖品
        str=[NSString stringWithFormat:@"http://10.0.0.242:8128/apilucky/getluckyimage.htm"];
    }
    
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager GET:url.absoluteString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //
             
           NSInteger code =  [[responseObject objectForKey:@"code"] integerValue];
             if (code == 200) {
                 [self basedOnTheDataWithInter:inter responseObject:responseObject];
             } else {
                if ([inter isEqualToString:@"click"]) {
                     //
                    clickImage.image = [UIImage imageNamed:@"宝箱-2.png"];
                    [self performSelector:@selector(fromValueJitter) withObject:self afterDelay:0.5];
                    clickSuccess = NO;
                 }
             
             }
          
             //NSLog(@"%@", responseObject);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             
             if ([inter isEqualToString:@"click"]) {
                 //
                 clickImage.image = [UIImage imageNamed:@"宝箱-2.png"];
                 [self performSelector:@selector(fromValueJitter) withObject:self afterDelay:0.5];
                 clickSuccess = NO;
             }
             NSLog(@"%@", error);
              
             
         }];
}


- (void)basedOnTheDataWithInter:(NSString *)inter responseObject:(id  _Nullable)responseObject{
    if ([inter isEqualToString:@"times"]) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       NSString *text = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"luckyname"]];
        
        luckynum = [[responseObject objectForKey:@"luckynum"] integerValue];
        speeds = [[responseObject objectForKey:@"downspeed"] integerValue];
        [self getTimesWithText:text luckynum:luckynum];
        
    } else if ([inter isEqualToString:@"person"]) {
    
    } else if ([inter isEqualToString:@"click"]) {
        
        ClickModel *clickModel = [[ClickModel alloc] initWithDic:[responseObject objectForKey:@"data"]];
        [clickArr addObject:clickModel];
        workNumber = clickModel.userNo;
        
        clickSuccess = YES;
        clickImage.image = [UIImage imageNamed:@"宝箱.png"];
        [self performSelector:@selector(fromValueJitterT) withObject:self afterDelay:0.5];
        
    } else if ([inter isEqualToString:@"image"]) {
        giftImageArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"imagelist"]];
        giftImageName = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"luckyname"]];
        curtindex = [[responseObject objectForKey:@"curtindex"] integerValue];
        curtindex = 2;
        imageCount = [[responseObject objectForKey:@"imagecount"] integerValue];
    }
}

#pragma mark 开始
//创建并显示第几轮多少幸运观众
- (void)getTimesWithText:(NSString *)text luckynum:(NSInteger)ll {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, SCREEN_WIDTH - 400, 30)];
    label.font = KFont(30);
    label.textColor = RGB(252, 254, 211);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.tag = 2200;
    [self.view addSubview:label];
    
    
    timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 100, CGRectGetMaxY(label.frame) + 10, 150, 20)];
    timesLabel.font = KFont(18);
    timesLabel.textColor = RGB(252, 254, 211);
    timesLabel.text = [NSString stringWithFormat:@"共%ld名, 第0名", luckynum];
    timesLabel.tag = 2201;
    [self.view addSubview:timesLabel];
}

#pragma mark 点击
- (void)clickGift {

    timesLabel.text = [NSString stringWithFormat:@"共%ld名, 第%ld名", luckynum, _headerNumber + 2];
    //隐藏*
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:workNumber];
    [String1 replaceCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
    
    
    
    self.headerNumber += 1;
    UIView *view = nil;
    
    if (_headerNumber%2 == 0) {
        headerLeft +=1;
        view = [self popTTUpView:0 userNo:String1];
    } else {
        headerRight += 1;
        view = [self popTTUpView:SCREEN_WIDTH - 100 userNo:String1];
    }
    
    [UIView animateWithDuration:1 animations:^{
        NSInteger tt = 0;
        NSInteger bb = 0;
        if (_headerNumber%2==0) {
            tt = headerLeft;
            bb = 0;
        } else {
            tt = headerRight;
            bb = SCREEN_WIDTH - 100;
        }
        // 设置view弹出来的位置
        view.frame = CGRectMake(bb, 0 + (SCREEN_HEIGHT/10)*tt, 100, SCREEN_HEIGHT/10);
        [bgViewArr addObject:view];
    }];
}

//创建两侧头像
- (UIView *)popTTUpView:(CGFloat)heigt userNo:(NSString *)userNo{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(heigt, SCREEN_HEIGHT, 100, SCREEN_HEIGHT/10)];
    [APP_DELEGATE.window addSubview:view];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100 - 10, (SCREEN_HEIGHT/10 -20))];
    image.image = [UIImage imageNamed:@"default123.jpg"];
    [view addSubview:image];
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(image.frame)+2.5, 90, 15)];
    label.text = userNo;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = KFont(15);
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}


#pragma mark 抖动
- (void)fromValueJitter {

    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.2];
    
    shake.toValue = [NSNumber numberWithFloat:+0.2];
    
    shake.duration = 0.05;
    
    shake.autoreverses = YES; //是否重复
    
    shake.repeatCount = 4;
    
    [clickImage.layer addAnimation:shake forKey:@"imageView"];
    
    clickImage.alpha = 1.0;

    //1秒后移除
    [self performSelector:@selector(releaseImage) withObject:self afterDelay:0.8];
    
}

//移除效果并处理事件
- (void)releaseImage {
    [self removeViewWithFormeView:self.view Tag:2220];
}

- (void)fromValueJitterT {
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.2];
    shake.toValue = [NSNumber numberWithFloat:+0.2];
    shake.duration = 0.05;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 4;
    [clickImage.layer addAnimation:shake forKey:@"imageView"];
    clickImage.alpha = 1.0;
    //1秒后移除
    [self performSelector:@selector(releaseImageT) withObject:self afterDelay:0.8];
    
}

//移除效果并处理事件
- (void)releaseImageT {
    [self removeViewWithFormeView:self.view Tag:2220];
    
    [self clickGift];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
