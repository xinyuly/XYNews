//
//  XYNews
//
//  Created by lixinyu on 16/10/21.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYChannelLabel;

@protocol XYChannelLabelDelegate <NSObject>
- (void)channelLabel:(XYChannelLabel *)label didSelectIndex:(NSInteger)index;
@end
@interface XYChannelLabel : UILabel

@property (nonatomic, assign) CGFloat scale;//缩放比例
@property (nonatomic, copy)   void(^didClick)();//被点击后的回调
@property (nonatomic, weak)   id<XYChannelLabelDelegate>delegate;

+ (instancetype)labelWithTitle:(NSString*)title;

@end
