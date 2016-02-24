//
//  DPGameLiveFilterView.m
//  Jackpot
//
//  Created by wufan on 15/8/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveFilterView.h"
#import <OAStackView.h>

static const CGFloat kCollectionCellHeight = 29.0f;     // cell 高度
static const CGFloat kCollectionHeaderHeight = 90.0f;   // 头部高度
static const CGFloat kVSpace = 3.5f;    // cell 之间纵向间距
static const CGFloat kHSpace = 2.5f;    // cell 之间横向间距
static const CGFloat kMargin = 8.0f;    // content 距离左右两边的间距

static NSString *kCellIdentifier = @"cell";
static NSString *kHeaderIdentifier = @"header";

@implementation DPGameLiveFilterItem

- (instancetype)copyWithZone:(NSZone *)zone {
    DPGameLiveFilterItem *item = [[DPGameLiveFilterItem alloc] init];
    item.name = self.name;
    item.selected = self.selected;
    return item;
}

@end

@interface DPGameLiveFilterGroup ()
@end

@implementation DPGameLiveFilterGroup

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    DPGameLiveFilterGroup *group = [[DPGameLiveFilterGroup allocWithZone:zone] init];
    group.title = self.title;
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.items.count];
    for (DPGameLiveFilterItem *item in self.items) {
        [items addObject:item.copy];
    }
    group.items = items;
    return group;
}

@end

@interface DPGameLiveFilterViewLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSArray *cellCounts;
@property (nonatomic, strong) NSArray *lineOffset;
@property (nonatomic, assign) CGSize collectionViewContentSize;
@end

@implementation DPGameLiveFilterViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger offset = 0;
    NSMutableArray *cellCounts = [NSMutableArray array];
    NSMutableArray *lineOffset = [NSMutableArray array];
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        NSInteger cellCount = [self.collectionView numberOfItemsInSection:i];
        NSInteger lineCount = cellCount > 0 ? (cellCount - 1) / 3 + 1 : 0;
        [cellCounts addObject:@(cellCount)];
        [lineOffset addObject:@(offset)];
        
        offset += lineCount;
    }
    
    CGFloat height = 0;
    for (NSNumber *count in cellCounts) {
        NSInteger lineCount = count.integerValue > 0 ? (count.integerValue - 1) / 3 + 1 : 0;
        height += kCollectionHeaderHeight + kVSpace;
        height += lineCount * (kCollectionCellHeight + kVSpace);
    }
    
    self.cellCounts = cellCounts;
    self.lineOffset = lineOffset;
    self.itemWidth = floorf((CGRectGetWidth(self.collectionView.bounds) - 2 * kMargin - 2 * kHSpace) / 3);
    self.collectionViewContentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger x = indexPath.row % 3, y = indexPath.row / 3;
    NSInteger offset = [self.lineOffset[indexPath.section] integerValue];
    CGFloat offsetX[] = { kMargin, kMargin + self.itemWidth + kHSpace, kMargin + (self.itemWidth + kHSpace) * 2 };
    CGFloat offsetY = offset * (kVSpace + kCollectionCellHeight) + (indexPath.section + 1) * (kCollectionHeaderHeight + kVSpace);
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.indexPath = indexPath;
    attr.frame = CGRectMake(offsetX[x], offsetY + y * (kCollectionCellHeight + kVSpace), self.itemWidth, kCollectionCellHeight);
    return attr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger offset = [self.lineOffset[indexPath.section] integerValue];
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    attr.frame = CGRectMake(0, offset * (kVSpace + kCollectionCellHeight) + indexPath.section * kCollectionHeaderHeight, CGRectGetWidth(self.collectionView.bounds), kCollectionHeaderHeight);
    attr.zIndex = 1024;
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *headerArray = [NSMutableArray array];
    for (int i = 0; i < self.cellCounts.count; i++) {
        UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [headerArray addObject:headerAttr];
        [allArray addObject:headerAttr];
        NSInteger cellCount = [self.cellCounts[i] integerValue];
        for (int j = 0; j < cellCount; j++) {
            [allArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]]];
        }
    }
    
    // 重新定位 section header, 使 section header 始终上浮在顶部, 类似 table view
    for (UICollectionViewLayoutAttributes *headerAttr in headerArray.reverseObjectEnumerator) {
        CGRect frame = headerAttr.frame;
        // 找到最后一个起始值小余内容的header
        if (CGRectGetMinY(frame) < self.collectionView.contentOffset.y) {
            NSInteger section = headerAttr.indexPath.section;
            // 如果 section 下有单元格, 则进行调整 frame
            if ([self.cellCounts[section] integerValue] > 0) {
                NSInteger cellCount = 0;
                for (int i = 0; i <= section; i++) {
                    cellCount += [self.cellCounts[i] integerValue];
                }
                // 该 section 下的最后一个 cell
                UICollectionViewLayoutAttributes *lastCellAttrInSection = [allArray objectAtIndex:section + cellCount - 1];
                frame.origin.y = MIN(self.collectionView.contentOffset.y, CGRectGetMaxY(lastCellAttrInSection.frame) - CGRectGetHeight(frame));
                headerAttr.frame = frame;
            }
        }
    }
    return allArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end

