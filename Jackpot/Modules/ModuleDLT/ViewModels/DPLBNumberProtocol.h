//
//  DPLBNumberProtocol.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#ifndef DacaiProject_DPLBNumberProtocol_h
#define DacaiProject_DPLBNumberProtocol_h

// model和ctrl数据源协议
@protocol DPLBNumberCommonDataSource <NSObject>
@optional
@property (nonatomic, assign)           NSInteger       indexPathRow;       //  中转页选中row
@property (nonatomic, assign)           NSInteger       sectionCount;
@property (nonatomic, assign)           NSInteger       gameIndex;          //  小彩种tag
@property (nonatomic, strong)           NSDictionary    *ballUIDict;        //  UI布局
@property (nonatomic, strong, readonly) NSArray         *titleArray;        //  小彩种名
@property (nonatomic, strong, readonly) NSArray         *dropDownListArray; //  dropdownList
@property (nonatomic, assign, readonly) GameTypeId      gameType;
@property (nonatomic, strong, readonly) NSString        *trendCellClass;    //  走势图cell
@property (nonatomic, strong, readonly) NSString        *numberCellClass;   //  table cell
@property (nonatomic, assign, readonly) CGFloat         trendCellHeight;    //  走势cell的高
@property (nonatomic, assign, readonly) NSInteger       note;               //  注数
@property (nonatomic, assign, readonly) BOOL            isRandomBtnHidden;  //  摇一摇按钮是否隐藏
@property (nonatomic, assign, readonly) BOOL            canBecomeFirstResponder;
@property (nonatomic, assign, readonly) NSInteger       trendDragHeight;    //  number table下推高度
@property (nonatomic, assign, readonly) BOOL            hasData;            //  底层有无数据

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (id)trendCellModelForIndexPath:(NSIndexPath *)indexPath;
- (id)numberCellModelForIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

// model和ctrl交互协议
@protocol DPLBNumberHandlerDataSource <NSObject>
@optional
@property (nonatomic, assign) BOOL isOpenSwitch;                                        // 是否打开遗漏
- (void)reloadGameIndex:(NSInteger)gameIndex;
- (void)refreshBallSelected:(BOOL)selected index:(NSInteger)index row:(NSInteger)row;   // 刷新选中状态
- (NSInteger)numberOfSelectedBallsForRow:(NSInteger)row gameIndex:(NSInteger)gameIndex; // 当前某个区选中了多少个球
- (void)clearAllSelectedData;                                                           // 清除所有选中数据
- (void)digitalDataRandom;                                                              // 产生随机一注
- (int)sendSubmitReq;                                                                   // 提交
@end


//cell model 数据模型协议
@protocol DPLBTrendCellDataProtocol <NSObject> // 走势cell的数据模型协议
//@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong) UIImage *ballViewImg;
@property (nonatomic, strong) UIColor *gameNameColor;
@property (nonatomic, strong) NSString *gameNameText;
@property (nonatomic, strong) NSAttributedString *gameInfoAttText;
@end

 
@protocol DPLBDigitalCellDataProtocol <NSObject>
@property (nonatomic, assign) GameTypeId    gameType;//彩种类型
@property (nonatomic, assign) NSInteger     gameIndex;//玩法类型
@property (nonatomic, strong) NSIndexPath*  indexPath;//当前行
@property (nonatomic, assign) BOOL          isOpenSwitch;//是否开启遗漏
@property (nonatomic, strong) NSArray*      btnSelectArray;//经过选择后的
@property (nonatomic, assign) NSInteger     total;
@property (nonatomic, strong) NSArray*      labelTextArray;//遗漏值颜色
@property (nonatomic, strong) NSArray*      labelColorArray;//遗漏值
@end

  
// cell 扩展协议，传入cell model
@protocol DPLBCellDataModelProtocol <NSObject>
@required
//@property (nonatomic, strong) id dataModel;
- (void)setDataModel:(id)dataModel;
@end
#endif
