//
//  DPAppDebuggerTestController.m
//  Jackpot
//
//  Created by WUFAN on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#ifdef DEBUG

#import "DPAppDebuggerTestController.h"

static NSString *const kCellIdentifier = @"Cell";
static NSString *const kHeaderIdentifier = @"Header";

@interface DPAppDebuggerTestController () <UICollectionViewDelegate, UICollectionViewDataSource, KTMCollectionViewDelegateTableLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger numberOfSections;
@end

@implementation DPAppDebuggerTestController

- (void)showWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor yellowColor];
    window.windowLevel = UIWindowLevelAlert;
    [window makeKeyAndVisible];
    [window makeKeyWindow];
    [window becomeKeyWindow];
    [window becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 100)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 50, 100)];
    view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:view2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = view1.frame;
            frame.origin.y = 400;
            view1.frame = frame;
        }];
        
        CGPoint point = view2.layer.position;
        CGPoint toPoint = point;
        toPoint.y += 350;
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        view2.layer.position = toPoint;
        [CATransaction commit];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeBoth;
        animation.fromValue = [NSValue valueWithCGPoint:point];
        animation.toValue = [NSValue valueWithCGPoint:toPoint];
        animation.duration = 0.25;
        [view2.layer addAnimation:animation forKey:@"xy"];
        
    });
    

    self.numberOfSections = 0;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    void (^block)(void) = ^{
        self.numberOfSections++;
        [self.collectionView reloadData];
        [self.collectionView ktm_stopFooterAnimatingWithHasMoreData:self.numberOfSections < 4];
    };
    
    [self.collectionView ktm_addInfiniteScrollingWithHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        KTMCollectionViewTableLayout *layout = [[KTMCollectionViewTableLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor dp_randomColor];
    
    UILabel *label = [cell.contentView viewWithTag:123321];
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 30)];
        label.textColor = [UIColor redColor];
        label.tag = 123321;
        label.font = [UIFont systemFontOfSize:12];
        
        [cell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"row: %d", (int)indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
    UILabel *label = [view viewWithTag:112233];
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        label.textColor = [UIColor redColor];
        label.tag = 112233;
        label.font = [UIFont systemFontOfSize:12];
        
        view.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:label];
    }
    
    label.text = [NSString stringWithFormat:@"section: %d", (int)indexPath.section];
    
    return view;
}
#pragma mark - KTMCollectionViewDelegateTableLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

@end

#endif