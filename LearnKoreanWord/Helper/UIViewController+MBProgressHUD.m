/*
 *  UIViewController+MBProgressHUD.m
 *
 
 *
 */

#import "MBProgressHUD.h"
#import "UIViewController+MBProgressHUD.h"
#import <objc/runtime.h>

/* This key is used to dynamically create an instance variable
 * within the MBProgressHUD category using objc_setAssociatedObject
 */
const char *progressHUDKey = "progressHUDKey";

/* This key is used to dynamically create an instance variable
 * within the MBProgressHUD category using objc_setAssociatedObject
 */
const char *finishedHandlerKey = "finishedHandlerKey";

@interface UIViewController (MBProgressHUD_Private)

@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, copy) HUDFinishedHandler finishedHandler;

@end

@implementation UIViewController (MBProgressHUD)

- (MBProgressHUD *)progressHUD
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, progressHUDKey);
    if(!hud)
    {
        UIView *hudSuperView = self.view;
        hud = [[MBProgressHUD alloc] initWithView:hudSuperView] ;
        hud.dimBackground = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hudSuperView addSubview:hud];
        self.progressHUD = hud;
    }
    return hud;
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD
{
    objc_setAssociatedObject(self, progressHUDKey, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HUDFinishedHandler)finishedHandler
{
    HUDFinishedHandler block = objc_getAssociatedObject(self, finishedHandlerKey);
    return block;
}

- (void)setFinishedHandler:(HUDFinishedHandler)completionBlock
{
    objc_setAssociatedObject(self, finishedHandlerKey, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)_showHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = YES;
    [self.progressHUD show:YES];
}

- (void)showHUD
{
    [self _showHUDWithMessage:nil];
}

- (void)showHUDWithMessage:(NSString *)message
{
    [self _showHUDWithMessage:message];
}

- (void)hideHUD
{
    if(!self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
}

- (void)hideHUDWithCompletionMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
}

- (void)hideHUDWithCompletionMessage:(NSString *)message finishedHandler:(HUDFinishedHandler)finishedHandler
{
    self.progressHUD.delegate = self;
    self.finishedHandler = finishedHandler;
    [self hideHUDWithCompletionMessage:message];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if(self.finishedHandler)
    {
        self.finishedHandler();
        self.finishedHandler = nil;
    }
    self.progressHUD.delegate = nil;
}

/**
 *  显示选择正确提示
 *
 *  @param isCorrect 正确与否
 */
- (void)showAnswerHUDIsCorrect:(BOOL)isCorrect
{
    [self.view addSubview:self.progressHUD];
    if (isCorrect) {
        self.progressHUD.labelText = @"回答正确";
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correct"]];
    }else{
        self.progressHUD.labelText = @"回答错误";
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong"]];
    }
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    self.progressHUD.customView.frame = CGRectMake(0, 0, 50, 50);
    
    [self.progressHUD showAnimated:YES whileExecutingBlock:^{
        [NSThread sleepForTimeInterval:0.4];
    } completionBlock:^{
        [self.progressHUD removeFromSuperview];
    }];
}

/**
 *  显示是否全部正确地提示
 *
 *  @param isCorrect 正确与否
 */
- (void)showAnswerFinishHUDAllIsCorrect:(BOOL)isCorrect
{
    [self.view addSubview:self.progressHUD];
    if (isCorrect) {
        self.progressHUD.labelText = @"太棒了,全都做对了!";
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face"]];
    }else{
        self.progressHUD.labelText = @"列出还不太熟悉的单词";
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list"]];
    }
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    self.progressHUD.customView.frame = CGRectMake(0, 0, 50, 50);
    
    [self.progressHUD showAnimated:YES whileExecutingBlock:^{
        [NSThread sleepForTimeInterval:2];
    } completionBlock:^{
        [self.progressHUD removeFromSuperview];
    }];
}

@end
