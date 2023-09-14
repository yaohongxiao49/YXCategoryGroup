//
//  YXCardAnimationView.m
//  MuchProj
//
//  Created by Augus on 2023/3/17.
//

#import "YXCardAnimationView.h"
#import "YXCardShowImgV.h"

@interface YXCardAnimationView () <ZLSwipeableViewDelegate, ZLSwipeableViewDataSource, ZLSwipeableViewAnimator>

@property (nonatomic, strong) ZLSwipeableView *swipeableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSArray *valueArr;

@end

@implementation YXCardAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 看片放大偏移等动画
- (void)rotateAndTranslateView:(UIView *)view translation:(CGPoint)translation sizeScale:(CGFloat)sizeScale alphaScale:(CGFloat)alphaScale duration:(NSTimeInterval)duration swipeableView:(ZLSwipeableView *)swipeableView {
    
    view.height = 88 * kYXWidthProportion - sizeScale;
    view.center = [swipeableView convertPoint:swipeableView.center fromView:swipeableView.superview];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        view.alpha = 1 - alphaScale;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
//        transform = CGAffineTransformMakeScale(1, scaleValue);
        transform = CGAffineTransformTranslate(transform, translation.x, 0);
        view.transform = transform;
    } completion:nil];
}

#pragma mark - <ZLSwipeableViewDelegate>
- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
    
//    NSLog(@"did swipe in direction: %zd", direction);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    
//    NSLog(@"did cancel swipe");
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location {
    
//    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location translation:(CGPoint)translation {
    
//    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y, translation.x, translation.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location {
    
//    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - <ZLSwipeableViewDataSource>
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    
    if (_currentIndex >= _valueArr.count) {
        _currentIndex = 0;
    }

    kYXWeakSelf
    YXCardShowImgV *view = [[YXCardShowImgV alloc] initWithFrame:swipeableView.bounds];
    if (_valueArr.count != 0) {
        view.model = _valueArr[_currentIndex];
        view.tag = _currentIndex;
        [view yxTapUpWithBlock:^(UIView * _Nonnull view) {
           
            if (weakSelf.yxCardAnimationViewTapBlock) {
                YXShoppingMallAdvertingModel *infoModel = weakSelf.valueArr[view.tag];
                weakSelf.yxCardAnimationViewTapBlock(infoModel);
            }
        }];
    }
    
    _currentIndex++;
    
    return view;
}

#pragma mark - <ZLSwipeableViewAnimator>
- (void)animateView:(UIView *)view index:(NSUInteger)index views:(NSArray<UIView *> *)views swipeableView:(ZLSwipeableView *)swipeableView {
    
    NSTimeInterval duration = 0.4;
    CGPoint translation = CGPointMake(index * 6, 0);
    CGFloat sizeScale = index * 10;
    CGFloat alphaScale = index * 0.2;
    [self rotateAndTranslateView:view translation:translation sizeScale:sizeScale alphaScale:alphaScale duration:duration swipeableView:swipeableView];
}
    
#pragma mark - setting
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr {
    
    _dataSourceArr = dataSourceArr;
    
    _valueArr = [[NSArray alloc] initWithArray:(NSArray *)_dataSourceArr];
    [self.swipeableView loadViewsIfNeeded];
}

#pragma mark - 初始化视图
- (void)initView {
    
    _currentIndex = 0;
}

#pragma mark - 懒加载
- (ZLSwipeableView *)swipeableView {
    
    if (!_swipeableView) {
        _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectZero];
        _swipeableView.dataSource = self;
        _swipeableView.delegate = self;
        _swipeableView.viewAnimator = self;
        _swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
        _swipeableView.allowedDirection = ZLSwipeableViewDirectionAll;
        _swipeableView.numberOfActiveViews = 3;
        [self addSubview:_swipeableView];
        
        [_swipeableView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self);
        }];
        
        [_swipeableView setNeedsLayout];
        [_swipeableView layoutIfNeeded];
    }
    return _swipeableView;
}


@end
