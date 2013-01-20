//
//  ACLoadingCell.h
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/18/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACLoadingCell;

@protocol ACLoadingCellDelegate <NSObject>
- (void)loadingCellDidRequestLoadMore:(ACLoadingCell *)cell;
@end

@interface ACLoadingCell : UITableViewCell

@property (nonatomic, weak) id<ACLoadingCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *reloadButton;

- (void)toggleActivityAnimated:(BOOL)animated;
- (void)setActivityIndicatorVisible:(BOOL)activity animated:(BOOL)animated;
@end
