//
//  ViewController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/14/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "ViewController.h"
#import "MapController.h"
#import "JSONLoader.h"

@interface ViewController () <JSONLoaderDelegate>
{
    JSONLoader *jsonLoader;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }*/
    
    NSLog(@"LOGIN SCREEN");
    
    // prevent screen dimming :
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // add keyboard to login :
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    _userTxt.font = [UIFont fontWithName:@"Trim_Web_Medium" size:20];
    _passTxt.font = [UIFont fontWithName:@"Trim_Web_Medium" size:20];
    
    [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jsonDidError
{
    NSLog(@"-> JSON error!");
}

- (void)jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr
{
    //NSLog(@"-> JSON DATA: %@", dataStr);
    
    NSString *dataNoLineBreak = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    dataNoLineBreak = [dataNoLineBreak stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    
    NSLog(@"-> JSON DATA: %@", dataNoLineBreak);
    
    if ([dataNoLineBreak isEqualToString:@"Success"]) {
        [self gotoMainPage];
    } else {
        _alertTxt.text = dataNoLineBreak;
    }
}

- (void)jsonDidLoad:(NSArray *)dataArr callback:(NSString *)callbackStr
{
    NSLog(@"-> JSON Loaded: %lu", (unsigned long)dataArr.count);
    //NSLog(@"-> JSON Loaded: %@", dataArr);
    
    //[self.trackCount setTrack:_totalFlight];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(200,0,768,1024);
    [UIView commitAnimations];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,768,1024);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginClick
{
    NSLog(@"-> LOGIN CLICK!");
    
    NSString *url = [NSString stringWithFormat:@"http://ovdex.solentus.com/Florence/webresources/ovdexcontroller/login/%@/%@", _userTxt.text, _passTxt.text];
    
    jsonLoader = [JSONLoader loadJSON:self withURL:url andCallback:@"loginInit"];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"LoggedInSegue"]) {
        
        MapController *mapController = [segue destinationViewController];
        
        mapController.username = _userTxt.text;
    }
}

- (IBAction)gotoMainPage
{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}
@end
