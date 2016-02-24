//
//  DPShareChartletViewController.m
//  DacaiProject
//
//  Created by wufan on 15/4/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPShareChartletViewController.h"
#import "AFImageDiskCache.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "DPShareView.h"
#import "UMSocial.h"
#import "DPThirdCallCenter.h"
#define TAG_VIEW_TAG    1000

@interface DPShareChartletViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,KTMKeyboardObserver,DPShareViewDelegate,UMSocialUIDelegate> {
     UIImageView *_textBgView;
    UITextView *_textView;
    
    NSArray *_titleArray ;
    UIImage *_shareImage ;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UIImageView *screenView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *middleGroundView;


@property (nonatomic, strong,readonly) UIImageView *textBgView;
@property (nonatomic, strong,readonly) UITextView *textView;

@property (nonatomic, strong) UIImageView *figureView;
@property (nonatomic, strong) UITextField *figureField;

@property (nonatomic, strong) NSArray *figureImageArray;
@property (nonatomic, strong) NSArray *figureViewArray;


@property (nonatomic, strong, readonly) AFImageDiskCache *imageCache;
@property (nonatomic, strong, readonly) NSOperationQueue *imageQueue;
@property (nonatomic, strong) NSLayoutConstraint *textConstraint;




#define kShotWidth 238

@end

@implementation DPShareChartletViewController
@synthesize textView = _textView ;
@synthesize textBgView = _textBgView ;
@synthesize textConstraint = _textConstraint ;


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)setupViews {
    self.scrollView = [[UIScrollView alloc] init];
    self.bottomView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"shareBar_bg.jpg")];
    self.screenView = [[UIImageView alloc] init];
    self.screenView.userInteractionEnabled = YES ;
    self.backgroundView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"share_bg.png")];
    self.backgroundView.userInteractionEnabled = YES ;
    self.figureView = [[UIImageView alloc] init];
    self.figureField = [[UITextField alloc] init];

    self.screenView.image = self.screenshotImage;
    self.screenView.backgroundColor = [UIColor clearColor] ;
    
    // 初始化底部4个人物
    self.figureImageArray =  @[ dp_AccountImage(@"shareBar_01.png"),dp_AccountImage(@"shareBar_02.png"),dp_AccountImage(@"shareBar_03.png"),dp_AccountImage(@"shareBar_04.png") ];

    self.figureViewArray = @[ [self figureView:dp_AccountImage(@"shareBar_01.png") selected:NO],
                              [self figureView:dp_AccountImage(@"shareBar_02.png") selected:NO],
                              [self figureView:dp_AccountImage(@"shareBar_03.png") selected:NO],
                              [self figureView:dp_AccountImage(@"shareBar_04.png") selected:YES] ];
    
    
    self.figureView.image = dp_AccountImage(@"shareBar_04.png");
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.figureView.backgroundColor = [UIColor clearColor] ;
    self.bottomView.backgroundColor = [UIColor clearColor];
    
    _titleArray = [NSArray arrayWithObjects:@"随手一注，就中奖啦！",@"笑着把钱赚",@"一看即会、一玩即中",@"有钱，任性", nil] ;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[KTMKeyboardManager defaultManager] addObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[DPToast sharedToast]dismiss];
    [[KTMKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"分享";
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(btnOnShare)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"下一步" target:self action:@selector(btnOnShare)];

    _imageCache = [[AFImageDiskCache alloc] init];
    _imageQueue = [[NSOperationQueue alloc] init];
    _imageQueue.maxConcurrentOperationCount = 1;

    
    
    [self setupViews];
    self.scrollView.backgroundColor = [UIColor dp_flatWhiteColor] ;
    self.scrollView.delegate = self ;

    
    // 向view上添加滚动视图和底部背景
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.right.with.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-70);
    }];
       // 在滚动视图上添加背景和截图
    

    [self.scrollView addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.right.equalTo(self.scrollView);
        make.top.with.bottom.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    
//    [self.backgroundView addSubview:self.middleGroundView];
//    [self.middleGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(60, 40, 55, 40)) ;
//    }];
//    
    [self.scrollView addSubview:self.middleGroundView];
    [self.middleGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(60, 40, 55, 40)) ;
        make.top.equalTo(self.backgroundView).offset(60) ;
        make.left.equalTo(self.backgroundView).offset(40) ;
        make.bottom.equalTo(self.backgroundView).offset(-53) ;
        make.right.equalTo(self.backgroundView).offset(-40) ;
    }];
    

    [self.middleGroundView addSubview:self.screenView];
    self.middleGroundView.clipsToBounds = YES ;
    
    
    [self.screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(60);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(kShotWidth)) ;
        make.height.equalTo(@(self.screenshotImage.size.height*kShotWidth/kScreenWidth)) ;
    }];
