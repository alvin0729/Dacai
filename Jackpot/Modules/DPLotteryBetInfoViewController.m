//
//  DPLotteryBetInfoViewController.m
//  Jackpot
//
//  Created by sxf on 15/8/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLotteryBetInfoViewController.h"
#import "DPOrderInfoCell.h"
#import "Order.pbobjc.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#define LOTTERY_RESULT_PAGE_TOTAL 20

static NSString* kCellIdentifier = @"cell";//竞彩足球主体
static NSString* kHeaderIdentifier = @"header";//区头
static NSString* kFooterIdentifier = @"footer";//区尾
static NSString* kFirstHeaderIdentifier = @"firstHeader";
@interface DPLotteryBetInfoViewController () <UICollectionViewDataSource,
    UICollectionViewDelegate> {
@private
    UICollectionView *_tableView;
}
@property (nonatomic, strong, readonly) UICollectionView *tableView;
@property (nonatomic, strong) PBMOrderDetailResult *database;
@property (nonatomic, strong) NSMutableArray *infoArray;//查票详情
@end

@implementation DPLotteryBetInfoViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.infoArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 8, 0));
    }];
    self.title = @"订单详情";

    [self requestDrawInfoList:YES];
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.tableView.showsInfiniteScrolling = NO;
        [weakSelf requestDrawInfoList:YES];
    }
                                             position:SVPullToRefreshPositionTop];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (self.database.totalNum > self.infoArray.count) {
            [weakSelf requestDrawInfoList:NO];
        }
    }];
    self.tableView.showsInfiniteScrolling = NO;
    // Do any additional setup after loading the view.
}

/**
 *  请求拆票数据(支持下拉刷新和上拉分页)
 *  reload 1:下拉刷新  0:上拉分页
 *  @param reload
 */
- (void)requestDrawInfoList:(BOOL)reload
{
    int ps = LOTTERY_RESULT_PAGE_TOTAL;
    int pi = 1;
    if (!reload) {
        pi = (int)[self.infoArray count] / ps + 1;
    }
    else {
        [_infoArray removeAllObjects];
    }
    [self showHUD];
    
    /**
     *  请求拆票数据
     *  projectId  方案or订单id
     *  gameTypeId 彩种id
     *  pi         第几行
     *  ps         请求行里拆票的个数
     */
    [[AFHTTPSessionManager dp_sharedManager] GET:@"/project/GetTickset"
        parameters:@{ @"projectId" : @(self.projectId),
            @"gameTypeId" : @(self.gameType),
            @"pi" : @(pi),
            @"ps" : @(ps) }
        success:^(NSURLSessionDataTask* task, id responseObject) {

            [self dismissHUD];
            self.database = [PBMOrderDetailResult parseFromData:responseObject error:nil];
            if (self.gameType == GameTypeDlt) {
                [self.infoArray addObjectsFromArray:self.database.dltItemsArray];
            }
            else if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
                [self.infoArray addObjectsFromArray:self.database.jcItemsArray];
            }
            [self requestAllData];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView.infiniteScrollingView stopAnimating];
            //已无更多数据，当大于一行的时候，显示，小于一行的时候，隐藏
            [self.tableView setShowsInfiniteScrolling:self.database.totalNum > self.infoArray.count || self.database.totalNum > 20 ? YES : NO];
            [self.tableView.infiniteScrollingView setEnabled:self.database.totalNum > self.infoArray.count ? YES : NO];
        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}
//请求数据 其实就是刷新下列表
- (void)requestAllData
{
    [self.tableView reloadData];
}
#pragma UITableView

