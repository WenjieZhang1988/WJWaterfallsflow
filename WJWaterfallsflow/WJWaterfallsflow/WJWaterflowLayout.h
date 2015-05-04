//
//  WJWaterflowLayout.h
//  WJWaterfallsflow
//
//  Created by Kevin on 13/1/14.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJWaterflowLayout;

@protocol WJWaterflowLayoutDelegate <NSObject>

@required
/**
 * 返回indexPath位置cell的高度
 */
- (CGFloat)waterflowLayout:(WJWaterflowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)width;

@optional
- (CGFloat)rowMarginInWaterflowLayout:(WJWaterflowLayout *)layout;
- (CGFloat)columnMarginInWaterflowLayout:(WJWaterflowLayout *)layout;
- (NSUInteger)columnsCountInWaterflowLayout:(WJWaterflowLayout *)layout;
- (UIEdgeInsets)insetsInWaterflowLayout:(WJWaterflowLayout *)layout;

@end

@interface WJWaterflowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WJWaterflowLayoutDelegate> delegate;

@end