@class DPGameLiveFilterHeaderView;
@protocol DPGameLiveFilterHeaderDelegate <NSObject>

- (void)cleanupForHeaderView:(DPGameLiveFilterHeaderView *)headerView;
- (void)checkAllForHeaderView:(DPGameLiveFilterHeaderView *)headerView;

@end

@interface DPGameLiveFilterHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id<DPGameLiveFilterHeaderDelegate> delegate;
@end

@implementation DPGameLiveFilterHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithRed:0.51 green:0.42 blue:0.35 alpha:1];
    _titleLabel.font = [UIFont dp_systemFontOfSize:12];
    
    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.96 alpha:1];
}

- (void)setupConstraints {
    UIView *lineView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xeae2da);
        view;
    });
    UIButton *allButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor dp_flatRedColor];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(checkAllForHeaderView:)]) {
                [self.delegate checkAllForHeaderView:self];
            }
        }];
        button;
    });
    UIButton *clearButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.96 alpha:1];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        
        [button setTitle:@"反选" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.5 green:0.44 blue:0.35 alpha:1] forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cleanupForHeaderView:)]) {
                [self.delegate cleanupForHeaderView:self];
            }
        }];
        button;
    });
    OAStackView *stackView = ({
        OAStackView *view = [[OAStackView alloc] initWithArrangedSubviews:@[allButton, clearButton]];
        view.alignment = OAStackViewAlignmentFill;
        view.distribution = OAStackViewDistributionFillEqually;
        view.axis = UILayoutConstraintAxisHorizontal;
        view.layer.borderColor = UIColorFromRGB(0xe0d8c8).CGColor;
        view.layer.borderWidth = 0.5;
        view;
    });
    
    [self addSubview:self.titleLabel];
    [self addSubview:lineView];
    [self addSubview:stackView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kMargin);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@30);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self).offset(kMargin);
        make.right.equalTo(self).offset(-kMargin);
        make.height.equalTo(@30);
    }];
}

@end

@interface DPGameLiveFilterCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *titleButton;
@end

@implementation DPGameLiveFilterCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _titleButton = [[UIButton alloc] init];
    _titleButton.layer.borderWidth = 0.5;
    _titleButton.layer.borderColor = UIColorFromRGB(0xe0d8c8).CGColor;
    _titleButton.userInteractionEnabled = NO;
    _titleButton.titleLabel.font = [UIFont dp_systemFontOfSize:12];
    _titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleButton setTitleColor:[UIColor colorWithRed:0.5 green:0.44 blue:0.35 alpha:1] forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
    [_titleButton setImage:nil forState:UIControlStateNormal];
    [_titleButton setImage:dp_CommonImage(@"red_check.png") forState:UIControlStateSelected];
    [_titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setupConstraints {
    [self.contentView addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end

typedef NS_ENUM(NSInteger, DPGameLiveHeaderSelectedType) {
    DPGameLiveHeaderSelectedTypeCheckAll = 1,
    DPGameLiveHeaderSelectedTypeCleanup = 2,
    DPGameLiveHeaderSelectedTypeInvert = 3,
};

@interface DPGameLiveFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, DPGameLiveFilterHeaderDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSObject *drawDelegate;
@property (nonatomic, strong) UILabel *visibleCountLabel;
@end

@implementation DPGameLiveFilterView

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, 300, 300) collectionViewLayout:[[DPGameLiveFilterViewLayout alloc] init]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.96 alpha:1];
    
    [_collectionView registerClass:[DPGameLiveFilterCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [_collectionView registerClass:[DPGameLiveFilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    
    _visibleCountLabel = [[UILabel alloc] init];
    _visibleCountLabel.textColor = [UIColor colorWithRed:0.49 green:0.43 blue:0.35 alpha:1];
    _visibleCountLabel.font = [UIFont dp_systemFontOfSize:13];
    _visibleCountLabel.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.96 alpha:1];
}

- (void)setupConstraints {
    UIView *lineView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.79 alpha:1];
        view;
    });
    UIButton *cancelButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:17];
        button.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.96 alpha:1];
        [button setTitleColor:[UIColor colorWithRed:0.44 green:0.43 blue:0.42 alpha:1] forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cancelFilterView:)]) {
                [self.delegate cancelFilterView:self];
            }
        }];
        button;
    });
    UIButton *confirmButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:17];
        button.backgroundColor = [UIColor dp_flatRedColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(confirmFilterView:)]) {
                [self.delegate confirmFilterView:self];
            }
        }];
        button;
    });
    OAStackView *stackView = ({
        OAStackView *view = [[OAStackView alloc] initWithArrangedSubviews:@[cancelButton, confirmButton]];
        view.axis = UILayoutConstraintAxisHorizontal;
        view.distribution = OAStackViewDistributionFillEqually;
        view.alignment = OAStackViewAlignmentFill;
        view;
    });
    
    [self addSubview:self.collectionView];
    [self addSubview:stackView];
    [self addSubview:lineView];
    [self addSubview:self.visibleCountLabel];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
    }];
    [self.visibleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.equalTo(@30);
        make.left.equalTo(self).offset(kMargin);
    }];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.visibleCountLabel.mas_bottom);
        make.left.and.right.and.bottom.equalTo(self);
        make.height.equalTo(@44);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(cancelButton);
        make.height.equalTo(@0.5);
    }];
    
    
    @weakify(self);
    [[RACObserve(self.collectionView, contentSize) skip:1] subscribeNext:^(NSValue *contentSize) {
        @strongify(self);

        // 重新触发自动布局
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }];
    [RACObserve(self, visibleCount) subscribeNext:^(id x) {
        @strongify(self);
        BOOL enable = self.visibleCount > 0;
        confirmButton.enabled = enable;
        confirmButton.alpha = enable ? 1 : 0.6;
        self.visibleCountLabel.text = [NSString stringWithFormat:@"已选%d场比赛", (int)self.visibleCount];
    }];;
    
    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.96 alpha:1];
}

