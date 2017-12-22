//
//  HTBaseNavViewController.m
//  转场动画
//
//  Created by 张海涛 on 2017/3/16.
//  Copyright © 2017年 张海涛. All rights reserved.
//

#import "HTBaseNavViewController.h"
#import "HTPOPAnimation.h"
@interface HTBaseNavViewController ()<UINavigationControllerDelegate>

@property(nonatomic,strong)UIPanGestureRecognizer *pan;
@property(nonatomic,strong)HTPOPAnimation *popAnimation;
@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *interactivePopTransition;


@end

@implementation HTBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:_pan];
    
    _popAnimation = [[HTPOPAnimation alloc] init];
}



- (void)pan:(UIPanGestureRecognizer *)pan{
    CGFloat progress = [pan translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    progress = MIN(1.0, MAX(0.0, progress));
    NSLog(@"progress---%.2f",progress);
    
    static BOOL flag = NO;
    if (pan.state == UIGestureRecognizerStateBegan){
        flag = YES;
    }
    if (flag && progress > 0)
    {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        self.interactivePopTransition.completionCurve = UIViewAnimationCurveEaseOut;
        [self popViewControllerAnimated:YES];
        flag = NO;
    }
    if (pan.state == UIGestureRecognizerStateChanged){
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled){
        if (progress > 0.25){
            [self.interactivePopTransition finishInteractiveTransition];
        }else{
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }

}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation==UINavigationControllerOperationPop) {
        return self.popAnimation;
    }
    return nil;
}

//你就当系统把这个对象拿走了 目的是要知道你用哪个对象控制进度
//监听你控制进度的时候 他再回调到你的animation里
//当然中间还有一堆系统的处理
//实现这个协议方法，可以控制动画的进度。   也可以实现  直接执行自定义动画
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactivePopTransition;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (navigationController.viewControllers.count <= 1) {
        self.pan.enabled = NO;
    }
    else {
        self.pan.enabled = YES;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
