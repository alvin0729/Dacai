//
//  DPLiveOddsPositionDetailVC.m
//  DacaiProject
//
//  Created by Ray on 14/12/16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveOddsPositionDetailVC.h"
#import "DPLiveDataCenterViews.h"
#import "BasketballDataCenter.pbobjc.h"

@interface DPLiveOddsPositionDetailVC () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    UITableView *_infoTableView;
    UIButton *_nameButton;
    PBMOddsHandicapDetail *_dateCenter;
    int _index;    //赔盘类型
    int _companyIdx;
    GameTypeId _gametype;
    int _rowNumber;    //详情行数
    NSInteger _matchId;
     NSMutableDictionary *_baseCenter;
}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UITableView *infoTableView;
@property (nonatomic, strong, readonly) UIButton *nameButton;
@property (nonatomic, strong) MTStringParser *stringParser;
@end

@implementation DPLiveOddsPositionDetailVC

- (instancetype)initWIthGameType:(GameTypeId)gameType withSelectIndex:(int)index companyIndx:(int)companyIndx withMatchId:(NSInteger)matchid
{
    self = [super init];
    if (self) {
        _index = index ;
        _companyIdx = companyIndx ;
        _gametype = gameType ;
        _matchId = matchid ;
        
         if (gameType == GameTypeLcNone) {
          }else{
         }

    }
    return self;
}

-(void)dealloc{
    [_baseCenter removeAllObjects];
    _baseCenter = nil ;
}

-(void)getNetDataWithCompanyId:(int)companyId {
    
    
    NSString *company = ((PBMCompanyItem*)[self.companyNames objectAtIndex:companyId]).companyId ;
    
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"datacenter/%@",_gametype == GameTypeJcNone?@"GetFootballOddDetail":@"GetBasketballOddDetail"] parameters:@{@"corpid":company,@"code":@(_index),@"matchid":@(_matchId)} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        DPLog(@"数据到达！！！！") ;
        
        
        _dateCenter = [PBMOddsHandicapDetail parseFromData:responseObject error:nil];
        
        [_baseCenter setObject:_dateCenter forKey:[NSString stringWithFormat:@"info%d",companyId]];
        [_nameButton setTitle: ((PBMCompanyItem*)self.companyNames[companyId]).companyName forState:UIControlStateNormal];
        _rowNumber = (int)_dateCenter.oddsListArray.count ;
        
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:companyId inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self.infoTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self dismissHUD];
        DPLog(@"%@",error) ;
    }];

    
}

-(void)viewDidLoad{
    
    [super viewDidLoad] ;
    
    
    _baseCenter = [[NSMutableDictionary alloc]initWithCapacity:self.companyNames.count];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    if(_gametype == GameTypeLcNone){
        switch (_index) {
            case 1:
                self.title = @"胜负指数";
                break;
            case 2:
                self.title = @"让分指数" ;
                break ;
            case 3:
                self.title = @"大小指数";
                break ;
            default:
                break;
        }
    
    }else{
        switch (_index) {
            case 1:
                self.title = @"欧赔指数";
                break;
            case 2:
                self.title = @"亚盘指数" ;
                break ;
            case 3:
                self.title = @"大小球指数";
                break ;
            default:
                break;
        }

    
    }
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nameButton];
    [self.view addSubview:self.infoTableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view) ;
        make.left.equalTo(self.view) ;
        make.width.mas_equalTo(80*(kScreenWidth/320.0)) ;
        make.bottom.equalTo(self.view) ;
    }] ;
    
    [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view) ;
        make.left.equalTo(self.tableView.mas_right).offset(5) ;
        make.right.equalTo(self.view).offset(-5) ;
        make.height.equalTo(@30) ;
    }] ;
    
    [ self.infoTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameButton.mas_bottom) ;
        make.left.equalTo(self.tableView.mas_right).offset(5) ;
        make.right.equalTo(self.view).offset(-5) ;
        make.bottom.equalTo(self.view) ;
    }] ;
    
    _rowNumber = 0 ;
    [self showHUD] ;
    
    [self getNetDataWithCompanyId:_companyIdx];
}

