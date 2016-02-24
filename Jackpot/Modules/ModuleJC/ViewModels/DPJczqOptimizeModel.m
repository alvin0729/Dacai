//
//  DPJczqOptimizeModel.m
//  Jackpot
//
//  Created by Ray on 15/12/10.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPJczqOptimizeModel.h"
#import <objc/runtime.h>

@implementation DPOptimizeMatch


@end

static const char *code_key = "code_key" ;

@implementation PBMJczqMatch (category)

-(void)setMatchCode:(NSInteger)matchCode{

    objc_setAssociatedObject(self, code_key, @(matchCode), OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

-(NSInteger)matchCode {

    return [objc_getAssociatedObject(self, code_key) integerValue];
}

@end



@interface DPJczqOptimizeModel ()
@property (nonatomic, strong) NSString *cellIdentifyStr;

@end

@implementation DPJczqOptimizeModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.matchInfoArray = [[NSMutableArray alloc]init];
        self.unfold = NO ;
    }
    return self;
}

-(void)setMatchInfoArray:(NSMutableArray *)matchInfoArray{

    _matchInfoArray = matchInfoArray ;
    
}

-(NSString*)cellIdentifyStr{
    return [NSString stringWithFormat:@"cellIndetify_%02lu",(unsigned long)_matchInfoArray.count] ;
}

-(NSString*)gotTitleString{

    NSMutableString *titleStr = [[NSMutableString alloc]init];
    if (self.matchInfoArray.count == 1) {
        [titleStr appendString:@"单关 "] ;

    }else{
        [titleStr appendString:[NSString stringWithFormat:@"%lu串1 ",(unsigned long)self.matchInfoArray.count]] ;
    }
    
    for (int i= 0 ; i<self.matchInfoArray.count ; i++) {
        DPOptimizeMatch *match = [self.matchInfoArray objectAtIndex:i] ;
        NSString *detailStr = [NSString stringWithFormat:@"[%@,%@]%@",match.matchName,match.typeName,i == self.matchInfoArray.count-1 ? @"":@"*"];
        [titleStr appendString:detailStr];
    }
    
    return titleStr ;
}

-(NSString *)gotSpWithMatch:(PBMJczqMatch *)match optiion:(DPJczqOptimizeOption *)option {
    NSString *resultStr;
    switch (option.gameType) {
        case GameTypeJcRqspf:
            resultStr = [NSString stringWithFormat:@"%@", [match.rqspfItem.spListArray dp_safeObjectAtIndex:option.index]];
            
            break;
        case GameTypeJcBf:
            resultStr = [NSString stringWithFormat:@"%@", [match.bfItem.spListArray dp_safeObjectAtIndex:option.index]];
            break;
        case GameTypeJcSpf:
            resultStr = [NSString stringWithFormat:@"%@", [match.spfItem.spListArray dp_safeObjectAtIndex:option.index]];
            
            break;
        case GameTypeJcZjq:
            resultStr = [NSString stringWithFormat:@"%@", [match.zjqItem.spListArray dp_safeObjectAtIndex:option.index]];
            break;
        case GameTypeJcBqc:
            resultStr = [NSString stringWithFormat:@"%@", [match.bqcItem.spListArray dp_safeObjectAtIndex:option.index]];
            
            break;
        default:
            break;
    }
    
    if ([resultStr floatValue] == 0) {
        resultStr = @"1.00" ;
    }
    
    return resultStr;
}


-(NSString*)gotGameTypeNameWithOption:(DPJczqOptimizeOption*)option{
    
    NSString *resultStr;
    switch (option.gameType) {
        case GameTypeJcRqspf:
            resultStr = [NSString stringWithFormat:@"%@", rqspfNames[option.index]];
            
            break;
        case GameTypeJcBf:
            resultStr = [NSString stringWithFormat:@"%@", bfNames[option.index]];
            break;
        case GameTypeJcSpf:
            resultStr = [NSString stringWithFormat:@"%@",spfNames[option.index]];
            
            break;
        case GameTypeJcZjq:
            resultStr = [NSString stringWithFormat:@"%@", zjqNames[option.index]];
            break;
        case GameTypeJcBqc:
            resultStr = [NSString stringWithFormat:@"%@", bqcNames[option.index]];
            
            break;
        default:
            break;
    }
    
    return resultStr;
}

@end