//
    //中间文字部分
    [self createMiddleTextView];
    
    [self.scrollView bringSubviewToFront:self.backgroundView];
    [self createBottomView];
    
    // 手势, 接受底部人物人物点击事件和取消编辑
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap:)] ;
    tap.delegate =self ;
    [self.view addGestureRecognizer:tap];
    
    // TODO:
//    [self dpn_bindId:_lotteryCommon->Net_PullShareImageURL() type:PULL_SHARE_BGIMAGE] ;
    
    
}

- (UIImageView *)figureView:(UIImage *)image selected:(BOOL)selected {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.layer.borderWidth = 1;
//    imageView.layer.borderColor = [UIColor colorWithRed:1 green:0.46 blue:0.46 alpha:1].CGColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit ;
    UIImageView *tagView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"share_suc.png")];
    [tagView setTag:TAG_VIEW_TAG];
    [tagView setBackgroundColor:[UIColor clearColor]];
    tagView.hidden = !selected ;
    [imageView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.bottom.equalTo(imageView).offset(-5);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(20, 20)]);
    }];
    return imageView;
}
#pragma mark-中间文字和人物
-(void)createMiddleTextView{

    [self.middleGroundView addSubview:self.textBgView];
    
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.middleGroundView);
        make.bottom.equalTo(self.middleGroundView);
        make.right.equalTo(self.middleGroundView);
    }];
    
    
    // 图片上的人物+文字
    [self.textBgView addSubview:self.figureView];
    [self.figureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textBgView);
        make.left.equalTo(self.textBgView);
        make.width.equalTo(@80);
        make.height.equalTo(@110);
    }];
    
    
    [self.backgroundView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView).offset(120) ;
        make.bottom.equalTo(self.backgroundView).offset(-55); ;
        make.right.equalTo(self.backgroundView).offset(-40) ;
        make.height.equalTo(@(50)) ;
    }];
    

    
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.figureView.mas_right) ;
//        make.bottom.equalTo(self.textBgView) ;
//        make.right.equalTo(self.textBgView) ;
//        make.height.equalTo(@(50)) ;
//    }];
//    
    
}

#pragma mark- 底部
-(void)createBottomView{
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.right.with.bottom.equalTo(self.view);
        make.height.equalTo(@70);
    }];
    
    
    
    // 底部4个人物
    UIView *figureView1 = self.figureViewArray[0];
    UIView *figureView2 = self.figureViewArray[1];
    UIView *figureView3 = self.figureViewArray[2];
    UIView *figureView4 = self.figureViewArray[3];
    
    [self.bottomView addSubview:figureView1];
    [self.bottomView addSubview:figureView2];
    [self.bottomView addSubview:figureView3];
    [self.bottomView addSubview:figureView4];
    
    
    [figureView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@70);
        make.left.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView);
    }];
    [figureView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@70);
        make.left.equalTo(figureView1.mas_right);
        make.bottom.equalTo(self.bottomView);
    }];
    [figureView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@70);
        make.left.equalTo(figureView2.mas_right);
        make.bottom.equalTo(self.bottomView);
    }];
    [figureView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@70);
        make.left.equalTo(figureView3.mas_right);
        make.right.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView);
    }];

}

-(void)btnOnShare{
    [self.textView resignFirstResponder];
    
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
}

- (void)pvt_onTap:(UITapGestureRecognizer *)tapRecognizer {
    
    [self.textView resignFirstResponder];
     for (int i = 0; i < 4; i++) {
        UIView *view = self.figureViewArray[i];

        CGPoint p = [tapRecognizer locationInView:view];
        if (CGRectContainsPoint(view.bounds, p)) {  // 判断是否在区域内
            
            for (int j = 0; j < 4; j++) {
                UIView *view = self.figureViewArray[j];
                UIView *tagView = [view viewWithTag:TAG_VIEW_TAG];
                tagView.hidden = i != j;
            }
            
            self.figureView.image = [self.figureImageArray objectAtIndex:i];
            self.textView.text = [_titleArray objectAtIndex:i] ;
            [self updateTextView];
            
            
            break;
        }
    }
}


