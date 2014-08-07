//
//  FWGridView.h
//  FMGridViewDemo
//
//  Created by CyonLeu on 14-8-7.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWGridViewCell.h"

@protocol FWGridViewDelegate;

@interface FWGridView : UITableView <UITableViewDelegate, UITableViewDataSource, FWGridViewCellDelegate>
{
    FWGridViewCell *_reusableCell;
}

@property (nonatomic, assign) id<FWGridViewDelegate> gridViewDelegate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) FWGridViewIndex *selectedIndex;
@property (nonatomic) NSUInteger numOfColumns;//default is 4


/**
 *  /外部可用方法
 *
 **/

//获取可重用的cell
- (FWGridViewCell *) dequeueReusableCell;

//根据行列索引获取Cell

- (FWGridViewCell *) getGridViewCellWithGridIndex:(FWGridViewIndex *)gridIndex;
- (void)selectGridViewCellAtGridIndex:(FWGridViewIndex *)gridIndex;//选中cell
- (void)deselectGridViewCellAtGridIndex:(FWGridViewIndex *)gridIndex;//取消选中状态

@end


@protocol FWGridViewDelegate  <NSObject>

@required
- (NSInteger) numberOfCellsOfGridView:(FWGridView *) grid;

- (FWGridViewCell *) gridView:(FWGridView *)grid cellForGridIndex:(FWGridViewIndex *)gridIndex;

@optional
/*
 *default: 80
 */
- (CGFloat) gridView:(FWGridView *)grid widthForColumnAt:(NSInteger)columnIndex;

/*
 *default: 80
 */
- (CGFloat) gridView:(FWGridView *)grid heightForRowAt:(NSInteger)rowIndex;

- (void) gridView:(FWGridView *)grid didSelectCell:(FWGridViewCell *)cell;

/*
 *default: 4
 */

- (NSInteger) numberOfColumnsOfGridView:(FWGridView *) grid;
/*
 *行间距，获取当前行与上一行的间距：竖向间距 default:0
 */
- (CGFloat) gridView:(FWGridView *)grid spaceForRowAt:(NSInteger)rowIndex;
/*
 *列间距，每个网格cell之间的间距：横向间距 default:0
 */
- (CGFloat) gridView:(FWGridView *)grid spaceForCellGridIndex:(FWGridViewIndex *)gridIndex;

//每个cell的标题高度，若cellStyle为FWGridViewCellStyleTitle时，需要设置该值，default:20
- (CGFloat) gridView:(FWGridView *)grid titleHeightForCellGridIndex:(FWGridViewIndex *)gridIndex;


@end
