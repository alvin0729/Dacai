//
//  DPLotteryResultCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLotteryResultCell.h"

@interface DPLotteryResultCell () {
@private
    UILabel     *_gameTypeLabel;
    UILabel     *_gameNameLabel;
    UILabel     *_drawTimeLabel;
    UILabel     *_preResultLabel;
    GameTypeId   _gameType;
}

@end

@implementation DPLotteryResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.gameTypeLabel];
    [contentView addSubview:self.gameNameLabel];
    [contentView addSubview:self.drawTimeLabel];
    
    [self.gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(13);
        make.top.equalTo(contentView).offset(10);
    }];
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.gameTypeLabel);
        make.left.equalTo(contentView).offset(120);
    }];
    [self.drawTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.gameTypeLabel);
        make.right.equalTo(contentView).offset(-20);
    }];
    
    UIImageView *imageView = ({
        [[UIImageView alloc] initWithImage:dp_ResultImage(@"arrow_right.png")];
    });
    [contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-7);
    }];
}

- (void)layoutWithGameType:(GameTypeId)gameType {
    _gameType = gameType;
    
    const NSDictionary *redMapping = @{ @(GameTypeSd) : @3,
                                        @(GameTypeSsq) : @6,
                                        @(GameTypeQlc) : @7,
                                        @(GameTypeDlt) : @5,
                                        @(GameTypePs) : @3,
                                        @(GameTypePw) : @5,
                                        @(GameTypeQxc) : @7,
                                          };
    const NSDictionary *blueMapping = @{ @(GameTypeSd) : @0,
                                         @(GameTypeSsq) : @1,
                                         @(GameTypeQlc) : @1,
                                         @(GameTypeDlt) : @2,
                                         @(GameTypePs) : @0,
                                         @(GameTypePw) : @0,
                                         @(GameTypeQxc) : @0,
                                           };
    
    switch (gameType) {
        case GameTypeSd: {
            // 试机号
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
            label.font = [UIFont dp_systemFontOfSize:11];
            label.text = @"试机号：";
            [self.contentView addSubview:label];
            [self.contentView addSubview:self.preResultLabel];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(105);
                make.top.equalTo(self.contentView).offset(40);
            }];
            [self.preResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right);
                make.top.equalTo(self.contentView).offset(40);
            }];
        }
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
          {
            NSInteger redCount = [redMapping[@(gameType)] integerValue];
            NSInteger blueCount = [blueMapping[@(gameType)] integerValue];
            
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:redCount + blueCount];
            NSMutableArray *labels = [NSMutableArray arrayWithCapacity:redCount + blueCount];
             
            for (int i = 0; i < redCount; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_DigitLotteryImage(@"ballSelectedRed001_07.png")];
                
                UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
                label.textColor = [UIColor dp_flatWhiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont dp_systemFontOfSize:15];
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                [imageView addSubview:label];
                
                [self.contentView addSubview:imageView];
                [objects addObject:imageView];
                [labels addObject:label];
             }
            for (int i = 0; i < blueCount; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_DigitLotteryImage(@"ballSelectedBlue001_14.png")];
                
                UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor dp_flatWhiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont dp_systemFontOfSize:15];
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                [imageView addSubview:label];
                [self.contentView addSubview:imageView];
                [objects addObject:imageView];
                [labels addObject:label];
             }
            
            [objects enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(idx * 28 + 15);
                    make.top.equalTo(self.contentView).offset(36.5);
                    make.height.equalTo(@26);
                    make.width.equalTo(@26);
                }];
            }];
            
            _labels = labels;
        }
            break;
        case GameTypeZcNone:
        case GameTypeZc14:
        case GameTypeZc9:
        {
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:14];
            
            for (int i = 0; i < 14; i++) {
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = UIColorFromRGB(0x498643);//[UIColor dp_flatGreenColor];
                label.textColor = [UIColor dp_flatWhiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont dp_systemFontOfSize:13.5];
                label.adjustsFontSizeToFitWidth = YES;
                
                [self.contentView addSubview:label];
                [objects addObject:label];
            }
            
            [objects enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(idx * 18.5 + 15);
                    make.top.equalTo(self.contentView).offset(37);
                    make.height.equalTo(@21);
                    make.width.equalTo(@14.5);
                }];
            }];
            
            _labels = objects;
        }
            break;
        case GameTypeJcNone:
        case GameTypeLcNone:
        case GameTypeJcHt:
        case GameTypeLcHt: {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = gameType == GameTypeLcNone ? [UIColor dp_flatGreenColor] : UIColorFromRGB(0x3879db);//[UIColor dp_flatMediumElectricBlueColor];
            label.textColor = [UIColor dp_flatWhiteColor];
            label.font = [UIFont dp_systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.clipsToBounds = YES;
            label.layer.cornerRadius = 11;
            
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(16);
                make.top.equalTo(self.contentView).offset(35);
                make.height.equalTo(@26);
                make.width.equalTo(@0);
            }];
            
            _matchLabel = label;
        }
            break;
       
        default:
            break;
    }
}

#pragma mark - getter
- (UILabel *)gameTypeLabel {
    if (_gameTypeLabel == nil) {
        _gameTypeLabel = [[UILabel alloc] init];
        _gameTypeLabel.backgroundColor = [UIColor clearColor];
        _gameTypeLabel.textColor = [UIColor dp_flatBlackColor];
        _gameTypeLabel.font = [UIFont dp_systemFontOfSize:16];
    }
    return _gameTypeLabel;
}

- (UILabel *)gameNameLabel {
    if (_gameNameLabel == nil) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.backgroundColor = [UIColor clearColor];
        _gameNameLabel.textColor = [UIColor colorWithRed:0.53 green:0.45 blue:0.39 alpha:1];
        _gameNameLabel.font = [UIFont dp_systemFontOfSize:12];
    }
    return _gameNameLabel;
}

- (UILabel *)drawTimeLabel {
    if (_drawTimeLabel == nil) {
        _drawTimeLabel = [[UILabel alloc] init];
        _drawTimeLabel.backgroundColor = [UIColor clearColor];
        _drawTimeLabel.textColor = [UIColor colorWithRed:0.73 green:0.7 blue:0.65 alpha:1];
        _drawTimeLabel.font = [UIFont dp_systemFontOfSize:10.5];
    }
    return _drawTimeLabel;
}

- (UILabel *)preResultLabel {
    if (_preResultLabel == nil) {
        _preResultLabel = [[UILabel alloc] init];
        _preResultLabel.backgroundColor = [UIColor clearColor];
        _preResultLabel.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
        _preResultLabel.font = [UIFont dp_systemFontOfSize:11];
    }
    return _preResultLabel;
}

@end
