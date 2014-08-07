//
//  FWGridViewCell.h
//  FMGridViewDemo
//
//  Created by CyonLeu on 14-8-7.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FWGridViewCellStyleDefault = 0,  //默认网格中就只有图片
    FWGridViewCellStyleTitle         //图片之外，还有图片说明标题
    
} FWGridViewCellStyle;

#define kCellTitleHeight 20

@interface FWGridViewIndex : NSObject
{
    
}
@property (nonatomic, assign) NSInteger     rowIndex;
@property (nonatomic, assign) NSInteger     columnIndex;

+ (id)gridViewIndexWithRow:(NSInteger)row column:(NSInteger)column;
- (id)initWithRow:(NSInteger)row column:(NSInteger)column;
- (BOOL)isEqualIndex:(FWGridViewIndex *)otherObject;


@end

@protocol FWGridViewCellDelegate;


/**
 *  gridCell
 */
@interface FWGridViewCell : UIView

{
    FWGridViewCellStyle _gridViewCellStyle;
}

@property (nonatomic, assign) id<FWGridViewCellDelegate> delegate;

@property (nonatomic, retain) FWGridViewIndex *gridIndex;
@property (nonatomic, assign) CGFloat        titleHeight;
@property (nonatomic, assign) BOOL		     bSelected;

@property (nonatomic, retain) UIButton      *touchBtn;
@property (nonatomic, retain) UIImageView   *thumbnail; //缩略图
@property (nonatomic, retain) UILabel       *label;     //说明标题

@property (nonatomic, retain) UIView        *backgroundView;//背景视图
@property (nonatomic, retain) UIView        *selectedBackgroundView;//选中时的背景

- (id)initWithCellStyle:(FWGridViewCellStyle)cellStyle;
- (void)onPressedTouchBtn:(id)sender;

@end

@protocol FWGridViewCellDelegate <NSObject>

@optional
- (void)cellSelected:(FWGridViewCell *)cell;


@end
