//
//  DPSportFilterView.m
//  DacaiProject
//
//  Created by sxf on 14-7-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSportFilterView.h"
#import <OAStackView.h>


static NSString *const kDCLTSportCathecticFilterCellIdentifier = @"Cell";
static NSString *const kDCLTSportCathecticFilterSectionViewIdentifier = @"Header";

static NSString *const kDCLTSportCathecticFilterHeaderKey = @"Header";
static NSString *const kDCLTSportCathecticFilterAllKey = @"All";
static NSString *const kDCLTSportCathecticFilterCheckedKey = @"Checked";

const NSInteger kDCLTSportCathecticFilterViewWidth = 320;
const NSInteger kDCLTSportCathecticFilterSectionHeight = 70;
static const CGFloat kCollectionCellHeight = 29.0f;

const NSInteger kVSpace = 5;
const NSInteger kHSpace = 3;
const NSInteger kEdgeSpace = 8 ;



static const NSInteger kDCLTSportCathecticFilterAllTag = 300;
static const NSInteger kDCLTSportCathecticFilterInvertTag = 301;
static const NSInteger kDCLTSportCathecticFilterClearTag = 302;
static const NSInteger kDCLTSportStackViewTag = 303;


@class DPSportFilterCell;
@class DPSportFilterSectionView;

@interface DPFilterLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSArray *cellCounts;
@property (nonatomic, strong) NSArray *lineOffset;
@end

#pragma mark - Protocol

@protocol DPSportFilterSectionViewDelegate <NSObject>
@optional
- (void)sectionView:(DPSportFilterSectionView *)sectionView eventTag:(NSInteger)eventTag;
@end

#pragma mark - DPSportFilterView

@interface DPSportFilterView () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    DPSportFilterSectionViewDelegate> {
@private
        UICollectionView *_collectionView;
}

@property (nonatomic, strong) NSMutableArray *groupTitles;
@property (nonatomic, strong) NSMutableArray *allGroups;
@property (nonatomic, strong) NSMutableArray *selectedGroups;

@end

#pragma mark - DPSportFilterSectionView

@interface DPSportFilterSectionView : UICollectionReusableView
@property (nonatomic, assign) id<DPSportFilterSectionViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;

@end

#pragma mark - DPSportFilterCell
@interface DPSportFilterCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *titleButton;
@end


@interface DPSportFilterView (){

    UIView *_backgroundView;

}

@end
@implementation DPSportFilterView


- (instancetype)initWithGroupTitles:(NSArray *)titles allGroup:(NSArray*)allGroup selectGroup:(NSArray*)selectGroup
{
    self = [super init];
    if (self) {
         
        self.groupTitles = [NSMutableArray arrayWithArray:titles] ;
        self.allGroups = [NSMutableArray arrayWithArray:allGroup] ;
        self.selectedGroups = [NSMutableArray arrayWithArray:selectGroup ];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor] ;
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor =  UIColorFromRGB(0xF9FAF2);
    _backgroundView.layer.cornerRadius = 10;
    _backgroundView.clipsToBounds = YES;
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_backgroundView];
    
    [self buildLayout] ;
    

}


- (void)buildLayout {
    UIView *contentView = _backgroundView ;

    [contentView addSubview:self.collectionView];
   
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xd2cec6);

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton.titleLabel setFont:[UIFont dp_systemFontOfSize:18]];
    [cancelButton addTarget:self action:@selector(pvt_onCancel) forControlEvents:UIControlEventTouchUpInside];

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor dp_flatRedColor]];
    [confirmButton.titleLabel setFont:[UIFont dp_systemFontOfSize:18]];
    [confirmButton addTarget:self action:@selector(pvt_onConfirm) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:lineView];
    [contentView addSubview:cancelButton];
    [contentView addSubview:confirmButton];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.top.equalTo(cancelButton);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView.mas_centerX);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX);
        make.right.equalTo(contentView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(_backgroundView);
        make.top.equalTo(_backgroundView).offset(10);
        make.bottom.equalTo(@[confirmButton.mas_top, cancelButton.mas_top]);
     }];
    
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(16) ;
        make.right.equalTo(self.view).offset(-16) ;
        make.height.equalTo(@(self.collectionView.contentSize.height + 54 )).priorityLow();
        make.height.lessThanOrEqualTo(@(kScreenHeight-100));
    }];


}

