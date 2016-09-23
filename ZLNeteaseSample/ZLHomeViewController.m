//
//  ZLHomeViewController.m
//  ZLNeteaseSample
//
//  Created by angelen on 16/9/19.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import "ZLHomeViewController.h"
#import "ZLTitleLabel.h"
#import "ZLGameTableViewController.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define ZL_COLOR_INDICATOR_VIEW [UIColor redColor]

static CGFloat const kStatusBarHeight       = 20.0;
static CGFloat const kNavBarHeight          = 44.0;
static CGFloat const kTitleScrollViewHeight = 44.0;
static CGFloat const kTitleLabelWidth       = 100.0;
static CGFloat const kTitleLabelHeight      = 44.0;
static CGFloat const kIndicatorViewHeight   = 5.0;
static CGFloat const kIndicatorViewWidth    = 100.0;// 暂时和标题一样宽度

@interface ZLHomeViewController ()<UIScrollViewDelegate>

/** 标题 ScrollView */
@property (strong, nonatomic) UIScrollView *titleScrollView;

/** 内容 ScrollView */
@property (strong, nonatomic) UIScrollView *contentScrollView;

/** 指示器 */
@property (strong, nonatomic) UIView *indicatorView;

// 静静的测试内容
@property (strong, nonatomic) NSArray *titles;

@end

@implementation ZLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小良GG";

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titles = @[@"游戏0", @"娱乐1", @"儿童2", @"教育3", @"购物4", @"摄影5", @"生活6", @"音乐7"];
    
    // 添加标题
    [self addTitles];
    
    // 添加指示器
    [self addIndicator];
    
    // 添加内容
    [self addContents];
    
    // 显示默认子控制器
    UIViewController *currentVC = self.childViewControllers[0];
    currentVC.view.frame = CGRectMake(0 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight - kNavBarHeight - kTitleScrollViewHeight);
    [self.contentScrollView addSubview:currentVC.view];
}

- (void)addIndicator {
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame) - kIndicatorViewHeight, kIndicatorViewWidth, kIndicatorViewHeight)];
    self.indicatorView.backgroundColor = ZL_COLOR_INDICATOR_VIEW;
    [self.view addSubview:self.indicatorView];
}

- (void)addTitles {
    self.titleScrollView = [[UIScrollView alloc] init];
    self.titleScrollView.frame = CGRectMake(0, kStatusBarHeight + kNavBarHeight, SCREEN_WIDTH, kTitleScrollViewHeight);
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.titleScrollView];

    for (NSInteger i = 0; i < self.titles.count; i++) {
        ZLTitleLabel *titleLabel = [[ZLTitleLabel alloc] init];
        titleLabel.frame = CGRectMake(i * kTitleLabelWidth, 0, kTitleLabelWidth, kTitleLabelHeight);
        titleLabel.text = self.titles[i];
        titleLabel.tag = i;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleDidTap:)]];
        
        if (i == 0) {
            titleLabel.scale = 1;
        } else {
            titleLabel.scale = 0;
        }
        
        [self.titleScrollView addSubview:titleLabel];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(kTitleLabelWidth * self.titles.count, 0);
}

- (void)addContents {
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.frame = CGRectMake(0, kStatusBarHeight + kNavBarHeight + kTitleScrollViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    [self.view addSubview:self.contentScrollView];
    
    // 这里一般来说不用 for 循环，除非控制器都一样
    for (NSInteger i = 0; i < self.titles.count; i++) {
        ZLGameTableViewController *gameVC = [[ZLGameTableViewController alloc] init];
        gameVC.title = self.titles[i];
        [self addChildViewController:gameVC];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titles.count, 0);
}

- (void)titleDidTap:(UITapGestureRecognizer *)recognizer {
    NSInteger tag = recognizer.view.tag;
    [self.contentScrollView setContentOffset:CGPointMake(tag * SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 在两个 VC 中切换要知道这两个 VC 的下标分别是哪个
    // 姑且一个为左下标，一个为右下标
    
    // 要注意我们需要的是最后小数点部分（通过 scale - leftIndex）
    CGFloat scale = scrollView.contentOffset.x / SCREEN_WIDTH;
    NSUInteger leftIndex = scale;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= self.titles.count) {
        rightIndex = self.titles.count - 1;
    }

    ZLTitleLabel *leftTitleLabel = self.titleScrollView.subviews[leftIndex];
    ZLTitleLabel *rightTitleLabel = self.titleScrollView.subviews[rightIndex];
    
    rightTitleLabel.scale = scale - leftIndex;
    leftTitleLabel.scale = 1 - rightTitleLabel.scale;
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.2];// 设置为 0，就不会有移动的“惯性”；更好看一点，可以设置一个小一点的数值
    [UIView setAnimationDelegate:self];
    self.indicatorView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x / self.titles.count, 0);
    [UIView commitAnimations];
}

// Tells the delegate that the scroll view has ended decelerating the scrolling movement.
// called when scroll view grinds to a halt
// 注意是手指松开 scrollView 后，scrollView 停止减速完毕的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    ZLTitleLabel *currentTitleLabel = self.titleScrollView.subviews[currentIndex];
    
    CGPoint titleMoveOffset = self.titleScrollView.contentOffset;
    titleMoveOffset.x = currentTitleLabel.center.x - SCREEN_WIDTH * 0.5;
    
    // 处理左边边界问题
    if (titleMoveOffset.x < 0) {
        titleMoveOffset.x = 0;
    }
    
    // 处理右边边界问题
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - SCREEN_WIDTH;
    if (titleMoveOffset.x > maxOffsetX) {
        titleMoveOffset.x = maxOffsetX;
    }
    [self.titleScrollView setContentOffset:titleMoveOffset animated:YES];
    
    // 添加子控制器
    UIViewController *currentVC = self.childViewControllers[currentIndex];
    currentVC.view.frame = CGRectMake(currentIndex * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight - kNavBarHeight - kTitleScrollViewHeight);
    [self.contentScrollView addSubview:currentVC.view];
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 点击标题的时候会进入这里，它的操作和手动滑动内容 ScrollView 是一样的
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
