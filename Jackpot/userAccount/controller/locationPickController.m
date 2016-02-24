//
//  locationPickController.m
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//本页面注释由sxf提供，他人若更改，请标示

#import "locationPickController.h"
#import "DPCityListConfigure.h"
@interface locationPickController()<UIPickerViewDataSource,UIPickerViewDelegate>
/**
 *  城市列表
 */
@property (nonatomic, strong) DPCityListConfigure *cityList;
/**
 *  locationPick 城市选择器
 */
@property (nonatomic, strong) UIPickerView *locationPicker;
/**
 *  headerView
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  locationStr
 */
@property (nonatomic, copy) NSString *locationStr;
/**
 *  locationCode
 */
@property (nonatomic, copy) NSString *locationCode;
/**
 *  province 省份
 */
@property (nonatomic, strong) NSMutableArray *provinceArray;
/**
 *  city  市级
 */
@property (nonatomic, strong) NSMutableArray *cityArray;
/**
 *  smallCity 区级或者县级
 */
@property (nonatomic, strong) NSMutableArray *smallCityArray;
/**
 *  选中的省份
 */
@property (nonatomic, strong) NSString *selectProvince;
/**
 *  选中的市
 */
@property (nonatomic, strong) NSString *selectCity;
/**
 * 选中的区（县）
 */
@property (nonatomic, strong) NSString *selectSmallCity;

@end

@implementation locationPickController
#pragma mark---------life
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.cityList = [[DPCityListConfigure alloc]init];
    self.provinceArray = [NSMutableArray arrayWithArray:self.cityList.areaList];
    //默认的选中城市信息
    DPAreaInfo *provinceInfo = self.provinceArray[0];
    self.selectProvince = provinceInfo.name;
    self.cityArray = [NSMutableArray arrayWithArray:provinceInfo.children];
    DPAreaInfo *cityInfo = self.cityArray[0];
    self.selectCity = cityInfo.name;
    self.smallCityArray = [NSMutableArray arrayWithArray:cityInfo.children];
    DPAreaInfo *smallCityInfo = self.smallCityArray[0];
    self.selectSmallCity = smallCityInfo.name;
    self.locationCode = [NSString stringWithFormat:@"%zd",smallCityInfo.code];
    self.locationStr = smallCityInfo.name; //[NSString stringWithFormat:@"%@ %@ %@",self.selectProvince,self.selectCity,self.selectSmallCity];
    
    [self.view addSubview:self.locationPicker];
    [self.locationPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.locationPicker.mas_top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(56);
    }];
    
    [self.locationPicker selectRow:self.provinceArray.count*25 inComponent:0 animated:NO];
    [self.locationPicker selectRow:self.cityArray.count*25 inComponent:1 animated:NO];
    [self.locationPicker selectRow:self.smallCityArray.count*25 inComponent:2 animated:NO];
   
}