- (UITableView *)infoTableView {
    if (_infoTableView == nil) {
        _infoTableView = [[UITableView alloc] init];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.rowHeight = 30 ;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        _infoTableView.showsVerticalScrollIndicator = NO ;
        _infoTableView.backgroundColor = [UIColor clearColor ] ;
        _infoTableView.bounces = NO ;
    }
    
    return _infoTableView;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 30 ;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO ;
        _tableView.bounces = NO ;
        
    }
    
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.companyNames.count;
    } else {
        if (_rowNumber <= 0) {
            return 1;
        }
        return _rowNumber;
    }
    return 0;
}

#define DetailTag 12345
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString* ReusableCell = @"ReusableCell" ;
        OddsPositionDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:ReusableCell] ;
        if (cell == nil) {
            cell = [[OddsPositionDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableCell];
        }
        
        
        cell.nameLabel.text  = [NSString stringWithFormat:@"%@",((PBMCompanyItem*)self.companyNames[indexPath.row]).companyName]  ;//@"威廉希尔" ;
        return cell ;
    }else if(tableView == self.infoTableView){
        
  
        static NSString* ReusableInfoCell = @"ReusableInfoCell" ;
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ReusableInfoCell] ;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReusableInfoCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:30 withWidth:230*(kScreenWidth/320.0)];
            headView.titleFont = [UIFont dp_systemFontOfSize:11] ;
            headView.numberOfLabLines = 2 ;
            
            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil] ;
            
            if (_gametype == GameTypeLcNone && _index == 1) {
                arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:84], nil];
            }
            
            [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
            
            headView.tag = DetailTag+1 ;
            [cell.contentView addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView) ;
                make.left.equalTo(cell.contentView) ;
                make.height.equalTo(@30);
                make.right.equalTo(cell.contentView);
            }];
            UIImageView*  _noDataImgLabel  = [[UIImageView alloc]init];
            _noDataImgLabel.tag = DetailTag+2 ;
            _noDataImgLabel.contentMode = UIViewContentModeCenter ;
            _noDataImgLabel.hidden = YES ;
             if (_gametype == GameTypeLcNone) {
                _noDataImgLabel.image = dp_SportLiveImage(@"basket_down.png") ;
                
            }else
                _noDataImgLabel.image = dp_SportLiveImage(@"foot_down.png") ;
             _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsZero) ;
            }] ;

             
        }
        
        DPImageLabel*noDataImg = (DPImageLabel*)[cell.contentView viewWithTag:DetailTag+2] ;
        if (_rowNumber<=0) {
            noDataImg.hidden = NO ;
            return cell ;
        }else
            noDataImg.hidden = YES ;
        
        
        PBMOddsHandicapDetail_OddsCapDetailInfo *detailInfo = [_dateCenter.oddsListArray objectAtIndex:indexPath.row];
        DPLiveOddsHeaderView* cellView = (DPLiveOddsHeaderView*)[cell.contentView viewWithTag:DetailTag+1] ;
        
        NSMutableArray *titleArr = [[NSMutableArray alloc]init];
        NSAttributedString *firstStr, *secondStr, *thirdStr;
        NSAttributedString *__strong *strList[] = {&firstStr, &secondStr, &thirdStr};
        for (int i = 0; i < ((_gametype == GameTypeLcNone&&_index == 1)?2:3) ; i++) {
            NSString *markupText;
            if ([detailInfo.trendsArray valueAtIndex:i] > 0) {
                markupText = [NSString stringWithFormat:@"<red>%@↑</red>", detailInfo.oddsArray[i]];
            } else if ([detailInfo.trendsArray valueAtIndex:i]  < 0) {
                markupText = [NSString stringWithFormat:@"<blue>%@↓</blue>", detailInfo.oddsArray[i]];
            } else {
                markupText = [NSString stringWithFormat:@"<black>%@</black>", detailInfo.oddsArray[i]];
            }
            NSAttributedString *attr = [self.stringParser attributedStringFromMarkup:markupText];
            *strList[i] = attr;
            
            [titleArr addObject:*strList[i]] ;
        }

        [titleArr addObject:[self.stringParser attributedStringFromMarkup:[NSString stringWithFormat:@"<init>%@</init>", detailInfo.updateTime]]];
        [cellView setTitles:titleArr];

