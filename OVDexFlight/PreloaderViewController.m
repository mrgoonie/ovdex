//
//  PreloaderViewController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/24/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PreloaderViewController.h"
#import "MapController.h"

@interface PreloaderViewController ()
{
    MapController* mapController;
}

@end

@implementation PreloaderViewController

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
    
    //_indicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
    _loadingTxt.font = [UIFont fontWithName:@"Trim_Web_Light" size:17];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [_indicator startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_indicator stopAnimating];
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
    
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show done!");
                         
                     }];
}

- (void)hide
{
    _isShow = NO;
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Hide done!");
                         self.view.hidden = YES;
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end