- (void)addGroupWithTitle:(NSString *)title allItems:(NSArray *)allItems selectedItems:(NSArray *)selectedItems {
    DPAssert(title != nil && allItems != nil && selectedItems != nil);

    [self.groupTitles addObject:title];
    [self.allGroups addObject:allItems];
    [self.selectedGroups addObject:selectedItems.mutableCopy];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        DPFilterLayout *flowLayout = [[DPFilterLayout alloc] init];
 
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DPSportFilterCell class] forCellWithReuseIdentifier:kDCLTSportCathecticFilterCellIdentifier];
        [_collectionView registerClass:[DPSportFilterSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDCLTSportCathecticFilterSectionViewIdentifier];
    }
    return _collectionView;
}

 - (void)pvt_onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pvt_onConfirm {
    
    NSInteger rowCount = 0 ;
    for (int i = 0; i < self.selectedGroups.count; i++) {
        NSArray *selected = self.selectedGroups[i];
        if (selected.count != 0) {
            rowCount+=1 ;
        }
    }
    if (rowCount == 0) {
        [[DPToast makeText:@"至少选择一个筛选条件"] show];
        return ;
    }else if (rowCount== 1){
        [[DPToast makeText:@"所筛选的条件无数据"] show];
        return ;
     }

    
    for (int i = 0; i < self.allGroups.count; i++) {
        NSArray *allItems = self.allGroups[i];
        NSMutableArray *selectedItems = self.selectedGroups[i];
        
        for (int i = 0; i < selectedItems.count; ) {
            id obj = selectedItems[i];
            if (![allItems containsObject:obj]) {
                [selectedItems removeObject:obj];
            } else {
                i++;
            }
        }
    }

    if (self.reloadFilter) {
        self.reloadFilter(self.selectedGroups) ;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [self collectionView:collectionView numberOfItemsInSection:section] == 0 ? CGSizeZero : CGSizeMake(kDCLTSportCathecticFilterViewWidth, kDCLTSportCathecticFilterSectionHeight);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groupTitles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.allGroups[section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPSportFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDCLTSportCathecticFilterCellIdentifier forIndexPath:indexPath];

    NSMutableArray *allItems = self.allGroups[indexPath.section];
    NSMutableArray *selectedItems = self.selectedGroups[indexPath.section];

    NSString *title = allItems[indexPath.row];
    [cell.titleButton setTitle:title forState:UIControlStateNormal];
    [cell.titleButton setTitle:title forState:UIControlStateSelected];
    [cell.titleButton setSelected:[selectedItems containsObject:title]];
     return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    assert([kind isEqualToString:UICollectionElementKindSectionHeader]);

    DPSportFilterSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDCLTSportCathecticFilterSectionViewIdentifier forIndexPath:indexPath];

    sectionView.delegate = self;
    sectionView.tag = indexPath.section;
    sectionView.titleLabel.text = self.groupTitles[indexPath.section];
    
    OAStackView *stackView = (OAStackView*)[sectionView viewWithTag:kDCLTSportStackViewTag] ;
    
    UIButton *button =   (UIButton *)[stackView viewWithTag:kDCLTSportCathecticFilterAllTag];
    button.selected = [self.allGroups[indexPath.section] count] == [self.selectedGroups[indexPath.section] count];
    
    return sectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *selectedItems = self.selectedGroups[indexPath.section];
    NSString *title = self.allGroups[indexPath.section][indexPath.row];

    if ([selectedItems containsObject:title]) {
        [selectedItems removeObject:title];
    } else {
        [selectedItems addObject:title];
    }
    [collectionView reloadData];
//    DPSportFilterCell *cell = (DPSportFilterCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    [cell.titleButton setSelected:[selectedItems containsObject:title]];
//    
//    DPSportFilterSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDCLTSportCathecticFilterSectionViewIdentifier forIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
}

