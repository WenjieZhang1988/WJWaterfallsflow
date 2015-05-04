//
//  WJWaterflowLayout.m
//  WJWaterfallsflow
//
//  Created by Kevin on 13/1/14.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "WJWaterflowLayout.h"

#define WJCollectionW self.collectionView.frame.size.width

/** 每一行之间的间距 */
static const CGFloat WJDefaultRowMargin = 10;
/** 每一列之间的间距 */
static const CGFloat WJDefaultColumnMargin = 10;
/** 每一列之间的间距 top, left, bottom, right */
static const UIEdgeInsets WJDefaultInsets = {10, 10, 10, 10};
/** 默认的列数 */
static const int WJDefaultColumsCount = 3;

@interface WJWaterflowLayout()

/** 每一列的最大Y值 */
@property (nonatomic, strong) NSMutableArray *columnMaxYs;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

/** 这行代码的目的：能够使用点语法 */
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSUInteger)columnsCount;
- (UIEdgeInsets)insets;

@end

@implementation WJWaterflowLayout

#pragma mark - 懒加载
- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableArray alloc] init];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

#pragma mark - 实现内部的方法
/**
 * 决定了collectionView的contentSize
 */
- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最大值
        if (destMaxY < columnMaxY) {
            destMaxY = columnMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + self.insets.bottom);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    for (NSUInteger i = 0; i<self.columnsCount; i++) {
        [self.columnMaxYs addObject:@(self.insets.top)];
    }
    
    // 计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    // 水平方向上的总间距
    CGFloat xMargin = self.insets.left + self.insets.right + (self.columnsCount - 1) * self.columnMargin;
    // cell的宽度
    CGFloat w = (WJCollectionW - xMargin) / self.columnsCount;
    // cell的高度
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndexPath:indexPath withItemWidth:w];
    
    // 找出最短那一列的 列号 和 最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    NSUInteger destColumn = 0;
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最小值
        if (destMaxY > columnMaxY) {
            destMaxY = columnMaxY;
            destColumn = i;
        }
    }
    
    // cell的x值
    CGFloat x = self.insets.left + destColumn * (w + self.columnMargin);
    // cell的y值
    CGFloat y = destMaxY;
    if (destMaxY != self.insets.top) { // 不是第一排
        y += self.rowMargin;
    }
    // cell的frame
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新数组中的最大Y值
    self.columnMaxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    return attrs;
}

// 细粒度

#pragma mark - 处理代理数据
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }
    return WJDefaultRowMargin;
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }
    return WJDefaultColumnMargin;
}

- (NSUInteger)columnsCount
{
    if ([self.delegate respondsToSelector:@selector(columnsCountInWaterflowLayout:)]) {
        return [self.delegate columnsCountInWaterflowLayout:self];
    }
    return WJDefaultColumsCount;
}

- (UIEdgeInsets)insets
{
    if ([self.delegate respondsToSelector:@selector(insetsInWaterflowLayout:)]) {
        return [self.delegate insetsInWaterflowLayout:self];
    }
    return WJDefaultInsets;
}

@end
