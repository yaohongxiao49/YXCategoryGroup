//
//  YXPageControl.m
//  MuchProj
//
//  Created by Ausus on 2021/11/10.
//

#import "YXPageControlView.h"
#import "YXPageControlCell.h"

@interface YXPageControlView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation YXPageControlView

#pragma mark - 初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder*)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    
    [self initView];
    [self initData];
}

#pragma mark - 初始化数据
- (void)initData {
    
    self.backgroundColor = [UIColor clearColor];
    self.normalColor = kYXDiyColor(@"#E6E6E6", 1);
    self.selectedColor = kYXDiyColor(@"#C2C2C2", 1);
    
    self.pageCount = 0;
    self.currentPage = 0;
    self.hideForSinglePage = NO;
    self.isClickPage = NO;
    
    self.pagePosition = YXPageControlPositionCenter;
    self.pageSpace = 10;
    self.normalSize = CGSizeMake(7, 7);
    self.selectedSize = CGSizeMake(7, 7);
}

#pragma mark - 初始化视图
- (void)initView {
    
    //列表布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //列表视图
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
    
    //注册单元
    [_collectionView registerClass:[YXPageControlCell class] forCellWithReuseIdentifier:NSStringFromClass([YXPageControlCell class])];
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxW = _normalSize.width * (_pageCount - 1) + _selectedSize.width + _pageSpace * (_pageCount - 1);
    if (maxW > self.width) {
        maxW = self.width;
    }
    
    CGFloat maxH = _normalSize.height > _selectedSize.height ? _normalSize.height : _selectedSize.height;
    if (maxH > self.height) {
        maxH = self.height;
    }
    
    switch (_pagePosition) {
        case YXPageControlPositionLeft: {
            _collectionView.frame = CGRectMake(0, (self.height - maxH) / 2.f, maxW, maxH);
            break;
        }
        case YXPageControlPositionRight: {
            _collectionView.frame = CGRectMake(self.width - maxW, (self.height - maxH) / 2.f, maxW, maxH);
            break;
        }
        case YXPageControlPositionCenter: {
            _collectionView.frame = CGRectMake((self.width - maxW) / 2.f, (self.height - maxH) / 2.f, maxW, maxH);
            break;
        }
        default:
            break;
    }
}

#pragma mark - 设置未选中颜色
- (void)setNormalColor:(UIColor *)normalColor {
    
    _normalColor = normalColor;
    [_collectionView reloadData];
}

#pragma mark - 设置已选中颜色
- (void)setSelectedColor:(UIColor *)selectedColor {
    
    _selectedColor = selectedColor;
    [_collectionView reloadData];
}

#pragma mark - 设置未选中图片
- (void)setNormalImage:(UIImage *)normalImage {
    
    _normalImage = normalImage;
    [_collectionView reloadData];
}

#pragma mark - 设置已选中图片
- (void)setSelectedImage:(UIImage *)selectedImage {
    
    _selectedImage = selectedImage;
    [_collectionView reloadData];
}

#pragma mark - 设置页码总数
- (void)setPageCount:(NSInteger)pageCount {
    
    _pageCount = pageCount;
    [_collectionView reloadData];
    
    [self layoutSubviews];
    [self setCurrentPage:_currentPage];
    [self setHideForSinglePage:_hideForSinglePage];
}

#pragma mark - 设置当前页码
- (void)setCurrentPage:(NSInteger)currentPage {
    
    _currentPage = currentPage;
    [_collectionView reloadData];
    
    if (_currentPage < _pageCount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentPage inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - 设置是否单页隐藏
- (void)setHideForSinglePage:(BOOL)hideForSinglePage {
    
    _hideForSinglePage = hideForSinglePage;
    
    if (_hideForSinglePage && _pageCount <= 1) {
        self.hidden = YES;
    }
    else {
        self.hidden = NO;
    }
}

#pragma mark - 设置是否可以点击页码
- (void)setIsClickPage:(BOOL)isClickPage {
    
    _isClickPage = isClickPage;
}

#pragma mark - 设置页码位置
- (void)setPagePosition:(YXPageControlPosition)pagePosition {
    
    _pagePosition = pagePosition;
    [self layoutSubviews];
}

#pragma mark - 设置页码间距
- (void)setPageSpace:(CGFloat)pageSpace {
    
    _pageSpace = pageSpace;
    [_collectionView reloadData];
    [self layoutSubviews];
}

#pragma mark - 设置未选中页码大小
- (void)setNormalSize:(CGSize)normalSize {
    
    _normalSize = normalSize;
    [_collectionView reloadData];
    [self layoutSubviews];
}

#pragma mark - 设置已选中页码大小
- (void)setSelectedSize:(CGSize)selectedSize {
    
    _selectedSize = selectedSize;
    [_collectionView reloadData];
    [self layoutSubviews];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _pageCount;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return _pageSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return _pageSpace;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _currentPage) {
        return _selectedSize;
    }
    else {
        return _normalSize;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXPageControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXPageControlCell class]) forIndexPath:indexPath];
    if (indexPath.row == _currentPage) {
        if (_selectedImage) {
            cell.imageView.layer.masksToBounds = NO;
            cell.imageView.layer.cornerRadius = 0;
            cell.imageView.backgroundColor = [UIColor clearColor];
            cell.imageView.image = _selectedImage;
        }
        else {
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = _selectedSize.height / 2.f;
            cell.imageView.backgroundColor = _selectedColor;
            cell.imageView.image = nil;
        }
    }
    else {
        if (_normalImage) {
            cell.imageView.layer.masksToBounds = NO;
            cell.imageView.layer.cornerRadius = 0;
            cell.imageView.backgroundColor = [UIColor clearColor];
            cell.imageView.image = _normalImage;
        }
        else {
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = _normalSize.height / 2.f;
            cell.imageView.backgroundColor = _normalColor;
            cell.imageView.image = nil;
        }
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isClickPage) {
        [self setCurrentPage:indexPath.row];
        
        if (_clickPageBlock) {
            _clickPageBlock(_currentPage);
        }
    }
}

@end
