//
//  UIImageView+DPExtension.m
//  Jackpot
//
//  Created by mu on 15/12/29.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UIImageView+DPExtension.h"

@implementation UIImageView (DPExtension)
- (void)dp_setImageWithURL:(NSString *)URLStr andPlaceholderImage:(UIImage *)placeholdImage{
    if (URLStr.length <=0) {
        self.image = placeholdImage;
        return;
    }
    
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedImageManager]GET:URLStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        self.image = (UIImage *)responseObject;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
   }];
}
@end
