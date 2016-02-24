//
//  DPLiveCompetitionViews.m
//  Jackpot
//
//  Created by wufan on 15/9/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLiveCompetitionViews.h"


@interface DPLiveCompetitionLiveContentView () {
@private
    NSInteger _rowCount;
}
@end

@implementation DPLiveCompetitionLiveContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayout];
        
    }
    return self;
}

-(void)buildLayout{
    UIImageView *homeView = [[UIImageView alloc] initWithImage:dp_SportLiveResizeImage(@"live_home.png")];
    UIImageView *awayView = [[UIImageView alloc] initWithImage:dp_SportLiveResizeImage(@"live_away.png")];
    
    DPImageLabel *timeLabel = [[DPImageLabel alloc] init];
    timeLabel.image = dp_SportLiveImage(@"live_time.png");
    timeLabel.textColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
    timeLabel.font = [UIFont dp_regularArialOfSize:10];
    
    DPImageLabel *homeLabel = [[DPImageLabel alloc] init];
    homeLabel.imagePosition = DPImagePositionLeft;
    homeLabel.textColor = [UIColor colorWithRed:0.56 green:0.49 blue:0.31 alpha:1];
    homeLabel.font = [UIFont dp_systemFontOfSize:12];
    DPImageLabel *awayLabel = [[DPImageLabel alloc] init];
    awayLabel.imagePosition = DPImagePositionLeft;
    awayLabel.textColor = [UIColor colorWithRed:0.56 green:0.49 blue:0.31 alpha:1];
    awayLabel.font = [UIFont dp_systemFontOfSize:12];
    
    timeLabel.frame = CGRectMake(kScreenWidth / 2 - 11 - 5, 0, 21.5, 31.5);
    homeView.frame = CGRectMake(timeLabel.dp_minX - 135, timeLabel.dp_midY - 11.5, 130, 22.5);
    awayView.frame = CGRectMake(timeLabel.dp_maxX + 5, timeLabel.dp_midY - 11.5, 130, 22.5);
    
    [self addSubview:timeLabel];
    [self addSubview:homeView];
    [self addSubview:awayView];
    [homeView addSubview:homeLabel];
    [awayView addSubview:awayLabel];
    
    [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(homeView).offset(10);
        make.centerY.equalTo(homeView);
    }];
    [awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(awayView);
        make.left.equalTo(awayView).offset(10);
    }];
    
    
    _homeLabel = homeLabel;
    _awayLabel = awayLabel;
    _timeLabel = timeLabel;
    
}


@end


@implementation DPLiveCompetitionLiveContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        
        
        UIView *rightLine = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.8 alpha:1];
            view;
        });
        
        UIView *leftLine = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.8 alpha:1];
            view;
        });
        [self.contentView addSubview:rightLine];
        [self.contentView addSubview:leftLine];
        
        
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView) ;
            make.width.equalTo(@0.5) ;
        }];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView) ;
            make.width.equalTo(@0.5) ;
        }];
        
        
        DPLiveCompetitionLiveContentView *liveView = [[DPLiveCompetitionLiveContentView alloc] initWithFrame:CGRectMake(5, 30, 310, 200)];
        liveView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:liveView];
        [liveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)).priorityLow();
        }];
        
        UIView *bottomLab = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.8 alpha:1];
            view;
        });
        
        _liveView = liveView;
        [self.contentView addSubview:bottomLab];
        [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView) ;
            make.left.equalTo(self.contentView).offset(5);
            make.height.equalTo(@0.5) ;
        }];
        
        _bottomView = bottomLab ;
        
        
    }
    return self;
}


@end


#pragma mark- 评论列表Cell
@interface DPCommentTableCell ()

@property(nonatomic,strong,readonly)UILabel *commentLabel ; //评论详情
@property(nonatomic,strong,readonly)DPImageLabel *timeLabel ; //时间




@end

