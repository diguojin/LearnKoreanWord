/*
 *  UIViewController+MBProgressHUD.h
 *

 *
 */

#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

@interface UIViewController (MBProgressHUD) <MBProgressHUDDelegate>

typedef void (^HUDFinishedHandler)();

/*
 * Shows an MBProgressHUD with the default spinner
 * The HUD is added as a subview to this view
 * controller's parentViewController.view.
 */
- (void)showHUD;

/*
 * Shows an MBProgressHUD with the default spinner
 * and sets the label text beneath the spinner
 * to the given message. The HUD is added as a subview
 * to this view controller's parentViewController.view.
 */
- (void)showHUDWithMessage:(NSString *)message;

/*
 * Dismisses the currently displayed HUD.
 */
- (void)hideHUD;

/*
 * Changes the currently displayed HUD's label text to
 * the given message and then dismisses the HUD after a
 * short delay.
 */
- (void)hideHUDWithCompletionMessage:(NSString *)message;

/*
 * Changes the currently displayed HUD's label text to
 * the given message and then dismisses the HUD after a
 * short delay. Additionally, runs the given completion
 * block after the HUD hides.
 */
- (void)hideHUDWithCompletionMessage:(NSString *)message finishedHandler:(HUDFinishedHandler)finishedHandler;


/**
 *  显示选择正确提示
 *
 *  @param isCorrect 正确与否
 */
- (void)showAnswerHUDIsCorrect:(BOOL)isCorrect;

/**
 *  显示是否全部正确地提示
 *
 *  @param isCorrect 正确与否
 */
- (void)showAnswerFinishHUDAllIsCorrect:(BOOL)isCorrect;

@end
