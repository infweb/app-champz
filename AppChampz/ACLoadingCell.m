//
//  ACLoadingCell.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/18/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACLoadingCell.h"

@interface ACLoadingCell () {
    UIButton *_reloadButton;
}
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, getter = isActivityIndicatorVisible) BOOL activityIndicatorVisible;

- (void)loadMoreButtonPressed:(id)sender;
@end

@implementation ACLoadingCell

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reloadButton setTitle:NSLocalizedString(@"Load More", nil) forState:UIControlStateNormal];
        [_reloadButton setTitle:NSLocalizedString(@"Load More", nil) forState:UIControlStateHighlighted];
        [_reloadButton addTarget:self action:@selector(loadMoreButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadMoreButtonPressed:(id)sender
{
    [self.delegate loadingCellDidRequestLoadMore:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.reloadButton removeFromSuperview];
    [self.activityIndicator removeFromSuperview];
    
    CGRect frame = self.reloadButton.frame;
    frame.size = CGSizeMake(self.bounds.size.width - 10, self.bounds.size.height - 10);
    frame.origin = CGPointMake((self.bounds.size.width - frame.size.width) / 2,
                               (self.bounds.size.height - frame.size.height) / 2);
    self.reloadButton.frame = frame;
    
    frame = self.activityIndicator.frame;
    frame.origin = CGPointMake((self.bounds.size.width - frame.size.width) / 2,
                               (self.bounds.size.height - frame.size.height) / 2);
    self.activityIndicator.frame = frame;
    
    [self addSubview:self.reloadButton];
    [self addSubview:self.activityIndicator];
    
}

- (void)setActivityIndicatorVisible:(BOOL)activity animated:(BOOL)animated
{
    if (activity == self.isActivityIndicatorVisible) return;
    
    self.activityIndicatorVisible = activity;
    
    void (^animations)(void) = ^{
        self.reloadButton.hidden = self.activityIndicatorVisible;
        if (self.activityIndicatorVisible) {
            [self.activityIndicator startAnimating];
        } else {
            [self.activityIndicator stopAnimating];
        }
    };
    if (animated) {
        [UIView animateWithDuration:0.1 animations:animations];
    } else {
        animations();
    }
}

- (void)toggleActivityAnimated:(BOOL)animated
{
    [self setActivityIndicatorVisible:!self.isActivityIndicatorVisible animated:animated];
}

- (void)dealloc
{
    self.delegate = nil;
}
@end
