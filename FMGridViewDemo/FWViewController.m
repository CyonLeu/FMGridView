//
//  FWViewController.m
//  FMGridViewDemo
//
//  Created by CyonLeu on 14-8-7.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import "FWViewController.h"
#import "FWGridView.h"


@interface FWViewController ()<FWGridViewDelegate>

@property (nonatomic, weak) IBOutlet FWGridView *gridView;

@end

@implementation FWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.gridView.gridViewDelegate = self;
    self.gridView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    self.gridView.numOfColumns = 4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FWGridViewDelegate

- (CGFloat) gridView:(FWGridView *)grid widthForColumnAt:(NSInteger)columnIndex
{
//    if (columnIndex == 0) {
//        return 160;
//    }
//    
//    if (columnIndex % 2 == 0) {
//        return 60;
//    }
    return 70;
}
- (CGFloat) gridView:(FWGridView *)grid heightForRowAt:(NSInteger)rowIndex
{
    return 80;
}

- (NSInteger) numberOfCellsOfGridView:(FWGridView *) grid
{
    return 14;
}
- (FWGridViewCell *) gridView:(FWGridView *)grid cellForGridIndex:(FWGridViewIndex *)gridIndex
{
    FWGridViewCell *cell = [grid dequeueReusableCell];
    
    if (!cell) {
        cell = [[FWGridViewCell alloc] initWithCellStyle:FWGridViewCellStyleTitle];
    }
    
    cell.thumbnail.image = [UIImage imageNamed:@"wechat"];
//    cell.thumbnail.highlightedImage = [UIImage imageNamed:@"txweibo"];
    cell.label.text = @"微信朋友圈";
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    
    return cell;
}

/*
 *行间距，获取当前行与上一行的间距：竖向间距 default:0
 */
- (CGFloat) gridView:(FWGridView *)grid spaceForRowAt:(NSInteger)rowIndex
{
    return 10.f;
}
/*
 *列间距，每个网格cell之间的间距：横向间距 default:0
 */
- (CGFloat) gridView:(FWGridView *)grid spaceForCellGridIndex:(FWGridViewIndex *)gridIndex
{
    return 5;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.gridView reloadData];

}
@end
