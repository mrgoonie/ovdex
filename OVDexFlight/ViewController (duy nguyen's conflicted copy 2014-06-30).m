//
//  ViewController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/14/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "ViewController.h"
#import "MapController.h"

@interface ViewController (){
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    _userTxt.font = [UIFont fontWithName:@"Trim_Web_Medium" size:20];
    _passTxt.font = [UIFont fontWithName:@"Trim_Web_Medium" size:20];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"LoggedInSegue"]) {
        
        MapController *mapController = [segue destinationViewController];
        
        mapController.username = _userTxt.text;
    }
}

- (IBAction)gotoMainPage:(id)sender {
    
}
@end
