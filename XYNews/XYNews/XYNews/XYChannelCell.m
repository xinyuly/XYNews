//
//  XYNews
//
//  Created by lixinyu on 16/10/21.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "XYChannelCell.h"
#import "XYnewsController.h"

@interface XYChannelCell ()

@end
@implementation XYChannelCell

- (void)setNewsVC:(XYnewsController *)newsVC{
    _newsVC = newsVC;
    [self addSubview:self.newsVC.view];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.newsVC.view.frame = self.bounds;
}
@end
