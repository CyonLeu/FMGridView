//
//  FWGridViewCell.m
//  FMGridViewDemo
//
//  Created by CyonLeu on 14-8-7.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import "FWGridViewCell.h"

@implementation FWGridViewIndex

@synthesize rowIndex;
@synthesize columnIndex;

+ (id)gridViewIndexWithRow:(NSInteger)row column:(NSInteger)column
{
    return [[[self class] alloc] initWithRow:row column:column] ;
}

- (id)initWithRow:(NSInteger)row column:(NSInteger)column
{
    self = [super init];
    if (self)
    {
        self.rowIndex = row;
        self.columnIndex = column;
    }
    
    return self;
}

- (BOOL)isEqualIndex:(FWGridViewIndex *)otherObject
{
    if (otherObject == nil)
    {
        return NO;
    }
    
    if (self.rowIndex == otherObject.rowIndex && self.columnIndex == otherObject.columnIndex)
    {
        return YES;
    }
    
    return  NO;
}

@end



@implementation FWGridViewCell

@synthesize delegate;
@synthesize gridIndex;
@synthesize titleHeight;
@synthesize bSelected;

@synthesize touchBtn;
@synthesize thumbnail;
@synthesize label;

@synthesize backgroundView;
@synthesize selectedBackgroundView;

- (void)dealloc
{
    self.delegate = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCellStyle:(FWGridViewCellStyle)cellStyle
{
    self = [super init];
    if (self)
    {
        //Init code
        
        _gridViewCellStyle = cellStyle;
        bSelected = NO;
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds] ;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.userInteractionEnabled = NO;
        [self addSubview:self.backgroundView];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds] ;
        self.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectedBackgroundView.userInteractionEnabled = NO;
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        self.selectedBackgroundView.hidden = YES;
        [self addSubview:self.selectedBackgroundView];
        
        self.touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.touchBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.touchBtn addTarget:self action:@selector(onPressedTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.touchBtn.frame = self.bounds;
        [self addSubview:self.touchBtn];
        
        self.thumbnail = [[UIImageView alloc] init] ;
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbnail.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
        CGRect thumbFrame = self.bounds;
        
        if (_gridViewCellStyle == FWGridViewCellStyleTitle)
        {
            self.label = [[UILabel alloc] init] ;
            self.label.font = [UIFont systemFontOfSize:14];
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.backgroundColor = [UIColor clearColor];
            self.label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
            
            self.titleHeight = kCellTitleHeightDefault;
            [self addSubview:self.label];
        }
        self.thumbnail.frame = thumbFrame;
        [self addSubview:self.thumbnail];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.userInteractionEnabled = NO;
    [self addSubview:self.backgroundView];
    [self sendSubviewToBack:self.backgroundView];
    
    CGRect thumbFrame = self.bounds;
    if (_gridViewCellStyle == FWGridViewCellStyleTitle)
    {
        self.label.frame = CGRectMake(0, self.bounds.size.height - self.titleHeight, self.bounds.size.width, self.titleHeight);
        thumbFrame.size.height = self.bounds.size.height - self.titleHeight;
    }
    self.thumbnail.frame = thumbFrame;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

//在点击后传递出当前cell的row、column Index
- (void)onPressedTouchBtn:(id)sender
{
    self.bSelected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellSelected:)])
    {
        [self.delegate cellSelected:self];
    }
}

- (void)setBSelected:(BOOL)selected
{
    bSelected = selected;
    [self.thumbnail setHighlighted:selected];
    if (bSelected == YES)
    {
        self.backgroundView.hidden = YES;
        self.selectedBackgroundView.hidden = NO;
    }else
    {
        self.backgroundView.hidden = NO;
        self.selectedBackgroundView.hidden = YES;
        [self sendSubviewToBack:self.selectedBackgroundView];
    }
}


- (void)setSelectedBackgroundView:(UIView *)aselectedBackgroundView
{
    if (selectedBackgroundView != aselectedBackgroundView)
    {
        if (selectedBackgroundView && selectedBackgroundView.superview)
        {
            [selectedBackgroundView removeFromSuperview];
        }
        
        selectedBackgroundView = aselectedBackgroundView;
        
        if (selectedBackgroundView)
        {
            [self addSubview:selectedBackgroundView];
            [self sendSubviewToBack:selectedBackgroundView];
        }
    }
}

@end
