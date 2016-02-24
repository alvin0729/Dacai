//
//  DPTicketViewController.m
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTicketCell.h"
#import "DPTicketViewController.h"
#import "DPWebViewController.h"
#import "NSAttributedString+DDHTML.h"
#import "Order.pbobjc.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#define LOTTERY_RESULT_PAGE_TOTAL 20

static NSString* kCellIdentifier = @"cell";
static NSString* kHeaderIdentifier = @"header";
static NSString* kFirstHeaderIdentifier = @"firstHeader";
static NSString* kFooterIdentifier = @"footer";
@interface DPTicketViewController () <UICollectionViewDataSource,
    UICollectionViewDelegate, DPTicketCellDelegate> {
@private
    UICollectionView* _tableView;
}

@property (nonatomic, strong, readonly) UICollectionView *tableView;
@property (nonatomic, strong) PBMOrderDetailResult *dataBase;
@property (nonatomic, strong) NSMutableArray *infoArray;
@end

@implementation DPTicketViewController
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
    self.title = @"票样";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 8, 0));
    }];

    [self requestDrawInfoList:YES];
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.tableView.showsInfiniteScrolling = NO;
        [weakSelf requestDrawInfoList:YES];
    }
                                             position:SVPullToRefreshPositionTop];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (self.dataBase.totalNum > self.infoArray.count) {
            [weakSelf requestDrawInfoList:NO];
        }
    }];
    self.tableView.showsInfiniteScrolling = NO;

    // Do any additional setup after loading the view.
}

/**
 *  分页请求
 *  reload 1: 下拉刷新数据  0:上来请求整个数据
 *  @return
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
     *  projectId 方案号
     *  gameTypeId 彩种id
     *  pi 请求第几页
     *  ps 请求页数里的个数
     */
    [[AFHTTPSessionManager dp_sharedManager] GET:@"/project/GetTickset"
        parameters:@{ @"projectId" : @(self.projectId),
            @"gameTypeId" : @(self.gameType),
            @"pi" : @(pi),
            @"ps" : @(ps) }
        success:^(NSURLSessionDataTask* task, id responseObject) {

            [self dismissHUD];
            self.dataBase = [PBMOrderDetailResult parseFromData:responseObject error:nil];
            if (self.gameType == GameTypeDlt) {
                [self.infoArray addObjectsFromArray:self.dataBase.dltItemsArray];
            }
            else if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
                [self.infoArray addObjectsFromArray:self.dataBase.jcItemsArray];
            }

            [self requestAllData];

            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView.infiniteScrollingView stopAnimating];
            //是否显示暂无更多数据 目前的处理:只有多于一行的时候，才显示
            [self.tableView setShowsInfiniteScrolling:self.dataBase.totalNum > self.infoArray.count || self.dataBase.totalNum > 20 ? YES : NO];
            [self.tableView.infiniteScrollingView setEnabled:self.dataBase.totalNum > self.infoArray.count ? YES : NO];
        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}
//刷新列表
- (void)requestAllData
{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    //如果是数字彩，则2个分区，如果是竞彩，则每一大注为一分区（里面具体内容为行） sxf
    if (!IsGameTypeLc(self.gameType) && !IsGameTypeJc(self.gameType)) {
        return 2;
    }
    if (self.infoArray.count == 0) {
        return 1;
    }
    return MAX(1, self.infoArray.count + 1);
}

