//
// HJAdvertisementScrollView
// Version 1.0.0
// Created by Jeffery He(hejicode@gmail.com) on 15/4/30.
//

#import "HJAdvertisementScrollView.h"
#import "UIImageView+WebCache.h"

#define kAdvertisementScrollViewPageControlHeight 20.0f
#define kAdvertisementScrollViewDefaultInfiniteTime 3.0f

@interface HJAdvertisementScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HJAdvertisementScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupScrollView];
    [self setupPageControl];
}

- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delaysContentTouches = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    NSUInteger count = self.scrollView.subviews.count;
    
    CGFloat imageViewY = 0;
    CGFloat imageViewWidth = self.bounds.size.width;
    CGFloat imageViewHeight = self.bounds.size.height;
    for (NSUInteger i = 0; i < count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat imageViewX = i * imageViewWidth;
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
        
        HJAdvertisementScrollModel *advertisementScrollModel = _datas[i];
        NSURL *url = [NSURL URLWithString:advertisementScrollModel.imageURLString];
        [imageView sd_setImageWithURL:url placeholderImage:nil];
    }
    self.scrollView.contentSize = CGSizeMake(count * imageViewWidth, imageViewHeight);
    
    self.pageControl.frame = CGRectMake(0,
                                        self.bounds.size.height - kAdvertisementScrollViewPageControlHeight,
                                        self.bounds.size.width,
                                        kAdvertisementScrollViewPageControlHeight);
    
    if (self.isCycle) {// if it is cycle,scroll to the second data
        CGPoint offsetPoint = CGPointMake(imageViewWidth, 0);
        [self.scrollView setContentOffset:offsetPoint animated:NO];
    }
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    
    NSUInteger count = _datas.count;
    
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = 0;
    
    if (count > 1 && self.isCycle) {
        NSMutableArray *infiniteArrays = [NSMutableArray array];
        [infiniteArrays addObject:[_datas lastObject]];
        [infiniteArrays addObjectsFromArray:_datas];
        [infiniteArrays addObject:[_datas firstObject]];
        _datas = [infiniteArrays copy];
        count = _datas.count;
    }
    
    for (NSUInteger i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tapRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tapRecoginzer];
        [self.scrollView addSubview:imageView];
    }
}

- (void)setPageControlCurrentTintColor:(UIColor *)pageControlCurrentTintColor {
    _pageControlCurrentTintColor = pageControlCurrentTintColor;
    if (_pageControlCurrentTintColor) {
        self.pageControl.currentPageIndicatorTintColor = _pageControlCurrentTintColor;
    }
}

- (void)setPageControlTintColor:(UIColor *)pageControlTintColor {
    _pageControlTintColor = pageControlTintColor;
    if (_pageControlTintColor) {
        self.pageControl.pageIndicatorTintColor = _pageControlTintColor;
    }
}

#pragma mark - NSTimer
- (void)addTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kAdvertisementScrollViewDefaultInfiniteTime target:self
                                                    selector:@selector(browserTimerSelector:)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)openTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)closeTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)setIsLaunchTimer:(BOOL)isLaunchTimer {
    _isLaunchTimer = isLaunchTimer;
    if (_isLaunchTimer) {
        [self addTimer];
    }
}

- (void)browserTimerSelector:(NSTimer *)timer {
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    NSUInteger pageNumber = 0;
    if (self.isCycle) {
        if (self.pageControl.currentPage == self.datas.count - 1) {
            pageNumber = 1;
        } else {
            pageNumber = self.pageControl.currentPage + 2;
        }
        CGFloat offsetX = pageNumber * scrollViewWidth;
        CGPoint offset = CGPointMake(offsetX, 0);
        [self.scrollView setContentOffset:offset animated:YES];
        
    } else {
        if (self.pageControl.currentPage == self.datas.count - 1) {
            pageNumber = 0;
            CGFloat offsetX = pageNumber * scrollViewWidth;
            CGPoint offset = CGPointMake(offsetX, 0);
            [self.scrollView setContentOffset:offset animated:NO];
        } else {
            pageNumber = self.pageControl.currentPage + 1;
            CGFloat offsetX = pageNumber * scrollViewWidth;
            CGPoint offset = CGPointMake(offsetX, 0);
            [self.scrollView setContentOffset:offset animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat scrollViewWidth = scrollView.bounds.size.width;
    if (self.isCycle) {
        self.pageControl.currentPage = (offset.x + 0.5 * scrollViewWidth) / scrollViewWidth - 1;
    } else {
        self.pageControl.currentPage = (offset.x + 0.5 * scrollViewWidth) / scrollViewWidth;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self cycleScrollWithScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self cycleScrollWithScrollView:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isLaunchTimer) {
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isLaunchTimer) {
        [self addTimer];
    }
}

/**
 *  封装循环滚动的方法
 *
 *  @param scrollView scrollView
 */
- (void)cycleScrollWithScrollView:(UIScrollView *)scrollView {
    if (self.isCycle) {
        CGPoint offset = scrollView.contentOffset;
        CGFloat scrollViewWidth = scrollView.bounds.size.width;
        NSInteger currentPage = (offset.x + 0.5 * scrollViewWidth) / scrollViewWidth;
        NSUInteger count = _datas.count;
        if (currentPage == 0) {
            CGPoint scrollPoint = CGPointMake(scrollViewWidth * (count - 2), 0.0f);
            [scrollView setContentOffset:scrollPoint animated:NO];
            self.pageControl.currentPage = (count - 2);
            
        } else if (currentPage == (count - 1)) {
            CGPoint scrollPoint = CGPointMake(scrollViewWidth, 0.0f);
            [scrollView setContentOffset:scrollPoint animated:NO];
            self.pageControl.currentPage = 0;
        }
    }
}

#pragma mark - UITapGestureRecognizer
- (void)tapImageView:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(advertisementScrollView:didClickWithAdvertisementScrollModel:)]) {
        HJAdvertisementScrollModel *advertisementScrollModel = _datas[tapGestureRecognizer.view.tag];
        [self.delegate advertisementScrollView:self didClickWithAdvertisementScrollModel:advertisementScrollModel];
    }
}

@end

@implementation HJAdvertisementScrollModel

- (instancetype)initWithImageURLString:(NSString *)imageURLString
                      webViewURLString:(NSString *)webViewString {
    if (self = [super init]) {
        self.imageURLString = imageURLString;
        self.webViewURLString = webViewString;
    }
    return self;
}

+ (instancetype)advertisementScrollModelWithImageURLString:(NSString *)imageURLString
                                          webViewURLString:(NSString *)webViewString {
    HJAdvertisementScrollModel *advertisement = [[self alloc] initWithImageURLString:imageURLString
                                                                     webViewURLString:webViewString];
    return advertisement;
}

@end
