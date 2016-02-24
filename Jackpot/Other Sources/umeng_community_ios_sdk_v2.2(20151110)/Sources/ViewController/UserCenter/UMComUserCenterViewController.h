//
//  UMComUserCenterViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 9/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComFeedTableViewController.h"


@class UMComUser,UMComImageView,UMComUserTopicsView,UMComUserCenterViewModel;

@interface UMComUserCenterViewController :UMComFeedTableViewController

//上部
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UMComImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *focus;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topBgImage;

//中部
@property (weak, nonatomic) IBOutlet UILabel *feedNumber;
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (weak, nonatomic) IBOutlet UILabel *followerNumber;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *fanNumber;
@property (weak, nonatomic) IBOutlet UIButton *fanButton;
@property (nonatomic, strong) UIView *indirectorLine;
//下部

-(IBAction)onClickFoucus:(id)sender;

-(IBAction)onClickAlbum:(id)sender;

-(IBAction)onClickTopic:(id)sender;

- (id)initWithUid:(NSString *)uid;

-(id)initWithUser:(UMComUser *)user;

-(IBAction)onClickFollowers:(id)sender;

-(IBAction)onClickFans:(id)sender;

@end
