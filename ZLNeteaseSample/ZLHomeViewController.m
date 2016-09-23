//
//  ZLHomeViewController.m
//  ZLNeteaseSample
//
//  Created by angelen on 16/9/19.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import "ZLHomeViewController.h"
#import "ZLGameTableViewController.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

static CGFloat const kStatusBarHeight       = 20.0;
static CGFloat const kNavBarHeight          = 44.0;
static CGFloat const kTitleScrollViewHeight = 44.0;

@interface ZLHomeViewController ()

/** 标题 ScrollView */
@property (strong, nonatomic) UIScrollView *titleScrollView;

/** 内容 ScrollView */
@property (strong, nonatomic) UIScrollView *contentScrollView;

// 静静的测试内容
@property (strong, nonatomic) NSArray *titles;

@end

@implementation ZLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"App Store";
    self.view.backgroundColor = [UIColor greenColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titles = @[@"游戏", @"娱乐", @"儿童", @"教育", @"购物", @"摄影", @"生活", @"音乐"];
    
    // 添加标题
    [self addTitles];
    
    // 添加内容
    [self addContents];
}

- (void)addTitles {
    self.titleScrollView = [[UIScrollView alloc] init];
    self.titleScrollView.frame = CGRectMake(0, kStatusBarHeight + kNavBarHeight, SCREEN_WIDTH, kTitleScrollViewHeight);
    self.titleScrollView.backgroundColor = [UIColor redColor];
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.titleScrollView];
    
    CGFloat titleWidth = 100;
    CGFloat titleHeight = 44;

    for (NSInteger i = 0; i < self.titles.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(i * titleWidth, 0, titleWidth, titleHeight);
        titleLabel.text = self.titles[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.tag = i;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleDidTap:)]];
        [self.titleScrollView addSubview:titleLabel];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(titleWidth * self.titles.count, 0);
}

- (void)addContents {
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.frame = CGRectMake(0, kStatusBarHeight + kNavBarHeight + kTitleScrollViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.contentScrollView.backgroundColor = [UIColor purpleColor];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    [self.view addSubview:self.contentScrollView];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        ZLGameTableViewController *gameVC = [[ZLGameTableViewController alloc] init];
        gameVC.title = self.titles[i];
        gameVC.tableView.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight - kNavBarHeight - kTitleScrollViewHeight);
        [self addChildViewController:gameVC];
        [self.contentScrollView addSubview:gameVC.tableView];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titles.count, 0);
}

- (void)titleDidTap:(UITapGestureRecognizer *)recognizer {
    NSInteger tag = recognizer.view.tag;
    NSLog(@"点击了 %zd, %@", tag, self.titles[tag]);
}

@end