- (CGSize)intrinsicContentSize {
    CGFloat height = [self.collectionView.collectionViewLayout collectionViewContentSize].height + 30 + 44;
    return CGSizeMake(CGRectGetWidth(self.bounds), height);
}

#pragma mark - Property (getter, setter)

- (void)setDataSource:(NSArray *)dataSource {
    NSMutableArray *copyDataSource = [NSMutableArray arrayWithCapacity:dataSource.count];
    for (DPGameLiveFilterGroup *group in dataSource) {
        [copyDataSource addObject:group.copy];
    }
    _dataSource = copyDataSource;
}

#pragma mark - Private Function
/**
 *  遍历section下的所有item, 进行选中或者取消
 *
 *  @param section  [in]section
 *  @param selected [in]选中或取消
 */
- (void)traverseSection:(NSInteger)section selectedType:(DPGameLiveHeaderSelectedType)selectedType {
    DPGameLiveFilterGroup *group = self.dataSource[section];
    for (DPGameLiveFilterItem *item in group.items) {
        switch (selectedType) {
            case DPGameLiveHeaderSelectedTypeInvert:
                item.selected = !item.selected;
                break;
            case DPGameLiveHeaderSelectedTypeCheckAll:
                item.selected = YES;
                break;
            case DPGameLiveHeaderSelectedTypeCleanup:
                item.selected = NO;
                break;
        }
    }
    // 通知代理, 选项发生改变
    if ([self.delegate respondsToSelector:@selector(changeFilterView:)]) {
        [self.delegate changeFilterView:self];
    }
    // 刷新
    [self.collectionView reloadData];
}

#pragma mark - Delegate
#pragma mark - DPGameLiveFilterHeaderDelegate

- (void)checkAllForHeaderView:(DPGameLiveFilterHeaderView *)headerView {
    [self traverseSection:headerView.tag selectedType:DPGameLiveHeaderSelectedTypeCheckAll];
}

- (void)cleanupForHeaderView:(DPGameLiveFilterHeaderView *)headerView {
    [self traverseSection:headerView.tag selectedType:DPGameLiveHeaderSelectedTypeInvert];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DPGameLiveFilterGroup *group = self.dataSource[indexPath.section];
    DPGameLiveFilterItem *item = group.items[indexPath.row];
    
    item.selected = !item.selected;
    
    DPGameLiveFilterCell *cell = (DPGameLiveFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleButton.selected = item.selected;
    
    if ([self.delegate respondsToSelector:@selector(changeFilterView:)]) {
        [self.delegate changeFilterView:self];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    DPGameLiveFilterGroup *group = self.dataSource[section];
    return group.items.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    DPGameLiveFilterGroup *group = self.dataSource[indexPath.section];
    DPGameLiveFilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
    headerView.titleLabel.text = [NSString stringWithFormat:@"■ %@", group.title];
    headerView.delegate = self;
    headerView.tag = indexPath.section;
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPGameLiveFilterGroup *group = self.dataSource[indexPath.section];
    DPGameLiveFilterItem *item = group.items[indexPath.row];
    
    NSString *compentionName = item.name.length > 5 ? [[item.name substringToIndex:5] stringByAppendingString:@"..."] : item.name;
    
    DPGameLiveFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.titleButton.selected = item.selected;
    [cell.titleButton setTitle:compentionName forState:UIControlStateNormal];
    [cell.titleButton setTitle:compentionName forState:UIControlStateSelected];
    return cell;
}

@end