/**
 *  sxf
 *
 *  @param 第一行和以前tableView的头部类似，这里作为一个分区存在，因此下边取分区的时候，-1
 *  @param 为了处理竞彩里每一行的分割线不统一的问题，因此把最后一行当做区尾曲处理，所以算分区里行有关的时候 -1
 *
 *  @return 这条准则适合这个页面所有与行和区有关的函数
 */
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (section == 0) {
        return 0;
    }
    //数字彩
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
        return CGSizeMake(kScreenWidth, 125 + [self infoLabelHieght:indexPath]);
    }
    return CGSizeMake(kScreenWidth, [self infoLabelHieght:indexPath]);
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
            return CGSizeMake(kScreenWidth, 55);
        }
        return CGSizeMake(kScreenWidth, 70);
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

        return CGSizeMake(kScreenWidth - 10, ceil(97 + rect.size.height));
    }
    return CGSizeMake(kScreenWidth - 10, 0);
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
        CGRect tempRect = [hinstring boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        [paragraphStyle setLineSpacing:tempRect.size.height > 30 ? 8 : 0]; //调整行间距
        [hinstring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [hinstring length])];
        [hinstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, [hinstring length])];
        CGRect rect = [hinstring boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

        return rect.size.height;
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

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{

    UIFont* font = [UIFont systemFontOfSize:12.0];
    if (self.gameType == GameTypeDlt) {
        DPTicketCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        if (indexPath.row >= self.infoArray.count) {
            return cell;
        }

        PBMOrderDetailResult_DltItem* item = [self.infoArray objectAtIndex:indexPath.row];
        [cell orderNumberLabelText:item.orderNum];
        //item.isAppend 大乐透是否追加投注
        [cell titleLabelText:item.isAppend ? [NSString stringWithFormat:@"%@，%lld注*%lld倍  追加", item.gamePlay, item.quantity, item.multiple] : [NSString stringWithFormat:@"%@，%lld注*%lld倍", item.gamePlay, item.quantity, item.multiple]];
        [cell moneyLabelText:[NSString stringWithFormat:@"%d", item.money]];
        [cell winInfoText:[NSAttributedString attributedStringFromHTML:item.winDesc normalFont:font boldFont:font italicFont:font]];
        //是否中奖 item.isWin  1:中奖  0:不中奖
        [cell isShowWinImageView:item.isWin];
        // 是否出票  1:出票成功 可以查询票号
        [cell showCopyTicket:item.orderNum.length>0?YES:NO];
        //获取大乐透投注内容
        NSMutableAttributedString* hinstring = [self upDateAllDataForNumberLottery:item];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[self infoLabelHieght:indexPath] > 30 ? 8 : 0]; //调整行间距
        [hinstring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [hinstring length])];
        [cell infoLabelText:hinstring];

        return cell;
    }
    DPJcTicketCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (self.infoArray.count <= indexPath.section - 1) {
        return cell;
    }
    PBMOrderDetailResult_JcItem* item = [self.infoArray objectAtIndex:indexPath.section - 1];
    if (item.jcResultsArray.count <= indexPath.row) {
        return cell;
    }
    PBMOrderDetailResult_JcResult* infoItem = [item.jcResultsArray objectAtIndex:indexPath.row];
    //获取竞彩投注内容
    [cell infoLabelText:[self upDateAllDataForJcLottery:infoItem]];
    //获取竞彩日期编号
    [cell rqLableText:infoItem.dateNum];
    if ([infoItem.rqs intValue] != 0) {
        NSString* title = @"让分";
        if (infoItem.gameType == GameTypeJcRqspf) {
            title = @"让球";
        }
        if (infoItem.gameType == GameTypeLcDxf) {
            title = @"总分";
            [cell infoLabelTitleText:[NSString stringWithFormat:@"%@    %@:%@", dp_GameTypeJCFullName(infoItem.gameType), title, infoItem.rqs]];
        }
        else {

            [cell infoLabelTitleText:[infoItem.rqs intValue] > 0 ? [NSString stringWithFormat:@"%@    %@:主+%@", dp_GameTypeJCFullName(infoItem.gameType), title, infoItem.rqs] : [NSString stringWithFormat:@"%@    %@:主%@", dp_GameTypeJCFullName(infoItem.gameType), title, infoItem.rqs]];
        }
    }
    else {
        [cell infoLabelTitleText:[NSString stringWithFormat:@"%@ ", dp_GameTypeJCFullName(infoItem.gameType)]];
    }

    return cell;
}
- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    //数字彩第二个分区则无区头和区尾
    if (!IsGameTypeJc(self.gameType) && !IsGameTypeLc(self.gameType) && indexPath.section != 0) {
        return nil;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            DPHeaderViewForFirstView* firstView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFirstHeaderIdentifier forIndexPath:indexPath];
            if (!firstView.isBulid) {
                [firstView bulidLayOut:self.gameType];
            }
            //数字彩头部信息
            if (self.gameType == GameTypeDlt) {
               //开奖期号
                firstView.issueLabel.text = [NSString stringWithFormat:@"%@第%@期开奖奖号", dp_GameTypeFirstName(self.gameType), self.dataBase.winIssue];
                if (self.dataBase.winRedsArray.count >= 5 && self.dataBase.winBluesArray.count >= 2)//当前开奖，则显示奖号
                {
                    firstView.winLabel.hidden = YES;
                    for (int i = 0; i < 7; i++) {
                        UILabel* label = (UILabel*)[firstView viewWithTag:100 + i];
                        label.hidden = NO;
                        label.text = (i > 4) ? [self.dataBase.winBluesArray objectAtIndex:i - 5] : [self.dataBase.winRedsArray objectAtIndex:i];
                    };
                }
                else //当前未开奖，则显示开奖时间
                {
                    firstView.winLabel.hidden = NO;
                    firstView.winLabel.text = [NSString stringWithFormat:@"%@开奖", [NSDate dp_coverDateString:self.dataBase.winDate fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm]];
                    for (int i = 0; i < 7; i++) {
                        UILabel* label = (UILabel*)[firstView viewWithTag:100 + i];
                        label.hidden = YES;
                    }
                }
            }
            return firstView;
        }
        //竞彩区头
        DPHeaderViewForJcTicket* sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        if (self.infoArray.count <= indexPath.section - 1) {
            return sectionView;
        }
        sectionView.delegate = self;
        PBMOrderDetailResult_JcItem* item = [self.infoArray objectAtIndex:indexPath.section - 1];
        //出票序号
        [sectionView orderNumberLabelText:item.orderNum];
        //玩法，倍数
        [sectionView titleLabelText:[NSString stringWithFormat:@"%@，%@，%d倍", item.gameName, item.gamePlay, item.multiple]];
        //金额
        [sectionView moneyLabelText:[NSString stringWithFormat:@"%d", item.money]];
        
        [sectionView showCopyTicket:item.orderNum.length>0?YES:NO];
        return sectionView;
    }
    //竞彩区尾
    DPFooterViewForJcTicket* sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterIdentifier forIndexPath:indexPath];
    if (self.infoArray.count <= indexPath.section - 1) {
        return sectionView;
    }
    PBMOrderDetailResult_JcItem* item = [self.infoArray objectAtIndex:indexPath.section - 1];
    UIFont* font = [UIFont systemFontOfSize:12.0];
    [sectionView winInfoText:[NSAttributedString attributedStringFromHTML:item.winDesc normalFont:font boldFont:font italicFont:font]];
    //是否中奖
    [sectionView isShowWinImageView:item.isWin];

    PBMOrderDetailResult_JcResult* infoItem = [item.jcResultsArray objectAtIndex:item.jcResultsArray.count - 1];
    //订单详情
    [sectionView infoLabelText:[self upDateAllDataForJcLottery:infoItem]];
    //标示  如周一001
    [sectionView rqLableText:infoItem.dateNum];
    if ([infoItem.rqs intValue] != 0) {
        NSString* title = @"让分";
        if (infoItem.gameType == GameTypeJcRqspf) {
            title = @"让球";
        }
        if (infoItem.gameType == GameTypeLcDxf) {
            title = @"总分";
            [sectionView infoLabelTitleText:[NSString stringWithFormat:@"%@    %@:%@", dp_GameTypeJCFullName(infoItem.gameType), title, infoItem.rqs]];
        }
        else {

            [sectionView infoLabelTitleText:[infoItem.rqs intValue] > 0 ? [NSString stringWithFormat:@"%@    %@:主+%@", dp_GameTypeJCFullName(infoItem.gameType), title, infoItem.rqs] : [NSString stringWithFormat:@"%@    %@:主%@", dp_GameTypeJCFullName(infoItem.gameType), title, infoItem.rqs]];
        }
    }
    else {
        [sectionView infoLabelTitleText:[NSString stringWithFormat:@"%@ ", dp_GameTypeJCFullName(infoItem.gameType)]];
    }
    return sectionView;
}
//获取大乐透投注内容
- (NSMutableAttributedString*)upDateAllDataForNumberLottery:(PBMOrderDetailResult_DltItem*)item
{
    NSDictionary* attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                 UIColorFromRGB(0x6f6248), NSForegroundColorAttributeName, nil];
    NSDictionary* attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                 UIColorFromRGB(0xa6a6a6), NSForegroundColorAttributeName, nil];

    NSMutableAttributedString* hinstring = [[NSMutableAttributedString alloc] initWithString:@""];
    if (item.dltDtResultsArray.count > 0) {
        for (int i = 0; i < item.dltDtResultsArray.count; i++) {
            if (i > 0) {
                [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            }

            PBMOrderDetailResult_DltDTResult* danItem = [item.dltDtResultsArray objectAtIndex:i];
            NSMutableAttributedString* redDanString = [self dltPartInfoForProject:danItem.redDansArray isRed:YES resultArray:self.dataBase.winRedsArray];
            NSMutableAttributedString* redTuoString = [self dltPartInfoForProject:danItem.redTuosArray isRed:YES resultArray:self.dataBase.winRedsArray];
            NSMutableAttributedString* blueDanString = [self dltPartInfoForProject:danItem.blueDansArray isRed:NO resultArray:self.dataBase.winBluesArray];
            NSMutableAttributedString* blueTuoString = [self dltPartInfoForProject:danItem.blueTuosArray isRed:NO resultArray:self.dataBase.winBluesArray];
            [hinstring appendAttributedString:redDanString];
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  #  " attributes:attributeDict1]];
            [hinstring appendAttributedString:redTuoString];
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  |  " attributes:attributeDict2]];
            if (danItem.blueDansArray.count > 0) {
                [hinstring appendAttributedString:blueDanString];
                [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  #  " attributes:attributeDict1]];
            }

            [hinstring appendAttributedString:blueTuoString];
        }
        return hinstring;
    }

    for (int i = 0; i < item.dltResultsArray.count; i++) {
        if (i > 0) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        }
        PBMOrderDetailResult_DltResult* normalItem = [item.dltResultsArray objectAtIndex:i];
        NSMutableAttributedString* redString = [self dltPartInfoForProject:normalItem.redsArray isRed:YES resultArray:self.dataBase.winRedsArray];
        NSMutableAttributedString* blueString = [self dltPartInfoForProject:normalItem.bluesArray isRed:NO resultArray:self.dataBase.winBluesArray];
        [hinstring appendAttributedString:redString];
        [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  |  " attributes:attributeDict2]];
        [hinstring appendAttributedString:blueString];
    }
    return hinstring;
}
//获取部分彩种的选中颜色
- (NSMutableAttributedString*)dltPartInfoForProject:(NSArray*)infoArray //投注内容（分前后）
                                              isRed:(BOOL)isRed //判断是否红球 YES:红前区  NO:后区
                                        resultArray:(NSArray*)resultArray //奖号
{

    NSMutableAttributedString* tempString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (int i = 0; i < infoArray.count; i++) {
        NSString* partString = [infoArray objectAtIndex:i];
        NSMutableAttributedString* singeString = [[NSMutableAttributedString alloc] initWithString:(i == 0) ? [NSString stringWithFormat:@"%@", partString] : [NSString stringWithFormat:@"  %@", partString]];
        if ([resultArray containsObject:partString]) {
            if (isRed) {
                [singeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xd2332f) range:NSMakeRange(0, singeString.length)];
            }
            else {
                [singeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0058c2) range:NSMakeRange(0, singeString.length)];
            }
        }
        else {
            [singeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x897d6f) range:NSMakeRange(0, singeString.length)];
        }
        [tempString appendAttributedString:singeString];
    }
    return tempString;
}