#pragma mark - setter; getter

- (CGSize)contentSize {
//    [self.collectionView layoutIfNeeded];
    [self.collectionView.collectionViewLayout prepareLayout];
    
    return CGSizeMake(self.collectionView.collectionViewLayout.collectionViewContentSize.width, self.collectionView.collectionViewLayout.collectionViewContentSize.height + 40);
}

#pragma mark - DPSportFilterSectionViewDelegate

- (void)sectionView:(DPSportFilterSectionView *)sectionView eventTag:(NSInteger)eventTag {
    NSInteger section = sectionView.tag;
    NSArray *allItems = self.allGroups[section];
    NSMutableArray *selectedItems = self.selectedGroups[section];

    switch (eventTag) {
        case kDCLTSportCathecticFilterAllTag: {
            [selectedItems removeAllObjects];
            [selectedItems addObjectsFromArray:allItems];
        } break;
        case kDCLTSportCathecticFilterInvertTag: {
            [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([selectedItems containsObject:obj]) {
                    [selectedItems removeObject:obj];
                } else {
                    [selectedItems addObject:obj];
                }
            }];
        } break;
        case kDCLTSportCathecticFilterClearTag: {
            [selectedItems removeAllObjects];
        } break;
        default:
            break;
    }

    [self.collectionView reloadData];
}

@end

@implementation DPSportFilterSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColorFromRGB(0xF9FAF2)];
 
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self;

    UIView *roundView = [[UIView alloc] init];
    roundView.backgroundColor = UIColorFromRGB(0x7e6b5a);
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xeae2da);

      UIButton *allSelectionButton = ({
        UIButton *button = [[UIButton alloc] init];
         button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
          
          [button setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
          [button setBackgroundImage:[self imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateHighlighted];
          [button setBackgroundImage:[self imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateSelected];

        
        [button setTitleColor:[UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button setTitle:@"全选" forState:UIControlStateNormal];
         @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(sectionView:eventTag:)]) {
  
                [self.delegate sectionView:self eventTag:kDCLTSportCathecticFilterAllTag];
            }
        }];
        button.tag= kDCLTSportCathecticFilterAllTag ;
        button;
    });
    
    UIButton *invertSelectionButton = ({
        UIButton *button = [[UIButton alloc] init];
         button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        button.layer.borderWidth = 1 ;
        button.layer.borderColor = UIColorFromRGB(0xe0d8c8).CGColor ;
        
        [button setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

        
        [button setTitle:@"反选" forState:UIControlStateNormal];
         @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(sectionView:eventTag:)]) {
                
                [self.delegate sectionView:self eventTag:kDCLTSportCathecticFilterInvertTag];
            }
        }];
        button.tag = kDCLTSportCathecticFilterInvertTag ;
        button;
    });
    
    UIButton *allClearButton = ({
        UIButton *button = [[UIButton alloc] init];
         button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        [button setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateHighlighted];
        
        [button setTitleColor:[UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setTitle:@"全清" forState:UIControlStateNormal];
         @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(sectionView:eventTag:)]) {
                
                [self.delegate sectionView:self eventTag:kDCLTSportCathecticFilterClearTag];
            }
        }];
        button.tag = kDCLTSportCathecticFilterClearTag ;
        button;
    });


    
    OAStackView *stackView = ({
        OAStackView *view = [[OAStackView alloc] initWithArrangedSubviews:@[allSelectionButton, invertSelectionButton,allClearButton]];
        view.axis = UILayoutConstraintAxisHorizontal;
        view.distribution = OAStackViewDistributionFillEqually;
        view.alignment = OAStackViewAlignmentFill;
        view.backgroundColor = [UIColor clearColor] ;
        view.layer.borderColor = UIColorFromRGB(0xe0d8c8).CGColor ;
        view.layer.borderWidth = 1;
        view.tag = kDCLTSportStackViewTag ;
        view;
    });

    // Layout
    [contentView addSubview:roundView];
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:lineView];
    [contentView addSubview:stackView];
   
    [roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@6);
        make.height.equalTo(@6);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(invertSelectionButton.mas_top);
        make.left.equalTo(contentView).offset(22);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(contentView);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.height.equalTo(@0.5);
    }];
    
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-10);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.equalTo(@30);
    }];

    
 }

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont dp_systemFontOfSize:13];
        _titleLabel.textColor = UIColorFromRGB(0x7e6b5a);
    }
    return _titleLabel;
}

