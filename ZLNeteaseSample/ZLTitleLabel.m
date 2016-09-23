//
//  ZLTitleLabel.m
//  ZLNeteaseSample
//
//  Created by angelen on 16/9/23.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import "ZLTitleLabel.h"

// 默认状态下的 rgb 值
static CGFloat const kRedNormal      = 0.99;
static CGFloat const kGreenNormal    = 0.48;
static CGFloat const kBlueNormal     = 0.22;

// 高亮状态下的 rgb 值
static CGFloat const kRedHighlight   = 0.31;
static CGFloat const kGreenHighlight = 0.53;
static CGFloat const kBlueHighlight  = 1.00;

@implementation ZLTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置默认的显示属性
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor colorWithRed:kRedNormal green:kGreenNormal blue:kBlueNormal alpha:1];
        self.font = [UIFont systemFontOfSize:16];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    // 这样子计算就可以得到区间为 [1.0, 1.2] 的结果了，因为 scale 最大为 1， 最小为 0
    CGFloat transformScale = 1 + scale * 0.2; // [1.0, 1.2]
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
    self.textColor = [UIColor colorWithRed:kRedNormal + (kRedHighlight - kRedNormal) * scale
                                     green:kGreenNormal + (kGreenHighlight - kGreenNormal) * scale
                                      blue:kBlueNormal + (kBlueHighlight - kBlueNormal) * scale
                                     alpha:1];
    /**
     // R  G  B  A
     // 1  0  0  1  红色
     // 0  0  0  1  黑色
     // 从 1 -> 0，越靠近 0，为黑色
    
     // 0  0  1  1  蓝色
     // 1  1  1  1  白色
     // 从 0 -> 1，越靠近 1，为白色
    
     // .3 .6 .8  1  普通颜色
     // 1  1  0  1  白色
    
     先看看如何从 0.3 慢慢增长到 1
     
     red = 0.3 + (1 - 0.3) * scale
     当 scale = 1 的时候，red = 1.0，当 scale = 0 的时候，red = 0.0，逐渐递增
     
     再看看如何从 0.8 慢慢减到 0
     blue = 0.8 + (0 - 0.8) * scale
     当 scale = 1 的时候，blue = 0.0，当 scale = 0 的时候，red = 0.8，逐渐递减
     
     // R    G    B
     // 0.1  0.9  0.3
     // 0.6  0.2  0.3
     这就尴尬了，原来公式一样的
     red = 0.1 + (0.6 - 0.1) * scale
     green = 0.9 + (0.2 - 0.9) * scale 
     blue = 0.3 + (0.3 - 0.3) * scale
     */

}

@end
