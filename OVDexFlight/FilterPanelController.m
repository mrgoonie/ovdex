//
//  FilterPanelController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/19/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "FilterPanelController.h"
#import "MapController.h"
#import "JSONLoader.h"

@interface FilterPanelController () <JSONLoaderDelegate>
{
    CGRect pickerRightFrame;
    CGRect pickerLeftFrame;
    CGRect pickerCenterFrame;
    NSArray * btnArr;
    MapController * mapController;
}

@end

@implementation FilterPanelController

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
    }
    
    btnArr = @[_b0, _b1, _b2, _b3];
    
    for(NSInteger i=0; i<btnArr.count; i++){
        UIButton * btn = [btnArr objectAtIndex:i];
        
        btn.titleLabel.font = [UIFont fontWithName:@"Trim_Web_Bold" size:13];
        
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.dataArray = @[@"ITEM 1", @"ITEM 2", @"ITEM 3", @"ITEM 4", @"ITEM 5", @"ITEM 6"];
    //self.picker.hidden = YES;
    
    _viewTitle.font = [UIFont fontWithName:@"Trim_Web_Bold" size:35];
    _dropdown.titleLabel.font = [UIFont fontWithName:@"Trim_Web_Bold" size:13];
    
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    // SET INIT PICKER PANEL :
    
    pickerCenterFrame = _panelPicker.frame;
    
    pickerLeftFrame = _panelPicker.frame;
    pickerLeftFrame.origin.x = -pickerLeftFrame.size.width-100;
    
    pickerRightFrame = _panelPicker.frame;
    pickerRightFrame.origin.x = self.view.frame.size.width+500;
    
    [_panelPicker setFrame:pickerRightFrame];
    
    // ADD BUTTON ACTION
    
    [_pickerCancelBtn addTarget:self action:@selector(pickerCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickerApplyBtn addTarget:self action:@selector(pickerApplyClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"FILTER DID APPEAR");
    _panelHolder.frame = pickerCenterFrame;
    _panelPicker.frame = pickerRightFrame;
    
    _selectedId = -1;
    
    _dropdown.alpha = 0.5;
    [_dropdown setUserInteractionEnabled:NO];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.dataArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %lld -> %@", (long long)row, [self.dataArray objectAtIndex:row]);
    _currentItemStr = [self.dataArray objectAtIndex:row];
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

- (void) loadData:(NSString*)urlStr
{
    //NSURL *url = [NSURL URLWithString:@"http://topane.com/dev/ovdex/flight_detail.txt"];
    
    //NSString *urlStr = [NSString stringWithFormat:@"http://ovdex.solentus.com/Florence/webresources/flights/%@", flightId];
    //NSURL *url = [NSURL URLWithString:urlStr];
    [JSONLoader loadJSON:self withURL:urlStr andCallback:@""];
}

- (void)jsonDidLoad:(NSArray *)dataArr callback:(NSString *)callbackStr
{
    //NSLog(@"-> JSON Loaded: %lu", (unsigned long)dataArr.count);
    NSLog(@"-> JSON Loaded: %@", dataArr);
    
    if ([callbackStr isEqualToString:@""])
    {
        self.dataArray = dataArr;
        [_picker selectRow:0 inComponent:0 animated:NO];
        [_picker reloadAllComponents];
    }
    else
    {
        // or do nothing
    }
}

- (void)jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr
{
    //NSLog(@"-> JSON DATA: %@", dataStr);
    
}

- (void)filterBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger btnId = btn.tag;
    NSString *newTitle = [[NSString stringWithFormat:@"TAP TO VIEW %@", btn.titleLabel.text] uppercaseString];
    [_dropdown setTitle:newTitle forState:UIControlStateNormal];
    
    // ENABLE DROPDOWN
    _dropdown.alpha = 1;
    [_dropdown setUserInteractionEnabled:YES];
    
    // ACTIVE NEW BUTTON
    
    _selectedId = btnId;
    
    for(NSInteger i=0; i<btnArr.count; i++){
        UIButton *allBtn = [btnArr objectAtIndex:i];
        
        if(i == btnId){
            [allBtn setTitleColor:[UIColor colorWithRed:25/255.0 green:165/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            [allBtn setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }
    
    // LOAD DATA...
    
    switch (btnId) {
        case 0:
            [self loadData:@"http://ovdex.solentus.com/Florence/webresources/flights/airports"];
        break;
        
        case 1:
            [self loadData:@"http://ovdex.solentus.com/Florence/webresources/flights/allAirports"];
        break;
        
        case 2:
            [self loadData:@"http://ovdex.solentus.com/Florence/webresources/flights/airlines"];
        break;
        
        case 3:
            //[self loadData:@"http://ovdex.solentus.com/Florence/webresources/flights/airlines"];
            NSLog(@"TYPE AIRCRAFT ID");
        break;
        
        default:
            NSLog(@"No btn id!");
        break;
    }
}

/*- (IBAction)departureClick:(id)sender {
    UIButton *btn = sender;
    NSString *newTitle = [[NSString stringWithFormat:@"TAP TO VIEW %@", btn.titleLabel.text] uppercaseString];
    [_dropdown setTitle:newTitle forState:UIControlStateNormal];
    
    self.dataArray = [[NSArray alloc] initWithObjects:@"DEPARTURE 1", @"DEPARTURE 2", @"DEPARTURE 3", @"DEPARTURE 4", @"DEPARTURE 5", nil];
    [_picker selectRow:0 inComponent:0 animated:NO];
    [_picker reloadAllComponents];
}

- (IBAction)airportClick:(id)sender {
    UIButton *btn = sender;
    NSString *newTitle = [[NSString stringWithFormat:@"TAP TO VIEW %@", btn.titleLabel.text] uppercaseString];
    [_dropdown setTitle:newTitle forState:UIControlStateNormal];
    
    self.dataArray = [[NSArray alloc] initWithObjects:@"AIRPORT 1", @"AIRPORT 2", @"AIRPORT 3", @"AIRPORT 4", @"AIRPORT 5", nil];
    [_picker selectRow:0 inComponent:0 animated:NO];
    [_picker reloadAllComponents];
}

- (IBAction)airlineClick:(id)sender {
    UIButton *btn = sender;
    NSString *newTitle = [[NSString stringWithFormat:@"TAP TO VIEW %@", btn.titleLabel.text] uppercaseString];
    [_dropdown setTitle:newTitle forState:UIControlStateNormal];
    
    self.dataArray = [[NSArray alloc] initWithObjects:@"AIRLINE 1", @"AIRLINE 2", @"AIRLINE 3", @"AIRLINE 4", @"AIRLINE 5", nil];
    [_picker selectRow:0 inComponent:0 animated:NO];
    [_picker reloadAllComponents];
}

- (IBAction)aircraftClick:(id)sender {
    UIButton *btn = sender;
    NSString *newTitle = [[NSString stringWithFormat:@"TAP TO VIEW %@", btn.titleLabel.text] uppercaseString];
    [_dropdown setTitle:newTitle forState:UIControlStateNormal];
    
    self.dataArray = [[NSArray alloc] initWithObjects:@"AIRCRAFT 1", @"AIRCRAFT 2", @"AIRCRAFT 3", @"AIRCRAFT 4", @"AIRCRAFT 5", nil];
    [_picker selectRow:0 inComponent:0 animated:NO];
    [_picker reloadAllComponents];
}*/

- (IBAction)dropdownClick:(id)sender {
    //self.picker.hidden = NO;
    
    [self showPickerPanel];
    
}

- (void) pickerCancelClick
{
    [self hidePickerPanelAndShowFirstPanel];
}

- (void) pickerApplyClick
{
    [self hidePickerPanel];
    [self hide];
    
    // APPLY DATA TO THE MAP...
    
    switch (_selectedId) {
        case 0:
        [mapController filterFlight:_currentItemStr];
        break;
        
        case 1:
        [mapController filterFlight:_currentItemStr];
        break;
        
        case 2:
        [mapController filterFlight:_currentItemStr];
        break;
        
        default:
        break;
    }
}

- (void) showPickerPanel
{
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _panelHolder.frame = pickerLeftFrame;
                         _panelPicker.frame = pickerCenterFrame;
                     }
                     completion:^(BOOL finished){
                         //do something?
                     }];
}

- (void) hidePickerPanel
{
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _panelPicker.frame = pickerLeftFrame;
                     }
                     completion:^(BOOL finished){
                         //do something?
                     }];
}

- (void) hidePickerPanelAndShowFirstPanel
{
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _panelHolder.frame = pickerCenterFrame;
                         _panelPicker.frame = pickerRightFrame;
                     }
                     completion:^(BOOL finished){
                         //do something?
                     }];
}

//

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
