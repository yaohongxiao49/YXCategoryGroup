//
//  YXPageControlFlowLayout.m
//  MuchProj
//
//  Created by Augus on 2022/12/30.
//

#import "YXPageControlFlowLayout.h"

@implementation YXPageControlFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    CGFloat cellLeft = CGRectGetMinX(self.collectionView.bounds) ? CGRectGetMinX(self.collectionView.bounds) : self.sectionInset.left;
    CGFloat cellY = 0;
    CGFloat cellX = cellLeft;
    for (UICollectionViewLayoutAttributes *attrs in attributes) {
        if (attrs.indexPath.row == 0) { //item是一行一行的显示，第一个元素肯定是一行的第一个元素
            cellY = attrs.frame.origin.y;
            cellX = cellLeft;
        }
        else {
            if (cellY != attrs.frame.origin.y) { //换行
                cellX = cellLeft; //新的行第一个的X值
                cellY = attrs.frame.origin.y; //保存新行的Y值
            }
        }
        CGRect frame = attrs.frame;
        frame.origin = CGPointMake(cellX, cellY);
        if (attrs.frame.size.width > (kYXWidth - cellX - self.minimumInteritemSpacing - self.sectionInset.left - self.sectionInset.right)) {
            frame.size = CGSizeMake(kYXWidth - cellX - self.minimumInteritemSpacing - self.sectionInset.left - self.sectionInset.right, frame.size.height);
        }
        attrs.frame = frame;
        cellX = CGRectGetMaxX(frame) + self.minimumInteritemSpacing;
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end
