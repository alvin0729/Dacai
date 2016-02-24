//
//  DPResultZcDetailViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-28.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPResultZcDetailViewController.h"
#import "DrawNotice.pbobjc.h"
 
@interface DPResultZcDetailViewController () {
@private
    NSArray *_labelArray;
}
@property (nonatomic, strong) PBMDrawZcMatchList *dataBase;
@end

@implementation DPResultZcDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"对阵详情";

    CGFloat x = 0, y = 10;
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:4 * 15];
    
    CGFloat baseX = 5;
    CGFloat teamWidth = floor(kScreenWidth / 3);
    CGFloat itemWidth = floor(kScreenWidth - baseX * 2 - teamWidth * 2) / 2;
    CGFloat widths[] = {itemWidth, teamWidth, itemWidth, teamWidth};
    for (int i = 0; i < 15; i++) {
        x = baseX;
        for (int j = 0; j < 4; j++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, widths[j], 25)];
            label.backgroundColor = [UIColor whiteColor ];
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = [UIColor colorWithRed:0.71 green:0.69 blue:0.67 alpha:1].CGColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont dp_systemFontOfSize:12];
            if (i == 0) {
                label.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
                label.font = [UIFont dp_systemFontOfSize:11];

                switch (j) {
                    case 0:
                        label.text = @"场次";
                        break;
                    case 1:
                        label.text = @"主队";
                        break;
                    case 2:
                        label.text = @"彩果";
                        break;
                    case 3:
                        label.text = @"客队";
                        break;
                    default:
                        break;
                }
            } else if (j == 0) {
                label.text = [NSString stringWithFormat:@"%d", i];
                label.font = [UIFont dp_systemFontOfSize:11];
                label.textColor = [UIColor colorWithRed:0.39 green:0.35 blue:0.31 alpha:1];
            } else if (j == 2) {
                label.textColor = [UIColor dp_flatRedColor];
            } else {
                label.textColor = [UIColor colorWithRed:0.39 green:0.35 blue:0.31 alpha:1];
                label.text = @"—";
            }
            [objects addObject:label];
            [self.view addSubview:label];

            x += widths[j] - 0.5;
        }
        y += 25 - 0.5;
    }
    _labelArray = objects;
    [self showHUD];

    [self requestDrawHomeList];
}
- (void)requestDrawHomeList {
    
    @weakify(self) ;
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/draw/GetZcMatchesByGameId?gameid=%d", self.gameId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self) ;
        [self dismissHUD];
        self.dataBase = [PBMDrawZcMatchList parseFromData:responseObject error:nil];
        for (int i = 0; i < 14; i++) {
            PBMDrawZcMatchList_Match *item = [self.dataBase.matchesArray objectAtIndex:i];
            UILabel *homeLabel = _labelArray[(i + 1) * 4 + 1];
            UILabel *awayLabel = _labelArray[(i + 1) * 4 + 3];
            UILabel *resultLabel = _labelArray[(i + 1) * 4 + 2];
            
            homeLabel.text = item.homeName;
            awayLabel.text = item.awayName;
            resultLabel.text = item.resluts;
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self) ;
        [self dismissHUD];

    }];
    
}


@end
