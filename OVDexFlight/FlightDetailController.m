//
//  FlightDetailController.m
//  OVDexFlight
//
//  Created by Goon on 4/23/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "FlightDetailController.h"
#import "JSONLoader.h"
#import "MapController.h"

@interface FlightDetailController () <JSONLoaderDelegate>
{
    MapController* mapController;
    NSArray * labelArr;
    NSArray * labelArr2;
}

@end

@implementation FlightDetailController

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
    
    _isShow = NO;
    
    [_preloaderIcon startAnimating];
    
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    labelArr = @[_l0, _l1, _l2, _l3, _l4, _l5, _l6, _l7];
    labelArr2 = @[_idTxt, _gufiTxt, _airlineTxt, _dirTxt, _originTxt, _destTxt, _altitudeTxt, _speedTxt];
    
    for (NSInteger i=0; i<labelArr.count; i++) {
        UILabel *label = [labelArr objectAtIndex:i];
        UILabel *label2 = [labelArr2 objectAtIndex:i];
        
        [label setFont:[UIFont fontWithName:@"Trim_Web_Bold" size:15]];
        
        if(i == 0){
            [label2 setFont:[UIFont fontWithName:@"Trim_Web_Light" size:32]];
        } else {
            [label2 setFont:[UIFont fontWithName:@"Trim_Web_Light" size:15]];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData:(NSString*)flightId
{
    //NSURL *url = [NSURL URLWithString:@"http://topane.com/dev/ovdex/flight_detail.txt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://ovdex.solentus.com/Florence/webresources/flights/%@", flightId];
    //NSURL *url = [NSURL URLWithString:urlStr];
    
    [_preloaderPanel setHidden:NO];
    [_preloaderIcon startAnimating];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _preloaderPanel.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         [JSONLoader loadJSON:self
                                      withURL:urlStr
                                  andCallback:@""];
                     }];
    
}

- (void)jsonDidLoad:(NSArray *)dataArr callback:(NSString *)callbackStr
{
    //NSLog(@"-> JSON Loaded: %lu", (unsigned long)dataArr.count);
    //NSLog(@"-> JSON Loaded: %@", dataArr);
    
    if ([callbackStr isEqualToString:@""])
    {
        _idTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"flightIdentification"];
        _gufiTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"gufi"];
        _speedTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"speed"];
        _airlineTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"airline"];
        _dirTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"direction"];
        _destTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"destinationPort"];
        _originTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"originPort"];
        _altitudeTxt.text = [[dataArr objectAtIndex:0] valueForKey:@"altitude"];
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _preloaderPanel.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [_preloaderIcon stopAnimating];
                             [_preloaderPanel setHidden:YES];
                         }];
        
    }
    else
    {
        // or do nothing
    }
}

- (void)jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr
{
    //NSLog(@"-> JSON DATA: %@", dataStr);
    [mapController drawFlightPath:dataStr];
}

- (void)show
{
    _isShow = YES;
    self.view.hidden = NO;
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
    }
    
    NSLog(@"%f", mapController.view.bounds.size.width);
    
    CGRect f1 = self.view.frame;
    f1.origin.x = mapController.view.bounds.size.width - self.view.frame.size.width - 10;
    
    [UIView animateWithDuration:0.6
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = f1;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show done!");
                         
                     }];
}

- (void)hide
{
    _isShow = NO;
    
    [mapController unclickAllMarker];
    
    CGRect frame = self.view.frame;
    frame.origin.x = mapController.view.bounds.size.width;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Hide done!");
                         self.view.hidden = YES;
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
        [mapController clearFlightPath];
    }
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
