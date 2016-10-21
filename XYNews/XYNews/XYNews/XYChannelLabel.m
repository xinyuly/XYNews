//
//  XYNews
//
//  Created by lixinyu on 16/10/21.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//
#import "XYChannelLabel.h"

@implementation XYChannelLabel

+ (instancetype)labelWithTitle:(NSString*)title{
    XYChannelLabel *label = [[XYChannelLabel alloc]init];
    label.text = title;
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    return label;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    CGFloat maScale = (CGFloat)(18-14)/18;
    CGFloat curScale = scale*maScale+1;
    self.transform = CGAffineTransformMakeScale(curScale, curScale);
    self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
}

//点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   //执行
    if (self.didClick) {
          self.didClick();
    }
    if ([self.delegate respondsToSelector:@selector(channelLabel:didSelectIndex:)]) {
        [self.delegate channelLabel:self didSelectIndex:self.tag];
    }
}
@end
