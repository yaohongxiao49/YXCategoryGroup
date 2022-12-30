//
//  YXPageControl.m
//  MuchProj
//
//  Created by Ausus on 2021/11/10.
//

#import "YXPageControlView.h"
#import "YXPageControlCell.h"
#import "YXPageControlFlowLayout.h"

@interface YXPageControlView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) YXPageControlFlowLayout *layout;

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

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.pageCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXPageControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXPageControlCell class]) forIndexPath:indexPath];
    if (indexPath.row == self.currentPage) {
        if (self.selectedImage) {
            cell.imageView.layer.masksToBounds = NO;
            cell.imageView.layer.cornerRadius = 0;
            cell.imageView.backgroundColor = [UIColor clearColor];
            cell.imageView.image = self.selectedImage;
        }
        else {
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = self.selectedSize.height / 2.f;
            cell.imageView.backgroundColor = self.selectedColor;
            cell.imageView.image = nil;
        }
    }
    else {
        if (self.normalImage) {
            cell.imageView.layer.masksToBounds = NO;
            cell.imageView.layer.cornerRadius = 0;
            cell.imageView.backgroundColor = [UIColor clearColor];
            cell.imageView.image = self.normalImage;
        }
        else {
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = self.normalSize.height / 2.f;
            cell.imageView.backgroundColor = self.normalColor;
            cell.imageView.image = nil;
        }
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isClickPage) {
        [self setCurrentPage:indexPath.row];
        
        if (self.clickPageBlock) {
            self.clickPageBlock(self.currentPage);
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == self.currentPage ? self.selectedSize : self.normalSize;
}

#pragma mark - setting
#pragma mark - 设置未选中颜色
- (void)setNormalColor:(UIColor *)normalColor {
    
    _normalColor = normalColor;
    
    [self.collectionView reloadData];
}
#pragma mark - 设置已选中颜色
- (void)setSelectedColor:(UIColor *)selectedColor {
    
    _selectedColor = selectedColor;
    
    [self.collectionView reloadData];
}
#pragma mark - 设置未选中图片
- (void)setNormalImage:(UIImage *)normalImage {
    
    _normalImage = normalImage;
    
    [self.collectionView reloadData];
}
#pragma mark - 设置已选中图片
- (void)setSelectedImage:(UIImage *)selectedImage {
    
    _selectedImage = selectedImage;
    
    [self.collectionView reloadData];
}
#pragma mark - 设置页码总数
- (void)setPageCount:(NSInteger)pageCount {
    
    _pageCount = pageCount;
    
    [self.collectionView reloadData];
    [self layoutSubviews];
    [self setCurrentPage:self.currentPage];
    [self setHideForSinglePage:self.hideForSinglePage];
}
#pragma mark - 设置当前页码
- (void)setCurrentPage:(NSInteger)currentPage {
    
    _currentPage = currentPage;
    [self.collectionView reloadData];
    
    if (_currentPage < _pageCount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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
    
    self.layout.minimumLineSpacing = _pageSpace;
    self.layout.minimumInteritemSpacing = _pageSpace;
    [self.collectionView reloadData];
    [self layoutSubviews];
}
#pragma mark - 设置未选中页码大小
- (void)setNormalSize:(CGSize)normalSize {
    
    _normalSize = normalSize;
    
    [self.collectionView reloadData];
    [self layoutSubviews];
}
#pragma mark - 设置已选中页码大小
- (void)setSelectedSize:(CGSize)selectedSize {
    
    _selectedSize = selectedSize;
    
    [self.collectionView reloadData];
    [self layoutSubviews];
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
    
    [self.collectionView reloadData];
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxW = self.normalSize.width * (self.pageCount - 1) + self.selectedSize.width + self.pageSpace * (self.pageCount - 1);
    if (maxW > self.width) {
        maxW = self.width;
    }
    
    CGFloat maxH = self.normalSize.height > self.selectedSize.height ? self.normalSize.height : self.selectedSize.height;
    if (maxH > self.height) {
        maxH = self.height;
    }
    
    switch (self.pagePosition) {
        case YXPageControlPositionLeft: {
            self.collectionView.frame = CGRectMake(0, (self.height - maxH) / 2.f, maxW, maxH);
            break;
        }
        case YXPageControlPositionRight: {
            self.collectionView.frame = CGRectMake(self.width - maxW, (self.height - maxH) / 2.f, maxW, maxH);
            break;
        }
        case YXPageControlPositionCenter: {
            self.collectionView.frame = CGRectMake((self.width - maxW) / 2.f, (self.height - maxH) / 2.f, maxW, maxH);
            break;
        }
        default:
            break;
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        //列表布局
        self.layout = [[YXPageControlFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //列表视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
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
    return _collectionView;
}

@end
