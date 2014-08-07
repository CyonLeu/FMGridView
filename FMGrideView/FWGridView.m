//
//  FWGridView.m
//  FMGridViewDemo
//
//  Created by CyonLeu on 14-8-7.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import "FWGridView.h"
#import "FWGridViewRow.h"

@interface FWGridView ()

@end

@implementation FWGridView

@synthesize gridViewDelegate;
@synthesize name;
@synthesize selectedIndex;

- (void)dealloc
{
	self.delegate = nil;
	self.dataSource = nil;
    
	self.gridViewDelegate = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initTableViewPropety];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initTableViewPropety];
    }
    return self;
}

- (void)initTableViewPropety
{
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (FWGridViewCell *) dequeueReusableCell
{
	FWGridViewCell* result = _reusableCell;
	_reusableCell = nil;
	return result;
}

- (FWGridViewCell *) getGridViewCellWithGridIndex:(FWGridViewIndex *)gridIndex
{
    FWGridViewCell *cell = nil;
    NSInteger rows = [self numberOfRowsInSection:0];
    if (gridIndex.rowIndex < rows)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gridIndex.rowIndex inSection:0];
        FWGridViewRow *gridViewRow = (FWGridViewRow *)[self cellForRowAtIndexPath:indexPath];
        if (gridViewRow != nil && [gridViewRow.contentView.subviews count] > gridIndex.columnIndex)
        {
            cell = [gridViewRow.contentView.subviews objectAtIndex:gridIndex.columnIndex];
        }
    }
    
    return cell;
}

- (void)selectGridViewCellAtGridIndex:(FWGridViewIndex *)gridIndex
{
    self.selectedIndex = [FWGridViewIndex gridViewIndexWithRow:gridIndex.rowIndex column:gridIndex.columnIndex];
    FWGridViewCell *cell = [self getGridViewCellWithGridIndex:gridIndex];
    if (cell)
    {
        cell.bSelected = YES;
    }
}

- (void)deselectGridViewCellAtGridIndex:(FWGridViewIndex *)gridIndex
{
    FWGridViewCell *cell = [self getGridViewCellWithGridIndex:gridIndex];
    if (cell)
    {
        cell.bSelected = NO;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.gridViewDelegate == nil)
    {
        return 0;
    }
    
	int residue =  ([self.gridViewDelegate numberOfCellsOfGridView:self] % [self.gridViewDelegate numberOfColumnsOfGridView:self]);
	
	if (residue > 0)
    {
        residue = 1;
    }
	
	return ([gridViewDelegate numberOfCellsOfGridView:self] / [gridViewDelegate numberOfColumnsOfGridView:self]) + residue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.gridViewDelegate == nil)
    {
        return 80;
    }
    
    CGFloat rowSpace = 0.0f;//若不在外设置列边距，则默认为0
    if (self.gridViewDelegate && [self.gridViewDelegate respondsToSelector:@selector(gridView:spaceForRowAt:)])
    {
        rowSpace = [self.gridViewDelegate gridView:self spaceForRowAt:indexPath.row];
    }
    
    return [self.gridViewDelegate gridView:self heightForRowAt:indexPath.row] + rowSpace;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FWGridViewRow";
	
    FWGridViewRow *gridViewRow = (FWGridViewRow *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (gridViewRow == nil)
    {
        gridViewRow = [[FWGridViewRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
	
	NSInteger numColumns = [self.gridViewDelegate numberOfColumnsOfGridView:self];
	NSInteger countCells = [self.gridViewDelegate numberOfCellsOfGridView:self];
	
	CGFloat x = 0;
	CGFloat height = [self.gridViewDelegate gridView:self heightForRowAt:indexPath.row];
	
	for (NSInteger i=0; i < numColumns; i++)
    {
        //若当前行所需要显示的cell列少于numColums时，需要隐藏该cell
		if ((i + indexPath.row * numColumns) >= countCells)
        {
			if ([gridViewRow.contentView.subviews count] > i)
            {
				FWGridViewCell *needHideCell = ((FWGridViewCell *)[gridViewRow.contentView.subviews objectAtIndex:i]);
                needHideCell.hidden = YES;
			}
			continue;
		}
		
        //若改行是重用的，则其中的cell也可重用
		if ([gridViewRow.contentView.subviews count] > i)
        {
			_reusableCell = [gridViewRow.contentView.subviews objectAtIndex:i];
		}
        else
        {
			_reusableCell = nil;
		}
		
        FWGridViewIndex *index = [FWGridViewIndex gridViewIndexWithRow:indexPath.row column:i];
		FWGridViewCell *cell = [self.gridViewDelegate gridView:self cellForGridIndex:index];
		
		if (cell.superview != gridViewRow.contentView)
        {
			[cell removeFromSuperview];
			[gridViewRow.contentView addSubview:cell];
		}
		
		cell.hidden = NO;
		cell.gridIndex = index;
		cell.delegate = self;
        if ([index isEqualIndex:self.selectedIndex])
        {
            cell.bSelected = YES;
        }
        else
        {
            cell.bSelected = NO;
        }
        
        if (self.gridViewDelegate && [self.gridViewDelegate respondsToSelector:@selector(gridView:titleHeightForCellGridIndex:)])
        {
            cell.titleHeight = [self.gridViewDelegate gridView:self titleHeightForCellGridIndex:index];
        }
        
		CGFloat thisWidth = [gridViewDelegate gridView:self widthForColumnAt:i];
        CGFloat rowSpace = 0.0f;//若不在外设置行边距，则默认为0
        if (self.gridViewDelegate && [self.gridViewDelegate respondsToSelector:@selector(gridView:spaceForRowAt:)])
        {
            rowSpace = [self.gridViewDelegate gridView:self spaceForRowAt:indexPath.row];
        }
        
		cell.frame = CGRectMake(x, rowSpace, thisWidth, height);
        
        CGFloat cellSpace = 0.0f;//若不在外设置列边距，则默认为0
        if (self.gridViewDelegate && [self.gridViewDelegate respondsToSelector:@selector(gridView:spaceForCellGridIndex:)])
        {
            cellSpace = [self.gridViewDelegate gridView:self spaceForCellGridIndex:index];
        }
        
		x += thisWidth + cellSpace;
	}
    
    //	gridViewRow.frame = CGRectMake(gridViewRow.frame.origin.x, gridViewRow.frame.origin.y, x, height + rowSpace);
	
    return gridViewRow;
}


#pragma mark - FWGridViewCellDelegate

- (void)cellSelected:(FWGridViewCell *)cell
{
    if (cell.gridIndex.rowIndex != self.selectedIndex.rowIndex || cell.gridIndex.columnIndex != self.selectedIndex.columnIndex)
    {
        FWGridViewCell *selectedCell = [self getGridViewCellWithGridIndex:self.selectedIndex];
        if (selectedCell)
        {
            selectedCell.bSelected = NO;
        }
        self.selectedIndex = [FWGridViewIndex gridViewIndexWithRow:cell.gridIndex.rowIndex column:cell.gridIndex.columnIndex];
    }
    
    if (self.gridViewDelegate && [self.gridViewDelegate respondsToSelector:@selector(gridView:didSelectCell:)])
    {
        [self.gridViewDelegate gridView:self didSelectCell:cell];
    }
}

@end