#pragma mark-更新背景图片
-(void)reloadBgImage{
    
//    string url ;
//    _lotteryCommon->GetShareBgImage(url) ;
//    NSString *urlStr = [NSString stringWithUTF8String:url.c_str()] ;
//    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    UIImage *image = [self.imageCache cachedImageForRequest:requset];
//    if (image) {
//        self.backgroundView.image = image ;
//    }else{
//        __weak __typeof(self) weakSelf = self;
//        
//        AFHTTPRequestOperation *option = [[AFHTTPRequestOperation alloc]initWithRequest:requset];
//        option.responseSerializer= [AFImageResponseSerializer serializer] ;
//        [option setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            DPLog(@"图片加载成功") ;
//            
//            [weakSelf.imageCache cacheImage:responseObject forRequest:operation.request];
//            weakSelf.backgroundView.image = (UIImage*)responseObject ;
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            DPLog(@"图片加载失败") ;
//            weakSelf.backgroundView.image = dp_AccountImage(@"share_bg.png") ;
//        }] ;
//        [self.imageQueue addOperation:option];
//        
//    }
    
        
}
#pragma mark - framework notify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {

}


#pragma mark-UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGPoint point = self.scrollView.contentOffset ;
//        point.y = self.scrollView.contentSize.height-(CGRectGetHeight(self.scrollView.bounds)+self.scrollView.contentInset.bottom) ;
//        self.scrollView.contentOffset = point ;
    }) ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
       
    });

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        return NO;
    }
//    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text] ;
//    
//    if (newString.length>20) {
//        [[DPToast makeText:@"输入字数已达上限"]show];
//        return  NO ;
//    }
//    
    return YES ;
}


-(void)textViewDidChange:(UITextView *)textView{

    
    [self updateTextView];
//    if (textView.text.length>20) {
//        textView.text = [textView.text substringToIndex:20];
//    }

    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length>20) {
        textView.text = [textView.text substringToIndex:20];
    }


}-(void)updateTextView{

//    self.textConstraint.constant = self.textView.contentSize.height ;
//    [self.textView setNeedsUpdateConstraints];
//    [self.textView needsUpdateConstraints];
}

#pragma mark - KTMKeyboardObserver

- (void)keyboardFrameChanged:(KTMKeyboardTransition)transition {
    CGPoint point = self.scrollView.contentOffset;
    if (transition.keyboardVisible) {
        if (CGRectGetHeight(transition.frameEnd)) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(transition.frameEnd) - 70, 0);
        }
        point.y += CGRectGetHeight(transition.frameEnd) - 70;
    } else {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOptions animations:^{
        [self.scrollView setNeedsLayout];
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGPoint point = self.scrollView.contentOffset;
        point.y = self.scrollView.contentSize.height - (CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentInset.bottom);
        self.scrollView.contentOffset = point;
    }];
}

#pragma mark- getter
-(UIImageView*)textBgView{
    if (_textBgView == nil) {
        _textBgView = [[UIImageView alloc]initWithImage:dp_AccountImage(@"share_textBg.png")];
        _textBgView.contentMode = UIViewContentModeScaleAspectFill ;
        _textBgView.userInteractionEnabled = YES ;
    }
    return _textBgView ;
}
-(UITextView*)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor clearColor] ;
        _textView.bounces = NO ;
        _textView.showsVerticalScrollIndicator = NO ;
        _textView.font = [UIFont dp_systemFontOfSize:14] ;
        _textView.textColor = [UIColor dp_flatWhiteColor] ;
        _textView.textAlignment = NSTextAlignmentJustified ;
        _textView.text = @"有钱，任性" ;
        _textView.editable = YES ;
        _textView.delegate =self ;
//        _textView.scrollEnabled = NO ;
        _textView.returnKeyType = UIReturnKeyDone ;
        [_textView addTarget:self action:@selector(showLimit) limitMax:20];
    }
    
    return _textView ;

}

-(void)showLimit{

    [[DPToast makeText:@"输入字数已达上限"]show];
}

-(UIView*)middleGroundView{

    if (_middleGroundView == nil) {
        _middleGroundView = [[UIView alloc]init];
        _middleGroundView.backgroundColor = [UIColor clearColor] ;
    }
    return _middleGroundView ;
}

-(NSLayoutConstraint*)textConstraint
{

    if (_textConstraint == nil) {
        
        for (NSLayoutConstraint* constraint in self.textView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                _textConstraint = constraint ;
                break ;
            }
        }
        
    }
    
    return _textConstraint ;
}


#pragma mark- DPShareViewDelegate
- (void)shareWithThirdType:(kThirdShareType)type{
    [[DPThirdCallCenter sharedInstance] dp_shareWithType:type title:type == kThirdShareTypeQQzone? @"来自大彩彩票的分享":nil content:nil image:_shareImage thumbImg:_shareImage urlString:self.urlString inController:self];

}


- (UIImage *)captureScrollView:(UIScrollView *)scrollView
{

    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    } 
    UIGraphicsEndImageContext(); 
    
    if (image != nil) { 
        return image; 
    } 
    return nil; 
}


@end
