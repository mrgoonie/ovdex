//
//  FilterPanelController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/18/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "RegionDropdown.h"
#import "MapController.h"

@interface RegionDropdown (){
    UITapGestureRecognizer *gesture;
    NSArray *regionArr;
    NSArray *menuArr;
    MapController* mapController;
}

@end

@implementation RegionDropdown

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
    menuArr = @[_b0, _b1, _b2, _b3, _b4, _b5, _b6, _b7];
    regionArr = @[@"africa", @"north_america", @"caribbean", @"south_america", @"north_atlantic", @"europe", @"middle_east_asia", @"pacific"];
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
    }
    
    for(int i=0; i<menuArr.count; i++){
        //UIImage * btnActiveImg = [UIImage imageNamed:[_menuActiveImgArr objectAtIndex:(i)]];
        //UIImage * btnNormalImg = [UIImage imageNamed:[_menuNormalImgArr objectAtIndex:(i)]];
        
        UIButton * btn = [menuArr objectAtIndex:(i)];
        
        [btn setTag:i];
        
        //[btn setImage:btnNormalImg forState:UIControlStateNormal];
        //[btn setImage:btnActiveImg forState:UIControlStateHighlighted];
        
        [btn.titleLabel setFont:[UIFont fontWithName:@"Trim_Web_SemiBold" size:13]];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction) btnClick:(id)sender
{
    UIButton *curBtn = sender;
    NSLog(@"id = %ld", (long)curBtn.tag);
    
    NSString *region = [regionArr objectAtIndex:curBtn.tag];

    [mapController showRegion:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
