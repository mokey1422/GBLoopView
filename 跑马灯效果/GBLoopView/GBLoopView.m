//
//  GBLoopView.m
//  跑马灯效果
//
//  Created by 张国兵 on 15/7/20.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBLoopView.h"
#import <QuartzCore/QuartzCore.h>
@implementation GBLoopView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setupView];
    }
    return self;
}
-(void)setupView {
    
    [self setBackgroundColor:[UIColor orangeColor]];
    tickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [tickerLabel setBackgroundColor:[UIColor clearColor]];
    
    [tickerLabel setNumberOfLines:1];
    tickerLabel.font=[UIFont boldSystemFontOfSize:15];
    tickerLabel.textColor=[UIColor whiteColor];
    [self addSubview:tickerLabel];
    loops = YES;
    // 默认初始方向是向左
    _Direction = GBLoopDirectionLeft;
}
-(void)animateCurrentTickerString
{
    NSString *currentString = [_tickerStrings objectAtIndex:currentIndex];
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize textSize=[currentString sizeWithAttributes:attrs];

    // 设置起点和终点
    float startingX = 0.0f;
    float endX = 0.0f;
    switch (_Direction) {
        case GBLoopDirectionLeft:
            startingX = -textSize.width;
            endX = self.frame.size.width;
            break;
        case GBLoopDirectionRight:
        default:
            startingX = self.frame.size.width;
            endX = -textSize.width;
            break;
    }
    
   
    [tickerLabel setFrame:CGRectMake(startingX, tickerLabel.frame.origin.y, textSize.width, tickerLabel.frame.size.height)];
    [tickerLabel setText:currentString];
    float duration = (textSize.width + self.frame.size.width) / _Speed;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(tickerMoveAnimationDidStop:finished:context:)];
    CGRect tickerFrame = tickerLabel.frame;
    tickerFrame.origin.x = endX;
    [tickerLabel setFrame:tickerFrame];
    
    [UIView commitAnimations];
}

-(void)tickerMoveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    currentIndex++;
    if(currentIndex >= [_tickerStrings count]) {
        currentIndex = 0;

        if(!loops) {
           
            running = NO;
            
            return;
        }
    }

    [self animateCurrentTickerString];
}

#pragma mark - Ticker Animation Handling
-(void)start {
    
    // 开启动画默认第一条信息
    currentIndex = 0;
    
    // 设置状态
    running = YES;
    
    // 开始动画
    [self animateCurrentTickerString];
}

-(void)pause {
    
    //检查状态运行则暂停运行
    if(running) {
        
        [self pauseLayer:self.layer];
        
        running = NO;
    }
}

-(void)resume {
    
    // 检查状态不运行则恢复运行
    if(!running) { 
        
        [self resumeLayer:self.layer];
        
        running = YES;
    }
}


#pragma mark - UIView layer animations utilities
-(void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
@end