- (void)pvt_onClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionView:eventTag:)]) {
        [self.delegate sectionView:self eventTag:button.tag];
    }
}

@end

@implementation DPSportFilterCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    self.backgroundColor = [UIColor dp_flatWhiteColor];
    self.contentView.backgroundColor = [UIColor dp_flatWhiteColor];

    [self.contentView addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[UIButton alloc] init];
        [_titleButton setTitleColor:[UIColor colorWithRed:0.42 green:0.35 blue:0.28 alpha:1] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [_titleButton setBackgroundColor:[UIColor clearColor]];
        [_titleButton setImage:nil forState:UIControlStateNormal];
        [_titleButton setImage:dp_CommonImage(@"red_check.png") forState:UIControlStateSelected];
        [_titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        [_titleButton setUserInteractionEnabled:NO];
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
        _titleButton.layer.borderColor = UIColorFromRGB(0xd2cec6).CGColor ;
        [_titleButton.layer setBorderWidth:1];
        [_titleButton.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];
        [_titleButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return _titleButton;
}

@end



@implementation DPFilterLayout

- (CGSize)collectionViewContentSize{

    CGFloat height = 0;
    for (NSNumber *count in self.cellCounts) {
        NSInteger lineCount = count.integerValue > 0 ? (count.integerValue - 1) / 3 + 1 : 0;
        height += kDCLTSportCathecticFilterSectionHeight;
        height += lineCount * (kCollectionCellHeight + kVSpace);
    }
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height+10);
 
}

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
    self.cellCounts = cellCounts;
    self.lineOffset = lineOffset;
    self.itemWidth = floorf((CGRectGetWidth(self.collectionView.bounds) - 2 * kEdgeSpace - 2 * kHSpace) / 3.0);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger x = indexPath.row % 3, y = indexPath.row / 3;
    NSInteger offset = [self.lineOffset[indexPath.section] integerValue];
    CGFloat offsetX[] = { kEdgeSpace, kEdgeSpace + self.itemWidth + kHSpace, kEdgeSpace + (self.itemWidth + kHSpace) * 2 };
    CGFloat offsetY = offset * (kVSpace + kCollectionCellHeight) + (indexPath.section + 1) * kDCLTSportCathecticFilterSectionHeight;
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.indexPath = indexPath;
    attr.frame = CGRectMake(offsetX[x], offsetY + y * (kCollectionCellHeight + kVSpace) , self.itemWidth, kCollectionCellHeight);

//    attr.frame = CGRectMake(offsetX[x], offsetY + y * (kCollectionCellHeight + kVSpace) + 5, self.itemWidth, kCollectionCellHeight);
    return attr;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger offset = [self.lineOffset[indexPath.section] integerValue];
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    attr.frame = CGRectMake(0, offset * (kVSpace + kCollectionCellHeight) + indexPath.section * kDCLTSportCathecticFilterSectionHeight, CGRectGetWidth(self.collectionView.bounds), kDCLTSportCathecticFilterSectionHeight);
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
                UICollectionViewLayoutAttributes *lastCellAttrInSection = [allArray objectAtIndex:section + cellCount];
                 frame.origin.y = MIN(self.collectionView.contentOffset.y, CGRectGetMaxY(lastCellAttrInSection.frame)+kVSpace-kDCLTSportCathecticFilterSectionHeight);

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

