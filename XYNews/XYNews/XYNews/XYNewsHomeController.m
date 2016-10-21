//
//  ViewController.m
//  XYNews
//
//  Created by lixinyu on 16/10/21.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "XYNewsHomeController.h"
#import "XYChannelLabel.h"
#import "XYChannelCell.h"
#import "XYnewsController.h"

@interface XYNewsHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource,XYChannelLabelDelegate>
@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray   *arrChannel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableDictionary*cellCache;
@end

@implementation XYNewsHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrChannel = @[@"头条",@"社会",@"娱乐",@"军事",@"社区报",@"搞笑",@"游戏吧",@"头条22",@"社会22",@"娱乐22",@"军事2",@"社区报rr",@"搞笑6",@"游戏吧66"];
    [self initSubview];
    [self setupChannel];
}

- (void)initSubview {
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 44);
    
    [self.view addSubview:self.collectionView];
    [self.collectionView setFrame:CGRectMake(0,108, self.view.bounds.size.width, CGRectGetHeight(self.view.bounds)-44)];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setBounces:YES];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = self.collectionView.frame.size;
    self.layout.minimumInteritemSpacing=0;
    self.layout.minimumLineSpacing=0;
    [self.collectionView registerClass:[XYChannelCell class] forCellWithReuseIdentifier:@"XYChannelCell"];
}

-(void)setupChannel{
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSInteger count = self.arrChannel.count;
    CGFloat margre = 8;
    CGFloat labelX = margre;
    for (NSInteger index = 0; index < count; index++) {
        NSString *title = self.arrChannel[index];
        XYChannelLabel *label = [XYChannelLabel labelWithTitle:title];
        label.frame=CGRectMake(labelX, 0, label.frame.size.width+10, self.scrollView.frame.size.height);
        [self.scrollView addSubview:label];
        label.delegate = self;
        labelX += label.frame.size.width;
        label.tag = index;
    }
    self.scrollView.contentSize=CGSizeMake(labelX+margre, 0);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    //设置默认的选中第一个
    self.currentIndex=0;
    XYChannelLabel *labelNo=self.scrollView.subviews[self.currentIndex];
    labelNo.scale=1;
}
//cache
- (XYnewsController*)newsVCWith:(NSString*)key{
    XYnewsController *newsVC = self.cellCache[key];
    if (newsVC == nil) {
        newsVC = [[XYnewsController alloc] init];
        [self.cellCache setObject:newsVC forKey:key];
    }
    return newsVC;
}

- (void)channelLabel:(XYChannelLabel *)label didSelectIndex:(NSInteger)index {
//    XYChannelLabel *label=self.scrollView.subviews[index];
    self.currentIndex = index;
    label.scale = 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
    CGFloat banW = [UIScreen mainScreen].bounds.size.width*0.5;
    CGFloat centerLabelX = label.center.x;
    CGFloat offsetX = centerLabelX - banW;
    CGFloat maxOffset = self.scrollView.contentSize.width - banW*2;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffset) {
        offsetX = maxOffset;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currentIndex = scrollView.contentOffset.x/self.collectionView.frame.size.width;
    XYChannelLabel *label = self.scrollView.subviews[self.currentIndex];
    [self channelLabel:label didSelectIndex:label.tag];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获得标签
    XYChannelLabel *label = self.scrollView.subviews[self.currentIndex];
    //    label.textColor = [UIColor redColor];
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    XYChannelLabel* nextLabel=nil;
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item != self.currentIndex) {
            nextLabel = self.scrollView.subviews[indexPath.item];
            break;
        }
    }
    //缩放比例
    CGFloat nextLabelScale = ABS((CGFloat)scrollView.contentOffset.x/scrollView.bounds.size.width-self.currentIndex);
    CGFloat currentLabelScale = 1-nextLabelScale;
    label.scale = currentLabelScale;
    nextLabel.scale = nextLabelScale;
}
#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrChannel.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.arrChannel[indexPath.item];
    self.currentIndex = collectionView.contentOffset.x/self.collectionView.frame.size.width;
    XYChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYChannelCell" forIndexPath:indexPath];
    //将上一个的移除
    [cell.newsVC.view removeFromSuperview];
    XYnewsController *newvc = [self newsVCWith:title];
    if (![self.childViewControllers containsObject:newvc]) {
        [self addChildViewController:newvc];
    }
    cell.newsVC = newvc;
    return cell;
}
#pragma mark - setter &getter
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake(140, 122)];
        [_layout setMinimumInteritemSpacing:10];
        
    }
    return _layout;
}

- (NSArray *)arrChannel{
    if (_arrChannel == nil) {
        _arrChannel = [NSArray array];
    }
    return _arrChannel;
}

- (NSMutableDictionary *)cellCache{
    if (_cellCache == nil) {
        _cellCache = [NSMutableDictionary dictionary];
    }
    return _cellCache;
}
@end
