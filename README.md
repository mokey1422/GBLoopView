# GBLoopView
#类似支付宝顶部消息的跑马灯效果<br>
##余额宝顶端上面的那个走马灯效果大家还记得吧感觉还是不错的，就稍微写了一下简单的做了一下封装<br>
###如果觉得有用的话请点个星鼓励一下，以后会继续出一些功能性的框架请多多支持，如有bug也请指出，欢迎加入我们,群号433060483
#使用说明:<br>
* 将文件导入到你的工程里面
* 在使用的地方包含头文件，执行下面的代码：
```
    NSArray *loopArrs = [NSArray arrayWithObjects:@"在iOS中动画实现技术主要是：Core Animation", @"我们知道每个UIView都关联到一个CALayer对象，CALayer是Core Animation中的图层。",@"zsc库真好用",nil];
    
    _LoopView = [[GBLoopView alloc] initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width, 30)];
    [_LoopView setDirection:GBLoopDirectionRight];
    [_LoopView setTickerArrs:loopArrs];
    [_LoopView setSpeed:60.0f];
    [self.view addSubview:_LoopView];
    [_LoopView start];
    
```
* loopArrs是你的数据源 （数组）<br>
* setDirection设置走马灯的方向支持从左到右 和从右到左
* setSpeed 设置走马灯的速度
* [_LoopView start]开启操作



##更新

 * 优化滚动的流畅性
 
 * 增添背景View颜色修改方法
 
 * 适配横竖屏（通知）

#效果图：
![image](https://github.com/mokey1422/gifResource/blob/master/loopview.gif)