#pragma mark---------locationPicker
//城市选择器
- (UIPickerView *)locationPicker{
    if (!_locationPicker) {
        _locationPicker = [[UIPickerView alloc]init];
        _locationPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _locationPicker.dataSource = self;
        _locationPicker.delegate = self;
        _locationPicker.backgroundColor = [UIColor dp_flatBackgroundColor];
        _locationPicker.layer.borderWidth = 0.5;
        _locationPicker.layer.borderColor = colorWithRGB(192, 192, 192).CGColor;
        _locationPicker.showsSelectionIndicator = YES;
        _locationPicker.tintColor = [UIColor dp_flatRedColor] ;
        CGFloat lineW = kScreenWidth/3;
        for (NSInteger i=1; i < 3; i++) {
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = colorWithRGB(192, 192, 192);
            [_locationPicker addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(1);
                make.left.mas_equalTo(lineW*i);
            }];
            
        }
        
        UIView *indicatorRecView = [[UIView alloc]init];
        indicatorRecView.backgroundColor = [UIColor dp_flatRedColor];
        [_locationPicker addSubview:indicatorRecView];
        [indicatorRecView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_locationPicker.mas_centerY);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(50);
        }];
        
        UIView *indicatorWhite = [[UIView alloc]init];
        indicatorWhite.alpha = 0.7;
        [_locationPicker insertSubview:indicatorWhite atIndex:0];
        [indicatorWhite mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_locationPicker.mas_centerY);
            make.left.mas_equalTo(5);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(50);
        }];
        
    }
    return _locationPicker;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count*50;
    }else if(component == 1){
        return self.cityArray.count*50;
    }else if(component == 2){
        return self.smallCityArray.count*50;
    }else{
        return 0;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kScreenWidth/3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:14]];
        label.textAlignment = NSTextAlignmentCenter;
    }
    if (component == 0) {
        DPAreaInfo *areaInfo = self.provinceArray[row%self.provinceArray.count];
        label.text = areaInfo.province;
    }else if(component == 1){
        DPAreaInfo *areaInfo = self.cityArray[row%self.cityArray.count];
        label.text = areaInfo.city;
    }else if(component == 2){
        DPAreaInfo *areaInfo = self.smallCityArray[row%self.smallCityArray.count];
        label.text = areaInfo.canton;
    }

    return label;
    
}
//城市选择
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        DPAreaInfo *provinceInfo = self.provinceArray[row%self.provinceArray.count];
        self.cityArray = [NSMutableArray arrayWithArray:provinceInfo.children];
        DPAreaInfo *cityInfo = self.cityArray[0];
        self.selectCity = cityInfo.city;
        self.smallCityArray = [NSMutableArray arrayWithArray:cityInfo.children];
        DPAreaInfo *smallCityInfo = self.smallCityArray[0];
        self.selectSmallCity = smallCityInfo.canton;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        self.selectProvince = provinceInfo.province;
        self.locationCode = [NSString stringWithFormat:@"%zd",provinceInfo.code];
        
        [pickerView selectRow:self.cityArray.count*25 inComponent:1 animated:NO];
        [pickerView selectRow:self.smallCityArray.count*25 inComponent:2 animated:NO];
        
         self.locationStr = smallCityInfo.name;
    }else if (component == 1){

        DPAreaInfo *cityInfo = self.cityArray[row%self.cityArray.count];
        self.smallCityArray = [NSMutableArray arrayWithArray:cityInfo.children];
        DPAreaInfo *smallCityInfo = self.smallCityArray[0];
        self.selectSmallCity = smallCityInfo.canton;
        [pickerView reloadComponent:2];
        self.selectCity = cityInfo.city;
        self.locationCode = [NSString stringWithFormat:@"%zd",cityInfo.code];
        
        [pickerView selectRow:self.smallCityArray.count*25 inComponent:2 animated:NO];
        self.locationStr = smallCityInfo.name;
    }else{
        DPAreaInfo *cityInfo = self.smallCityArray[row%self.smallCityArray.count];
        self.selectSmallCity = cityInfo.canton;
        self.locationCode = [NSString stringWithFormat:@"%zd",cityInfo.code];
        
        self.locationStr = cityInfo.name;
    }
//    self.locationStr = [NSString stringWithFormat:@"%@ %@ %@",self.selectProvince,self.selectCity,self.selectSmallCity];
}
#pragma mark---------headerView
//头部ui
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor dp_flatWhiteColor];
        cancelButton.layer.cornerRadius = 5;
        cancelButton.layer.borderWidth = 0.5;
        cancelButton.layer.borderColor = colorWithRGB(192, 192, 192).CGColor;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_headerView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(68, 40));
            make.left.mas_equalTo(20);
        }];
        
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        confirmBtn.layer.cornerRadius = 5;
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_headerView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(68, 40));
            make.right.mas_equalTo(-20);
        }];
        
    }
    return _headerView;
}
//取消选择
- (void)cancelButtonTapped:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//确定选择
- (void)confirmBtnTapped:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.locationBlock) {
            self.locationBlock(self.locationStr,self.locationCode);
        }
    }];
}
@end
