//
//  MapStyleDropdown.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/18/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "MapStyleDropdown.h"
#import "MapController.h"

@interface MapStyleDropdown (){
    UITapGestureRecognizer *gesture;
    MapController* mapController;
}

@end

@implementation MapStyleDropdown

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
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
        _isLabel = mapController.isLabel;
        
        [self detectLabelCheckbox];
    }
    
    NSLog(@"isLabel = %d", _isLabel);
    
    [_b0.titleLabel setFont:[UIFont fontWithName:@"Trim_Web_SemiBold" size:15]];
    [_b1.titleLabel setFont:[UIFont fontWithName:@"Trim_Web_SemiBold" size:15]];
    [_b2.titleLabel setFont:[UIFont fontWithName:@"Trim_Web_SemiBold" size:15]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//

- (void)show
{
    _isShow = YES;
    self.view.hidden = NO;
    
    self.view.alpha = 0.0;
    
    CGRect frame = self.view.frame;
    frame.origin.x += 100;
    self.view.frame = frame;
    
    frame.origin.x -= 100;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.alpha = 1.0;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show about done!");
                     }];
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.parentViewController.view addGestureRecognizer:gesture];
    
    gesture.delegate = mapController;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        
        NSLog(@"added failure requirement to: %@", otherGestureRecognizer);
    }
    
    return YES;
}

- (void)hide
{
    _isShow = NO;
    
    if (gesture.delegate) {
        gesture.delegate = nil;
    }
    
    CGRect frame = self.view.frame;
    frame.origin.x += 100;
    
    [UIView animateWithDuration:0.23
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.alpha = 0.0;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show about done!");
                         self.view.hidden = YES;
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
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

- (IBAction)toggleSatellite:(id)sender {
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        [mapController toggleSatellite];
    }
}


- (IBAction)toggleNormal:(id)sender {
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        [mapController toggleNormal];
    }
}

- (IBAction)toggleLabel:(id)sender {
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        [mapController toggleLabel];
        
        [self detectLabelCheckbox];
    }
}

- (void) detectLabelCheckbox
{
    if(_isLabel){
        _isLabel = NO;
        
        UIImage *img = [UIImage imageNamed:@"checkbox.png"];
        [_tickBox setImage:img];
        
        
    } else {
        _isLabel = YES;
        
        UIImage *img = [UIImage imageNamed:@"checkbox_bg.png"];
        [_tickBox setImage:img];
        
    }
}

@end
