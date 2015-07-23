//
//  GBLoopView.h
//  跑马灯效果
//
//  Created by 张国兵 on 15/7/20.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    GBLoopDirectionLeft,
    GBLoopDirectionRight,
}GBLoopDirection;


@interface GBLoopView : UIView{
  
    // 记录
    int currentIndex;
    
    //是否循环（默认为YES）
    BOOL loops;
    
    // 当前状态
    BOOL running;
    
    // 内容载体
    UILabel *tickerLabel;
    

}

/**
 *  跑马灯loop速度
 */
@property(nonatomic) float Speed;
/**
 *  显示的内容(支持多条数据)
 */
@property(nonatomic, retain) NSArray *tickerStrings;
/**
 * loop方向(左/右)
 */
@property(nonatomic) GBLoopDirection Direction;

/**
 *  开启
 */
-(void)start;
/**
 *  暂停
 */
-(void)pause;
/**
 *  复位
 */
-(void)resume;
@end
