//
//  BaseShowImagesViewController.m
//  Demo
//
//  Created by ZZ on 2019/9/9.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseShowImagesViewController.h"
#import <SDWebImage/SDWebImage.h>

#import "ShowImageModel.h"

@interface BaseShowImagesViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat h;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation BaseShowImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x/PhoneScreen_Width;
    ShowImageModel *model = _imgUrls[self.pageControl.currentPage];
    self.title = model.name;
}


- (CGFloat )h {
    if (PhoneScreen_Height == 812.0) {
        _h = 84 + 34;
    }
    else {
        _h = 64;
    }
    return _h;
}
- (void)setPage:(NSInteger)page {
    _page = page;
    self.scrollView.contentOffset = CGPointMake(PhoneScreen_Width * _page, 0);
}
- (void)setImgUrls:(NSArray *)imgUrls {
    _imgUrls = imgUrls;
    self.scrollView.contentSize = CGSizeMake(PhoneScreen_Width * _imgUrls.count, PhoneScreen_Height - self.h);
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = _imgUrls.count;
    for (int i = 0; i < _imgUrls.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(i * PhoneScreen_Width, 0, PhoneScreen_Width, PhoneScreen_Height - self.h);
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        ShowImageModel *model = _imgUrls[i];
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.url]];
        [self.scrollView addSubview:imgV];
    }
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, PhoneScreen_Width, PhoneScreen_Height - self.h);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView setPagingEnabled:YES];
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, PhoneScreen_Height - self.h - 20, PhoneScreen_Width, 20);
        [_pageControl setUserInteractionEnabled:NO];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = TITLE_COLOR;
    }
    return _pageControl;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