@implementation DPCommentTableCell
@synthesize imageIcon = _imageIcon ,agreeButton = _agreeButton ,nameLabel =_nameLabel ,timeLabel = _timeLabel ,commentLabel = _commentLabel,detailButton = _detailButton ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self buileCommentUI];
        
    }
    return self;
}
-(void)buileCommentUI{
    
    UIView *contentView = self.contentView ;
    
    
    [contentView addSubview:self.imageIcon];
    [contentView addSubview:self.nameLabel];
    [contentView addSubview:self.agreeButton];
    [contentView addSubview:self.timeLabel];
    [contentView addSubview:self.commentLabel];
    [contentView addSubview:self.detailButton];
    
    
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15) ;
        make.top.equalTo(contentView).offset(10) ;
        make.width.equalTo(@40) ;
        make.height.equalTo(@40) ;
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageIcon.mas_right).offset(10) ;
        make.top.equalTo(contentView).offset(10) ;
        make.height.equalTo(@20) ;
    }];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-15) ;
        make.top.equalTo(contentView).offset(10) ;
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5) ;
        make.left.equalTo(self.nameLabel) ;
        make.height.equalTo(@10) ;
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel) ;
        make.top.equalTo(self.timeLabel.mas_bottom).offset(4) ;
        make.right.equalTo(contentView).offset(-10) ;
     }];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom) ;
         make.left.equalTo(self.nameLabel) ;
        make.height.equalTo(@15) ;
     }];
    
    UIView *lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xc8c7c2)] ;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.and.left.equalTo(self.contentView) ;
        make.height.equalTo(@0.5) ;
    }];
    
    
}


#pragma mark- 响应事件

-(void)pvt_agree:(DPAgreeControl*)sender{
    
    DPLog(@"点赞") ;
    
    if (sender.selected) {
        [[DPToast makeText:@"你已经点过赞了"]show];
        
        return  ;
    }
    
    sender.selected = !sender.selected ;
    DPControlSelectStatus model = sender.selected?SelectStatusYES:SelectStatusNO ;
    [sender setFlag:model ];
    if (self.supportClick) {
        self.supportClick(self) ;
    }
}

-(void)pvt_detail:(UIButton*)sender{
    
    DPLog(@"查看详情") ;
    sender.selected= !sender.selected ;
    if (self.showDetail) {
        self.showDetail(self) ;
    }
    
}

#pragma mark- setter/getter

-(void)setCommentString:(NSString *)commentString{
    
    _commentString = commentString ;
    
     if(commentString.length>60){
        self.detailButton.hidden = NO ;
    }else{
        self.detailButton.hidden = YES ;
     }
    
    if (!self.detailButton.selected && commentString.length>60 ) {
        
        _commentString = [_commentString substringToIndex:60] ;
        
        _commentString  = [_commentString stringByAppendingString:@"..."] ;
    }
    
    
    self.commentLabel.text = _commentString ;
    
    
}

-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString ;
    
    self.timeLabel.text =[NSString stringWithFormat:@" %@",timeString] ;
 
}


-(UIImageView*)imageIcon{
    
    if (_imageIcon == nil) {
        _imageIcon = [[UIImageView alloc]init];
        _imageIcon.backgroundColor = [UIColor clearColor] ;
        
    }
    return _imageIcon ;
}

-(DPAgreeControl*)agreeButton
{
    
    if (_agreeButton == nil) {
        _agreeButton = [[DPAgreeControl alloc]init] ;
        _agreeButton.backgroundColor = [UIColor clearColor] ;
        [_agreeButton setNormalStateImg:dp_SportLiveImage(@"agree_normal.png") ];
        [_agreeButton setSelectedStateImg:dp_SportLiveImage(@"agree_select.png") ];
        _agreeButton.title = @"3" ;
        [_agreeButton addTarget:self action:@selector(pvt_agree:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton ;
}

-(UILabel*)nameLabel{
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor =[UIColor clearColor] ;
        _nameLabel.text = @"香港粉雪" ;
        _nameLabel.font = [UIFont dp_systemFontOfSize:15] ;
        _nameLabel.textColor = UIColorFromRGB(0x85847F) ;
        
    }
    
    return _nameLabel ;
}


-(DPImageLabel*)timeLabel{
    
    if (_timeLabel == nil) {
        _timeLabel = [[DPImageLabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor] ;
        _timeLabel.imagePosition =DPImagePositionLeft ;
        _timeLabel.image = dp_SportLiveImage(@"clock.png") ;
        _timeLabel.text = @" 刚刚";
        _timeLabel.font = [UIFont dp_systemFontOfSize:13] ;
        _timeLabel.textColor = UIColorFromRGB(0xa2a19c) ;
    }
    return _timeLabel ;
}

-(UILabel*)commentLabel{
    
    
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc]init];
        _commentLabel.backgroundColor = [UIColor clearColor] ;
        _commentLabel.textColor = [UIColor dp_flatBlackColor] ;
        _commentLabel.textAlignment = NSTextAlignmentLeft ;
        _commentLabel.lineBreakMode = NSLineBreakByTruncatingTail ;
        _commentLabel.text = @"这是一场精彩的表演" ;
        _commentLabel.font = [UIFont dp_systemFontOfSize:13] ;
        _commentLabel.numberOfLines = 0 ;
    }
    
    return _commentLabel ;
}

