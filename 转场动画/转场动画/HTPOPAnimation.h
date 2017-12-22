//
//  HTPOPAnimation.h
//  转场动画
//
//  Created by 张海涛 on 2017/3/16.
//  Copyright © 2017年 张海涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HTPOPAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (weak, nonatomic) UIViewController *toViewController;
@end