//        [cellView setTitles:[NSArray arrayWithObjects:firstStr, secondStr, thirdStr, detailInfo.updateTime, nil]];

        if (indexPath.row % 2 == 0) {
            cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff];
        } else {
            cellView.backgroundColor = UIColorFromRGB(0xfaf9f2);
        }

        return cell ;
        
        
    }
    
    return nil ;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.infoTableView) {
        if (_rowNumber<=0) {
            return 150 ;
        }
    }
    
    return 30 ;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (tableView == self.tableView) {
        
        static NSString *HeaderReuse = @"HeaderReuse";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderReuse];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderReuse];
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor dp_flatWhiteColor] ;
                view;
            });
            
            UILabel* label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor] ;
            label.font = [UIFont dp_systemFontOfSize:14] ;
            label.textAlignment = NSTextAlignmentCenter ;
            label.textColor = UIColorFromRGB(0xA5A3A2) ;
            label.text = @"公司名" ;
            
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view) ;
            }];
            
            UIView *lineView = ({
                UIView* view = [[UIView alloc]init] ;
                view.backgroundColor = UIColorFromRGB(0xDAD3C7) ;
                view ;
            });
            [view addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view) ;
                make.right.equalTo(view) ;
                make.bottom.equalTo(view) ;
                make.height.equalTo(@0.5) ;
            }];
            
            
            UIImageView * rightView = ({
                UIImageView* rview = [[UIImageView alloc]initWithImage:dp_SportLiveImage(@"live_normal.png")] ;
                rview.backgroundColor = [UIColor clearColor] ;
                rview ;
            }) ;
            
            [view addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view) ;
                make.right.equalTo(view) ;
                make.bottom.equalTo(view) ;
            }];
        }
        
        return view ;
    }else if (tableView == self.infoTableView) {
        
        static NSString *HeaderInfoReuse = @"HeaderInfoReuse";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderInfoReuse];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderInfoReuse];
          
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor dp_flatWhiteColor] ;
                view;
            });
        
            DPLiveOddsHeaderView* headView = [[DPLiveOddsHeaderView alloc]init];
            headView.textColors = UIColorFromRGB(0x7E7D7B) ;
            NSArray* titles ; // = [NSArray arrayWithObjects:@"胜",@"平",@"负",@"更新时间", nil];
            NSArray* widths ;//= [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil];

            if(_gametype == GameTypeLcNone){
                
                if (_index == 1) {
                    titles = [NSArray arrayWithObjects:@"主负",@"主胜",@"更新时间", nil];
                    widths = [NSArray arrayWithObjects:[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:73],[NSNumber numberWithFloat:84], nil];
                }else if (_index == 2) {
                    titles = [NSArray arrayWithObjects:@"客水",@"盘口",@"主水",@"更新时间", nil];
                     widths = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil];

                } else{
                    
                    titles = [NSArray arrayWithObjects:@"小分",@"总分",@"大分",@"更新时间", nil];
                     widths = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil];
                    
                }
                
                
            }else{
                
                
                if (_index == 1) {
                    titles = [NSArray arrayWithObjects:@"胜",@"平",@"负",@"更新时间", nil];
                    
                }else if(_index == 2){
                    
                    titles = [NSArray arrayWithObjects:@"主水",@"盘口",@"客水",@"更新时间", nil];
                    
                }else{
                    titles = [NSArray arrayWithObjects:@"大球",@"即时",@"小球",@"更新时间", nil];
                    
                }
                
                widths = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:51],[NSNumber numberWithFloat:77], nil];
                
            }
          
            
            [headView createHeaderWithWidthArray:widths whithHigh:30 withSeg:YES];
            [headView setTitles:titles];
            [view.contentView addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view.contentView) ;
                make.left.equalTo(view.contentView) ;
                make.width.mas_equalTo(230*(kScreenWidth/320.0)) ;
                make.height.equalTo(@30) ;
            }];
        }
        
        return view ;
        
    }
    
    
    return nil ;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.tableView) {
        _companyIdx =(int)indexPath.row;
        
        [_nameButton setTitle: ((PBMCompanyItem*)self.companyNames[indexPath.row]).companyName forState:UIControlStateNormal];
        
        int count=0 ;
        _dateCenter = (PBMOddsHandicapDetail*)[_baseCenter valueForKey:[NSString stringWithFormat:@"info%d",_companyIdx]] ;
        
        count = (int)_dateCenter.oddsListArray.count ;
        if (count<=0) {
            [self showHUD];
            [self getNetDataWithCompanyId:_companyIdx];
        }else
        {
            _rowNumber = (int)_dateCenter.oddsListArray.count ;
            [self.infoTableView reloadData];
        }
        
        
    }
}