/**
 *  列表整体说明
 *
 *  @param 对于数字彩来说，infoArray 代表着一个区
 *  @param 对于竞彩系列来说，infoArray 里面的每一条数据代表着一个区（区里有区头和区尾）
 *  @param 对于竞彩系列分行来说，之所以-1，是因为为了分割钱好处理，把最后一个内容作为区尾的一部分去处理
 *
 *  @return
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionVieww
{
    
    if (!IsGameTypeLc(self.gameType) && !IsGameTypeJc(self.gameType)) {
        return 2;
    }
    if (self.infoArray.count == 0) {
        return 0;
    }
    return MAX(1, self.infoArray.count + 1);
}
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }

    if (!IsGameTypeLc(self.gameType) && !IsGameTypeJc(self.gameType)) {
        return self.infoArray.count;
    }

    if (self.infoArray.count <= section - 1) {
        return 0;
    }
    PBMOrderDetailResult_JcItem* item = [self.infoArray objectAtIndex:section - 1];
    return MAX(0, item.jcResultsArray.count - 1);
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (!IsGameTypeLc(self.gameType) && !IsGameTypeJc(self.gameType)) {
        return CGSizeMake(kScreenWidth, 87 + [self infoLabelHieght:indexPath] + 8);
    }
    return CGSizeMake(kScreenWidth, [self infoLabelHieght:indexPath]);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
            return CGSizeMake(kScreenWidth, 115);
        }
        return CGSizeMake(kScreenWidth, 53);
    }
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        return CGSizeMake(kScreenWidth - 10, 65);
    }
    return CGSizeMake(kScreenWidth - 10, 0);
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreenWidth - 10, 0);
    }
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        PBMOrderDetailResult_JcItem* jcItem = [self.infoArray objectAtIndex:section - 1];
        PBMOrderDetailResult_JcResult* infoItem = [jcItem.jcResultsArray objectAtIndex:(jcItem.jcResultsArray.count - 1)];
        CGRect rect = [[self upDateAllDataForJcLottery:infoItem] boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

        return CGSizeMake(kScreenWidth - 10, ceil(57 + rect.size.height));
    }
    return CGSizeMake(kScreenWidth - 10, 0);
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{

    if (self.gameType == GameTypeDlt) {
        DPOrderInfoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        //安全判断
        if (indexPath.row >= self.infoArray.count) {
            return cell;
        }
        PBMOrderDetailResult_DltItem* item = [self.infoArray objectAtIndex:indexPath.row];
        //序号
        [cell orderNumberLabelText:[NSString stringWithFormat:@"序号: %@", item.orderNum]];
        ////订单期号等信息  isAppend 1:追加投注 0:不追加投注
        NSString* titleText = item.isAppend ? [NSString stringWithFormat:@"%@期，%@，%lld注*%lld倍  追加", self.database.winIssue, item.gamePlay, item.quantity, item.multiple] : [NSString stringWithFormat:@"%@期，%@，%lld注*%lld倍", self.database.winIssue, item.gamePlay, item.quantity, item.multiple];
        [cell titleLabelText:titleText];
        ////订单金额
        [cell moneyLabelText:[NSString stringWithFormat:@"%d", item.money]];
        //订单详情
        NSMutableAttributedString* hinstring = [self upDateAllDataForNumberLottery:item];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];

        [paragraphStyle setLineSpacing:[self infoLabelHieght:indexPath] > 30 ? 8 : 0]; //调整行间距
        [hinstring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [hinstring length])];
        [cell infoLabelText:hinstring];
        return cell;
    }
    DPJcOrderInfoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    //安全判断
    if (indexPath.section - 1 >= self.infoArray.count) {
        return cell;
    }
    PBMOrderDetailResult_JcItem* item = [self.infoArray objectAtIndex:indexPath.section - 1];
    if (item.jcResultsArray.count <= indexPath.row) {
        return cell;
    }
    PBMOrderDetailResult_JcResult* infoItem = [item.jcResultsArray objectAtIndex:indexPath.row];
    //订单详情
    [cell infoLabelText:[self upDateAllDataForJcLottery:infoItem]];
    //标示  如周一001
    [cell rqLableText:infoItem.dateNum];
    //订单详情标题
    [cell infoLabelTitleText:[NSString stringWithFormat:@"%@ ", dp_GameTypeJCFullName(infoItem.gameType)]];

    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    
    if (!IsGameTypeJc(self.gameType) && !IsGameTypeLc(self.gameType) && indexPath.section != 0) {
        return nil;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            DPHeaderViewForOrderFirstView* firstView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFirstHeaderIdentifier forIndexPath:indexPath];
            if (!firstView.isBulid) {
                [firstView bulidLayOut:self.gameType];
            }
            //总票数
            NSMutableAttributedString* ticketString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总票数:  %d张", self.database.totalNum]];
            NSRange range = [[ticketString string] rangeOfString:[NSString stringWithFormat:@"%d", self.database.totalNum]];
            [ticketString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(0, ticketString.length)];
            [ticketString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xd80000) range:range];
            [ticketString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, ticketString.length)];
            [ticketString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 6)];
            firstView.ticketLabel.attributedText = ticketString;

            //总金额
            NSMutableAttributedString* moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额:  %lld元", self.database.totalMoney]];
            NSRange range2 = [[moneyString string] rangeOfString:[NSString stringWithFormat:@"%lld", self.database.totalMoney]];
            [moneyString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(0, moneyString.length)];
            [moneyString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xd80000) range:range2];
            [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, moneyString.length)];
            [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
            firstView.moneyLabel.attributedText = moneyString;

            return firstView;
        }
       
        DPHeaderViewForJcOrder* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        if (self.infoArray.count <= indexPath.section - 1) {
            return view;
        }
        PBMOrderDetailResult_JcItem* item = [self.infoArray objectAtIndex:indexPath.section - 1];
        [view orderNumberLabelText:[NSString stringWithFormat:@"序号:%@", item.orderNum]];
        [view titleLabelText:[NSString stringWithFormat:@"%@，%@，%d倍", item.gameName, item.gamePlay, item.multiple]];
        [view moneyLabelText:[NSString stringWithFormat:@"%d", item.money]];
        return view;
    }
    DPFooterViewForJcOrder* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterIdentifier forIndexPath:indexPath];
    if (self.infoArray.count <= indexPath.section - 1) {
        return view;
    }
    PBMOrderDetailResult_JcItem* item = [self.infoArray objectAtIndex:indexPath.section - 1];

    PBMOrderDetailResult_JcResult* infoItem = [item.jcResultsArray objectAtIndex:item.jcResultsArray.count - 1];
    [view infoLabelText:[self upDateAllDataForJcLottery:infoItem]];
    [view rqLableText:infoItem.dateNum];
    [view infoLabelTitleText:[NSString stringWithFormat:@"%@", dp_GameTypeJCFullName(infoItem.gameType)]];
    return view;
}

//获取高度
- (float)infoLabelHieght:(NSIndexPath*)indexPath
{

    if (self.gameType == GameTypeDlt) {
        if (indexPath.row >= self.infoArray.count) {
            return 30;
        }
        PBMOrderDetailResult_DltItem* item = [self.infoArray objectAtIndex:indexPath.row];
        NSMutableAttributedString* hinstring = [self upDateAllDataForNumberLottery:item];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        CGRect tempRect = [hinstring boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        [paragraphStyle setLineSpacing:tempRect.size.height > 30 ? 8 : 0]; //调整行间距
        [hinstring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [hinstring length])];
        [hinstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, [hinstring length])];
        CGRect rect = [hinstring boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

        return ceil(rect.size.height);
    }
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        if (indexPath.section - 1 >= self.infoArray.count) {
            return 30;
        }
        PBMOrderDetailResult_JcItem* jcItem = [self.infoArray objectAtIndex:indexPath.section - 1];
        PBMOrderDetailResult_JcResult* infoItem = [jcItem.jcResultsArray objectAtIndex:indexPath.row];
        CGRect rect = [[self upDateAllDataForJcLottery:infoItem] boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

        return ceil(57 + rect.size.height);
    }
    return 30;
}

//数字彩
- (NSMutableAttributedString*)upDateAllDataForNumberLottery:(PBMOrderDetailResult_DltItem*)item
{
    NSMutableAttributedString* hinstring = [[NSMutableAttributedString alloc] initWithString:@""];
    if (item.dltDtResultsArray.count > 0) {
        for (int i = 0; i < item.dltDtResultsArray.count; i++) {
            PBMOrderDetailResult_DltDTResult* danItem = [item.dltDtResultsArray objectAtIndex:i];
            NSString* redDan = [self stringForAreaArray:danItem.redDansArray];
            NSString* redTuo = [self stringForAreaArray:danItem.redTuosArray];
            NSString* blueDan = [self stringForAreaArray:danItem.blueDansArray];
            NSString* blueTuo = [self stringForAreaArray:danItem.blueTuosArray];
            NSMutableAttributedString* tempString = [[NSMutableAttributedString alloc] initWithString:danItem.blueDansArray.count > 0 ? [NSString stringWithFormat:@"%@  #  %@  |  %@  #  %@", redDan, redTuo, blueDan, blueTuo] : [NSString stringWithFormat:@"%@  #  %@  |  %@", redDan, redTuo, blueTuo]];
            // 前区胆
            [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xdc5051) range:NSMakeRange(0, redDan.length)];
            // #
            [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSMakeRange(redDan.length + 2, 1)];
            // 前区拖
            [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xdc5051) range:NSMakeRange(redDan.length + 5, redTuo.length)];
            // |
            [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSMakeRange(redDan.length + redTuo.length + 7, 1)];
            if (danItem.blueDansArray.count > 0) {
                //后区胆
                [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1f96fe) range:NSMakeRange(redDan.length + redTuo.length + 10, blueDan.length)];
                // #
                [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSMakeRange(redDan.length + redTuo.length + blueDan.length + 12, 1)];
                //后区拖
                [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1f96fe) range:NSMakeRange(redDan.length + redTuo.length + blueDan.length + 15, blueTuo.length)];
            }
            else {
                [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1f96fe) range:NSMakeRange(redDan.length + redTuo.length + 10, blueTuo.length)];
            }

            if (i > 0) {
                [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            }
            [hinstring appendAttributedString:tempString];
        }
        return hinstring;
    }
    for (int i = 0; i < item.dltResultsArray.count; i++) {
        PBMOrderDetailResult_DltResult* normalItem = [item.dltResultsArray objectAtIndex:i];
        //前区
        NSString* redString = [self stringForAreaArray:normalItem.redsArray];
        //后区
        NSString* blueString = [self stringForAreaArray:normalItem.bluesArray];
        NSMutableAttributedString* tempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  |  %@", redString, blueString]];
        [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSMakeRange(0, tempString.length)];
        [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xdc5051) range:NSMakeRange(0, redString.length)];
        [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1f96fe) range:NSMakeRange(redString.length + 5, blueString.length)];
        if (i > 0) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        }
        [hinstring appendAttributedString:tempString];
    }
    return hinstring;
}
//array转为string类型
- (NSString*)stringForAreaArray:(NSArray*)array
{
    NSString* string = @"";
    for (int i = 0; i < array.count; i++) {
        string = i > 0 ? [NSString stringWithFormat:@"%@  %@", string, [array objectAtIndex:i]] : [NSString stringWithFormat:@"%@", [array objectAtIndex:i]];
    }
    return string;
}

//获取竞彩投注内容
- (NSMutableAttributedString*)upDateAllDataForJcLottery:(PBMOrderDetailResult_JcResult*)item
{
    NSDictionary* attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                 UIColorFromRGB(0x877e6d), NSForegroundColorAttributeName,
                                                 nil]; //未中奖
    NSMutableAttributedString* infoString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (int i = 0; i < item.jcResultItemsArray.count; i++) {
        PBMOrderDetailResult_JcResultItem* JcResultItem = [item.jcResultItemsArray objectAtIndex:i];
        if (i > 0) {
            [infoString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        }
        [infoString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:JcResultItem.result attributes:attributeDict2]];
    }

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:item.jcResultItemsArray.count > 1 ? 8 : 0]; //调整行间距
    [infoString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [infoString length])];
    return infoString;
}

#pragma mark - getter, setter
- (UICollectionView*)tableView
{
    if (_tableView == nil) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        _tableView = ({
            UICollectionView* collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            if (self.gameType == GameTypeDlt) {
                [collect registerClass:[DPOrderInfoCell class] forCellWithReuseIdentifier:kCellIdentifier];
            }
            else {
                [collect registerClass:[DPJcOrderInfoCell class] forCellWithReuseIdentifier:kCellIdentifier];
            }
            [collect registerClass:[DPHeaderViewForJcOrder class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
            [collect registerClass:[DPFooterViewForJcOrder class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterIdentifier];
            [collect registerClass:[DPHeaderViewForOrderFirstView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFirstHeaderIdentifier];
            collect.alwaysBounceVertical = YES;
            collect.dataSource = self;
            collect.delegate = self;
            collect.backgroundColor = [UIColor dp_flatBackgroundColor];
            collect.tag = 3;
            collect;
        });
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
