//
//  IntroViewController.m
//  Restotube
//
//  Created by owel on 29/08/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroView1.h"
#import "IntroView2.h"
#import "IntroView3.h"
#import "IntroView.h"
//#import "intro3.h"
#import "MainViewController.h"
#import "AppDelegate.h"


@interface IntroViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) UIPageControl     *pageControl;

@end

@implementation IntroViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // scroll view
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    //    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, MAX(view1.frame.size.height, MAX(view2.frame.size.height, view3.frame.size.height)));
    
    // page control
    _pageControl = [UIPageControl new];
    _pageControl.numberOfPages = 3;
    [_pageControl sizeToFit];
    //    _pageControl.frame = CGRectMake(self.view.frame.size.width / 2 - _pageControl.frame.size.width, 0, _pageControl.frame.size.width, _pageControl.frame.size.height);
    _pageControl.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 20);
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.userInteractionEnabled = NO;
    
    // IntroView1
    IntroView1 *view1 = [[IntroView1 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIScrollView *scroll1 = [[UIScrollView alloc] initWithFrame:view1.bounds];
    scroll1.contentSize = view1.bounds.size;
    [scroll1 addSubview:view1];
    
    // IntroView2
    IntroView2 *view2 = [[IntroView2 alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // IntroView3
//    IntroView3 *view3 = [[IntroView3 alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    view3.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // IntroView3
    IntroView3 *view3 = [[IntroView3 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    view3.frame = CGRectMake(0, 0, self.view.frame.size.width, view3.button.frame.origin.y + view3.button.frame.size.height + _pageControl.frame.size.height);
    view3.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view3.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    IntroView *view3 = [[IntroView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [view3 layoutIfNeeded];
//    view3.frame = CGRectMake(0, 0, self.view.frame.size.width, view3.button.frame.origin.y + view3.button.frame.size.height + _pageControl.frame.size.height);
//    view3.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [view3.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView *scroll3 = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view3.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scroll3.contentSize = CGSizeMake(view3.frame.size.width, view3.frame.size.height);
    [scroll3 addSubview:view3];
    // view3.button.frame.origin.y + view3.button.frame.size.height + _pageControl.frame.size.height
    
    [_scrollView addSubview:view1];
    [_scrollView addSubview:view2];
    [_scrollView addSubview:scroll3];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
}

#pragma mark - Button

-(void) buttonPressed: (id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"mainController"];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = vc;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width;
}

@end
