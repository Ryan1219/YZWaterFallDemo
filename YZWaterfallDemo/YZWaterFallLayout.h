//
//  YZCollectionViewLayout.h
//  YZWaterfallDemo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 TengNaDesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZWaterFallLayout;

/** 代理 **/
@protocol YZWaterFallLayoutDelegate <NSObject>

@required
- (CGFloat)waterFallLayout:(YZWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout;
- (CGFloat)columnMarginInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout;
- (CGFloat)rowMarginInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout;
- (UIEdgeInsets)edgeInsetsInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout;

@end

@interface YZWaterFallLayout : UICollectionViewLayout

/** 声明协议 **/
@property (nonatomic,weak) id<YZWaterFallLayoutDelegate>delegate;

@end







