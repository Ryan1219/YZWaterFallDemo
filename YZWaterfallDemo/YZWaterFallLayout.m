 //
//  YZCollectionViewLayout.m
//  YZWaterfallDemo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 TengNaDesign. All rights reserved.
//

#import "YZWaterFallLayout.h"

static const NSInteger YZDefaultColumnCount   = 3;//默认列数
static const CGFloat   YZDefaultColumnMargin  = 10;//默认列间距
static const CGFloat   YZDefaultRowMargin     = 10;//默认行间距
static const UIEdgeInsets YZDefaultEdgeInsets = {10,10,10,10};//默认上下左右边界

@interface YZWaterFallLayout ()

/** 存放所有cell的布局属性 **/
@property (nonatomic,strong) NSMutableArray *attrsArray;
/** 存放所有列的高度 **/
@property (nonatomic,strong) NSMutableArray *columnHeights;
/**  内容的高度 **/
@property (nonatomic,assign) CGFloat contentHeight;

//方法声明
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (CGFloat)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation YZWaterFallLayout

/** 存放所有cell的布局属性 **/
- (NSMutableArray *)attrsArray {
    
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    
    return _attrsArray;
}

/** 存放所有列的最低高度 **/
- (NSMutableArray *)columnHeights {
    
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    
    return _columnHeights;
}

#pragma -- YZWaterFallLayoutDelegate
- (CGFloat)columnMargin {
    
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFallLayout:)]) {
       
        return  [self.delegate columnMarginInWaterFallLayout:self];
    } else {
        
        return YZDefaultColumnMargin;
    }
}

- (CGFloat)rowMargin {
    
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFallLayout:)]) {
        
        return  [self.delegate rowMarginInWaterFallLayout:self];
    } else {
        
        return YZDefaultRowMargin;
    }
}

- (CGFloat)columnCount {
    
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFallLayout:)]) {
        
        return  [self.delegate columnCountInWaterFallLayout:self];
    } else {
        
        return YZDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets {
    
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterFallLayout:)]) {
        
        return  [self.delegate edgeInsetsInWaterFallLayout:self];
    } else {
        
        return YZDefaultEdgeInsets;
    }
}


//初始化
- (void)prepareLayout {
    
    [super prepareLayout];
    
    //初始化内容的高度为0
    self.contentHeight = 0;
    
    //清除之前保存的最低高度
    [self.columnHeights removeAllObjects];
    for (int i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //清除所有的布局属性
    [self.attrsArray removeAllObjects];
    
    //创建每一个cell对应布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //获取indexPath位置对应的属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }

}


//布局
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    return self.attrsArray;
}


// 返回indexPath位置对于的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    //cell的宽度
    CGFloat cellW = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    
    //cell的高度
    CGFloat cellH = [self.delegate waterFallLayout:self heightForItemAtIndexPath:indexPath.item itemWidth:cellW];
    
//    CGFloat cellH = 50 + arc4random_uniform(100);
    
    //求出高度最低所在的目标列
    NSInteger targetColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            targetColumn = i;
        }
    }
    
    //cell的X
    CGFloat cellX = self.edgeInsets.left + targetColumn * (cellW + self.columnMargin);
    //cell的Y
    CGFloat cellY = minColumnHeight;
    if (cellY != self.edgeInsets.top) {
        cellY += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
    
    // 数据加载后，每次都把列所在的最低高度返回给数组_columnHeights,即就是保存最新的最低高度
    self.columnHeights[targetColumn] = @(CGRectGetMaxY(attrs.frame));
    
    //计算内容的高度
    CGFloat columnHeight = [self.columnHeights[targetColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    
    return attrs;
    
}

//返回collectionView的contentSize
- (CGSize)collectionViewContentSize {
    //拿到所在列的最大高度
//    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
//    for (NSInteger i = 1; i < YZDefaultColumnCount; i++) {
//        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
//        if (maxColumnHeight < columnHeight) {
//            maxColumnHeight = columnHeight;
//        }
//    }

    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom + 64);
}



@end







































