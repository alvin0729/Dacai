//
//  UMComUserTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15-3-31.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComUserTableViewCell.h"
#import "UMComPushRequest.h"
#import "UMComShowToast.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComImageView.h"
#import "UMComSession.h"
#import "UMComClickActionDelegate.h"
#import "UMComCoreData.h"

@interface UMComUserTableViewCell ()

@end

@implementation UMComUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-8, 3, 10, 10)];
    [self.userName addSubview:self.genderImageView];
    self.genderImageView.clipsToBounds = YES;
    self.genderImageView.layer.cornerRadius = self.genderImageView.frame.size.width/2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAtThissView:)];
    [self addGestureRecognizer:tap];
    self.descriptionLable.textColor = [UMComTools colorWithHexString:FontColorGray];
    UMComImageView *portrait = [[[UMComImageView imageViewClassName] alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    self.portrait = portrait;
    [self.contentView addSubview:self.portrait];
    self.userName.font = UMComFontNotoSansLightWithSafeSize(17);
    self.descriptionLable.font = UMComFontNotoSansLightWithSafeSize(10);
    self.focusButton.titleLabel.font = UMComFontNotoSansLightWithSafeSize(13);
    
    self.focusButton.layer.borderWidth = 0.5;
    self.focusButton.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    self.focusButton.backgroundColor = [UIColor dp_flatWhiteColor];
    self.focusButton.layer.cornerRadius = 3;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)didTapAtThissView:(UIGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:self.user];
    }
}

- (void)displayWithUser:(UMComUser *)user
{
    self.user = user;
    NSString *iconUrl = [user iconUrlStrWithType:UMComIconSmallType];
    self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
    self.portrait.clipsToBounds = YES;
    [self.portrait setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:user.gender.integerValue]];
    [self.userName setText:user.name];
    NSNumber *post_count = user.post_count;
    NSNumber *fans_count = user.fans_count;
    if (!post_count) {
        post_count = @0;
    }
    if (!fans_count) {
        fans_count = @0;
    }
    self.descriptionLable.text =  [NSString stringWithFormat:@"发表消息: %@ / 粉丝: %@",post_count,fans_count];
    CGSize textSize = [self.userName.text sizeWithFont:self.userName.font constrainedToSize:CGSizeMake(self.frame.size.width, self.userName.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat originX = textSize.width;
    if (textSize.width >= self.userName.frame.size.width) {
        originX = self.userName.frame.size.width-5;
    }else if (textSize.width >= self.userName.frame.size.width-5){
        originX-= 5;
    }
    self.genderImageView.frame = CGRectMake(originX+2, self.genderImageView.frame.origin.y, self.genderImageView.frame.size.width, self.genderImageView.frame.size.height);
    if ([user.gender intValue] == 0) {
        self.genderImageView.image = UMComImageWithImageName(@"♀+.png");
        
    }else{
        self.genderImageView.image = UMComImageWithImageName(@"♂+.png");
    }
    BOOL isFollow = [self.user.has_followed boolValue];
    [self changeFocusWithIsFollow:isFollow];
}


- (IBAction)onClickFocusButton:(id)sender {
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFollowUser:)]) {
        [self.delegate customObj:self clickOnFollowUser:self.user];
    }
}


- (void)focusUserAfterLoginSucceedWithResponse:(void (^)(NSError *error))response
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    BOOL hasFollow = [self.user.has_followed boolValue];
    __weak UMComUserTableViewCell *weakSelf = self;
    [UMComPushRequest followerWithUser:self.user isFollow:!hasFollow completion:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        }else{
            [weakSelf changeFocusWithIsFollow:[weakSelf.user.has_followed boolValue]];
        }
    }];
}

- (void)changeFocusWithIsFollow:(BOOL)isFollow
{
    if(isFollow){
        [self.focusButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [self.focusButton setTitle:UMComLocalizedString(@"has_been_followed" ,@"取消关注") forState:UIControlStateNormal];
        
    }else{
        [self.focusButton setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateNormal];
        [self.focusButton setTitle:UMComLocalizedString(@"follow" ,@"+关注") forState:UIControlStateNormal];
    }
    self.descriptionLable.text =  [NSString stringWithFormat:@"发表消息: %@ / 粉丝: %@",[self.user post_count],self.user.fans_count];
}

@end