-(UIButton*)detailButton{
    
    if (_detailButton == nil) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _detailButton.backgroundColor = [UIColor clearColor] ;
        [_detailButton setTitleColor:UIColorFromRGB(0x4889D0) forState:UIControlStateNormal];
        [_detailButton setTitle:@"全文∧" forState:UIControlStateNormal];
        [_detailButton setTitle:@"全文∨" forState:UIControlStateSelected];
        
        _detailButton.titleLabel.font = [UIFont dp_systemFontOfSize:13] ;
        [_detailButton addTarget:self action:@selector(pvt_detail:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton ;
}

@end






@interface DPAgreeControl()

@property (nonatomic, strong,readonly) UIImageView*defaultStateImgV;
@property (nonatomic, strong,readonly) UILabel *textLabel;


@end

@implementation DPAgreeControl
@synthesize textLabel = _textLabel,defaultStateImgV = _defaultStateImgV ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.defaultStateImgV] ;
        [self addSubview:self.textLabel];
        self.translatesAutoresizingMaskIntoConstraints = NO ;
        self.clipsToBounds = NO ;
        [self.defaultStateImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self) ;
            make.bottom.equalTo(self) ;
            make.right.equalTo(self.mas_centerX).offset(-1.5) ;
            
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(1.5) ;
            make.centerY.equalTo(self) ;
        }];
    }
    return self;
}
-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    self.defaultStateImgV.highlighted = selected ;
}


-(UILabel*)textLabel{
    
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor =UIColorFromRGB(0x81807b) ;
        _textLabel.font = [UIFont dp_systemFontOfSize:13] ;
        _textLabel.textAlignment = NSTextAlignmentLeft ;
        _textLabel.backgroundColor = [UIColor clearColor] ;
    }
    return _textLabel ;
}
-(UIImageView*)defaultStateImgV{
    
    if (_defaultStateImgV == nil)
    {
        _defaultStateImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        _defaultStateImgV.contentMode = UIViewContentModeCenter;
        
    }
    
    return _defaultStateImgV ;
    
}

-(void)setTitle:(NSString *)title{
    self.textLabel.text = title ;
}


-(void)setNormalStateImg:(UIImage *)normalStateImg
{
    self.defaultStateImgV.image =  normalStateImg ;
}

-(void)setSelectedStateImg:(UIImage *)selectedStateImg{
    self.defaultStateImgV.highlightedImage = selectedStateImg ;
}


- (void)setFlag:(DPControlSelectStatus)flag
{
    
    
            //no-->yes
        if (_lastFlag == SelectStatusNO && flag == SelectStatusYES)
        {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"] ;
            animation.fromValue=[NSNumber numberWithFloat:1.0];
             animation.toValue=[NSNumber numberWithFloat:2.0];;
            animation.duration=0.3;
            animation.autoreverses=YES;
            animation.repeatCount=1;
            animation.removedOnCompletion=NO;
            animation.fillMode=kCAFillModeForwards;
            [self.defaultStateImgV.layer addAnimation:animation forKey:@"transform"];
            
            
        }
        //yes-->no
        else if(_lastFlag == SelectStatusYES && flag == SelectStatusNO)
        {
            self.defaultStateImgV.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.defaultStateImgV.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
                
            } completion:^(BOOL finished)
             {
                 self.defaultStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
             }];
        }
        
    
    _lastFlag = flag;
}


@end