-(UIButton*)nameButton{
    
    if (_nameButton == nil) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _nameButton.backgroundColor = [UIColor clearColor] ;
        _nameButton.titleLabel.font = [UIFont dp_systemFontOfSize:15] ;
        [_nameButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal] ;
        [_nameButton setTitle:@" 公司名" forState:UIControlStateNormal];
        _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
        [_nameButton setImage:dp_SportLiveImage(@"live_spot.png") forState:UIControlStateNormal];
    }
    
    return _nameButton ;
}

 
- (MTStringParser *)stringParser {
    if (_stringParser == nil) {
        _stringParser = [[MTStringParser alloc] init];
        [_stringParser setDefaultAttributes:({
            MTStringAttributes *attr = [[MTStringAttributes alloc] init];
            attr.alignment = NSTextAlignmentCenter;
            attr;
        })];
        [_stringParser addStyleWithTagName:@"init" font:[UIFont dp_systemFontOfSize:11] color:UIColorFromRGB(0x999999)];
        [_stringParser addStyleWithTagName:@"red" font:[UIFont dp_systemFontOfSize:11] color:UIColorFromRGB(0xdc2804)];
        [_stringParser addStyleWithTagName:@"black" font:[UIFont dp_systemFontOfSize:11] color:UIColorFromRGB(0x2f2f2f)];
        [_stringParser addStyleWithTagName:@"blue" font:[UIFont dp_systemFontOfSize:11] color:UIColorFromRGB(0x3456a4)];
    }
    return _stringParser;
}

@end


@implementation OddsPositionDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectedBackgroundView = ({
            UIView* view = [[UIView alloc]init];
            view.backgroundColor = [UIColor clearColor] ;
            view ;
        }) ;
        
        
        [self buildUI];
        
    }
    return self;
}

-(void)buildUI{
    UIView* contentView = self.contentView ;
    
    UIImageView *lineView = ({
        UIImageView* view = [[UIImageView alloc]initWithImage:[UIImage dp_imageWithColor:UIColorFromRGB(0xDAD3C7)]  highlightedImage:[UIImage dp_imageWithColor:UIColorFromRGB(0xDAD3C7)]] ;
        view.backgroundColor = [UIColor clearColor] ;
        view ;
    });
    
    
    UIImageView * rightView = ({
        UIImageView* view = [[UIImageView alloc]initWithImage:dp_SportLiveImage(@"live_normal.png")  highlightedImage:dp_SportLiveImage(@"live_oddsSelected.png")] ;
        view.backgroundColor = [UIColor clearColor] ;
        view ;
    }) ;
    
    
    [contentView addSubview:lineView];
    [contentView addSubview:self.nameLabel];
    [contentView addSubview:rightView];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView) ;
        make.top.equalTo(contentView) ;
        make.right.equalTo(contentView).offset(-7) ;
        make.bottom.equalTo(contentView).offset(-0.5) ;
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView) ;
        make.top.equalTo(self.nameLabel.mas_bottom) ;
        make.right.equalTo(contentView).offset(-1) ;
        make.bottom.equalTo(contentView) ;
        
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView) ;
        make.top.equalTo(contentView) ;
        make.bottom.equalTo(contentView) ;
        make.width.equalTo(@7) ;
    }];
    
}

-(UILabel*)nameLabel{
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentCenter ;
        _nameLabel.font = [UIFont dp_systemFontOfSize:11] ;
        _nameLabel.highlightedTextColor = [UIColor dp_flatRedColor] ;
        _nameLabel.textColor = UIColorFromRGB(0x535353);
        _nameLabel.userInteractionEnabled = YES ;
    }
    
    return _nameLabel ;
}



@end

