//
//  DPDltDrawVC.h
//  DacaiProject
//
//  Created by Ray on 15/2/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  大乐透走势图
 #import "DPBaseDrawVC.h"
typedef void(^modifyTargetBall)(int blue[12], int red[35] );

@interface DPDltDrawVC : DPBaseDrawVC

@property(nonatomic,copy)modifyTargetBall modifyBalls ;


//- (instancetype)initWithTitles:(NSArray *)titleArray withDocTitles:(NSArray *)docTitles titleSelectColor:(UIColor *)selectColor titleNormalColor:(UIColor *)normlColor bottomImg:(UIImage *)bottomImg ;

- (instancetype)initWithTitles:(NSArray *)titleArray withDocTitles:(NSArray *)docTitles titleSelectColor:(UIColor *)selectColor titleNormalColor:(UIColor *)normlColor bottomImg:(UIImage *)bottomImg redBall:(NSArray*)redballs blueBall:(NSArray*)blueballs ;
@end