//获取竞彩投注内容
- (NSMutableAttributedString*)upDateAllDataForJcLottery:(PBMOrderDetailResult_JcResult*)item
{
    NSDictionary* attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                 UIColorFromRGB(0xdd514f), NSForegroundColorAttributeName,
                                                 nil]; //中奖
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
        [infoString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:JcResultItem.result attributes:JcResultItem.isWin ? attributeDict1 : attributeDict2]];
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
                [collect registerClass:[DPTicketCell class] forCellWithReuseIdentifier:kCellIdentifier];
            }
            else {
                [collect registerClass:[DPJcTicketCell class] forCellWithReuseIdentifier:kCellIdentifier];
            }
            [collect registerClass:[DPHeaderViewForJcTicket class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
            [collect registerClass:[DPFooterViewForJcTicket class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterIdentifier];
            [collect registerClass:[DPHeaderViewForFirstView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFirstHeaderIdentifier];

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

#pragma DPTicketCellDelegate
//点击去查询票样
- (void)copyTicketSearchForTicketCell:(NSString*)ticketText
{
    UIPasteboard* pboard = [UIPasteboard generalPasteboard];
    pboard.string = ticketText;
    DPWebViewController* controller = [[DPWebViewController alloc] init];
    controller.title = @"票号查询";
    controller.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://ticket.lottery.gov.cn"]];
    [self.navigationController pushViewController:controller animated:YES];
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
