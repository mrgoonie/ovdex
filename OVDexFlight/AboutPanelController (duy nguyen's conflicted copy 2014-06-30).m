//
//  AboutPanelController.m
//  OVDexFlight
//
//  Created by Goon on 4/18/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "AboutPanelController.h"

@interface AboutPanelController ()

@end

@implementation AboutPanelController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewTitle.font = [UIFont fontWithName:@"Trim_Web_Bold" size:35];
    _content.font = [UIFont fontWithName:@"Trim_Web_Regular" size:20];
    
    _isShow = NO;
    self.view.hidden = YES;
    _closeBtn.hidden = YES;

    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)show
{
    _isShow = YES;
    self.view.hidden = NO;
    
    self.view.alpha = 0.0;
    self.panelHolder.transform = CGAffineTransformMakeScale(0.0,0.0);
    
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.alpha = 1.0;
                         self.panelHolder.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show about done!");
                         _closeBtn.hidden = NO;
                     }];
}

- (void)hide
{
    _isShow = NO;
    
    _closeBtn.hidden = YES;
    
    CGAffineTransform t = CGAffineTransformMakeScale(0,0);
    
    [UIView animateWithDuration:0.23
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.alpha = 0.0;
                         self.panelHolder.transform = t;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show about done!");
                         self.view.hidden = YES;
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end
