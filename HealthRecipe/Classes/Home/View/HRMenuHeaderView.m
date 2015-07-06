//
//  HRMenuHeaderView.m
//  
//
//  Created by 王俊仁 on 15/6/23.
//
//

#import "HRMenuHeaderView.h"
#import <Masonry.h>
#import <POP.h>
#import <BlocksKit.h>
#import <POP+MCAnimate.h>
#import <ReactiveCocoa.h>

@interface HRMenuHeaderView()


@property (nonatomic,weak) UIImageView *headView;
@property (nonatomic,strong) NSTimer *animateTimer;
@property (nonatomic,assign,getter=isNotNeedAnimate) BOOL notNeedAnimate;

@end

@implementation HRMenuHeaderView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupNotification];
    }
    return self;
}

- (void)setupSubviews {
    
    UIImage *img = [UIImage circleImageWithName:@"abc.png" borderWidth:3 borderColor:[UIColor whiteColor]];
    UIImageView *headView = [[UIImageView alloc] initWithImage:img];
    [self addSubview:headView];
    self.headView = headView;

    //添加约束abca
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headView.superview);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self addAnimateTimer];
}

#pragma mark - 通知设置
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:MenuDidHideMenuViewControllerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillShow:) name:MenuWillShowMenuViewControllerNotification object:nil];
}

- (void)menuDidHide:(NSNotification *)notification {
    [self removeAnimateTimer];
    self.notNeedAnimate = YES;
}

- (void)menuWillShow:(NSNotification *)notification {
    [self addAnimateTimer];
    self.notNeedAnimate = NO;
}

#pragma mark - 动画
/**
 使用第三方包装框架，POP+MCAnimate.h
 */
- (void)addAnimate2 {
    [self removeAnimateTimer];
    WEAK_SELF(ws)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [NSObject pop_animate:^{
            ws.headView.pop_duration = 2;
            ws.headView.pop_linear.bounds = CGRectMake(0, 0, 180, 180);
        } completion:^(BOOL finished) {
            
            [NSObject pop_animate:^{
                ws.headView.pop_springBounciness = 20;
                ws.headView.pop_springSpeed = 2;
                ws.headView.pop_spring.bounds = CGRectMake(0, 0, 120, 120);
            } completion:^(BOOL finished) {
                [ws.headView pop_removeAllAnimations];
                if (!ws.isNotNeedAnimate) {
                    [ws addAnimateTimer];
                }
            }];
        }];

    });
}

/**
 POP原生动画
 */
- (void)addAnimate {
    [self removeAnimateTimer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //添加动画
        //1、先变大
        POPBasicAnimation *ani1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
        ani1.toValue = [NSValue valueWithCGSize:CGSizeMake(150, 150)];
        ani1.duration = 3;
        ani1.removedOnCompletion = YES;
        WEAK_SELF(ws)
        ani1.completionBlock = ^(POPAnimation *anim, BOOL finished){
            //2、后弹簧回去
            POPSpringAnimation *ani2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
            ani2.toValue = [NSValue valueWithCGSize:CGSizeMake(120, 120)];
            ani2.springBounciness = 20;
            ani2.springSpeed = 2;
            ani2.removedOnCompletion = YES;
            [ws.headView pop_addAnimation:ani2 forKey:@"bcd"];
            ani2.completionBlock = ^(POPAnimation *anim, BOOL finished){
                [ws addAnimateTimer];
            };
        };
        [self.headView pop_addAnimation:ani1 forKey:@"abc"];
    });
    
}

#pragma mark - 定时器管理
- (void)addAnimateTimer {
    [self removeAnimateTimer];
    WEAK_SELF(ws)
    self.animateTimer = [NSTimer bk_scheduledTimerWithTimeInterval:2.0 block:^(NSTimer *timer) {
        [ws addAnimate2];
    } repeats:YES];
}

- (void)removeAnimateTimer {
    [self.animateTimer invalidate];
    self.animateTimer = nil;
}

@end
