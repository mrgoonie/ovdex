//
//  FilterTableController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 5/2/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "FilterTableController.h"
#import "MapController.h"
#import "JSONLoader.h"

@interface FilterTableController () <JSONLoaderDelegate>
{
    CGRect pickerRightFrame;
    CGRect pickerLeftFrame;
    CGRect pickerCenterFrame;
    
    NSArray * btnArr;
    NSMutableArray * selectedArr;
    
    UIImage * checkedImg;
    UIImage * uncheckImg;
    
    NSString * initInputAircraft;
    
    MapController * mapController;
}

@end

@implementation FilterTableController

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
    
    // SELECTED TEXT FIELD
    
    _selectedTxt.text = @"Nothing";
    initInputAircraft = _inputAircraftTxt.text;
    
    // CELL SETUP:
    
    checkedImg = [UIImage imageNamed:@"checkbox.png"];
    uncheckImg = [UIImage imageNamed:@"checkbox_bg.png"];
    
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
    //_dropdown.titleLabel.font = [UIFont fontWithName:@"Trim_Web_Bold" size:13];
    
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    // SET INIT PICKER PANEL :
    
    pickerCenterFrame = _panelPicker.frame;
    
    pickerLeftFrame = _panelPicker.frame;
    pickerLeftFrame.origin.x = -pickerLeftFrame.size.width-100;
    
    pickerRightFrame = _panelPicker.frame;
    pickerRightFrame.origin.x = self.view.frame.size.width+500;
    
    [_panelPicker setFrame:pickerRightFrame];
    
    [_inputView setFrame:pickerRightFrame];
    
    // ADD BUTTON ACTION
    
    [_pickerCancelBtn addTarget:self action:@selector(pickerCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickerApplyBtn addTarget:self action:@selector(pickerApplyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputCancelBtn addTarget:self action:@selector(pickerCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_inputApplyBtn addTarget:self action:@selector(pickerApplyClick) forControlEvents:UIControlEventTouchUpInside];
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
    _inputView.frame = pickerRightFrame;
    
    if(_selectedId > -1){
        UIButton *lastBtn = (UIButton*) [btnArr objectAtIndex:_selectedId];
        [lastBtn setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    _selectedId = -1;
    
    _selectedTxt.text = @"Nothing";
    
    _inputAlertTxt.text = @"";
    
    //_dropdown.alpha = 0.5;
    //[_dropdown setUserInteractionEnabled:NO];
}

// TABLE VIEW :

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    /*if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }*/
    
    UILabel *labelTxt = (UILabel *)[cell viewWithTag:2];
    labelTxt.text = [_dataArray objectAtIndex:indexPath.row];
    
    UIButton *checkBtn = (UIButton*)[cell viewWithTag:1];
    checkBtn.titleLabel.text = labelTxt.text;
    checkBtn.titleLabel.hidden = YES;
    [checkBtn setImage:uncheckImg forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSInteger i=0; i<selectedArr.count; i++) {
        NSString *selectStr = [selectedArr objectAtIndex:i];
        
        if ([selectStr isEqualToString:labelTxt.text]) {
            [checkBtn setImage:checkedImg forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

- (void)checkClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if (btn.currentImage == checkedImg) {
        [btn setImage:uncheckImg forState:UIControlStateNormal];
        
        [self removeToSelectedArrayWith:btn.titleLabel.text];
    } else {
        [btn setImage:checkedImg forState:UIControlStateNormal];
        
        [self addToSelectedArrayWith:btn.titleLabel.text];
    }
    
    
}

- (void) addToSelectedArrayWith:(NSString*)str
{
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    
    [selectedArr addObject:str];
    
    for (NSInteger i=0; i<selectedArr.count; i++) {
        NSMutableString *selectStr = [[NSMutableString alloc] initWithString:[selectedArr objectAtIndex:i]];
        
        if(i < selectedArr.count-1){
            [selectStr appendString:@", "];
        }
        
        [displayStr appendString:selectStr];
    }
    
    _selectedTxt.text = displayStr;
}

- (void) removeToSelectedArrayWith:(NSString*)str
{
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    
    [selectedArr removeObject:str];
    
    for (NSInteger i=0; i<selectedArr.count; i++) {
        NSMutableString *selectStr = [[NSMutableString alloc] initWithString:[selectedArr objectAtIndex:i]];
        
        if(i<selectedArr.count-1){
            [selectStr appendString:@", "];
        }
        
        [displayStr appendString:selectStr];
    }
    
    _selectedTxt.text = displayStr;
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

- (void)setupWithArray:(NSArray*)arr
{
    _dataArray = arr;
    
    selectedArr = [[NSMutableArray alloc] init];
    
    [_picker reloadData];
}

- (void) loadData:(NSString*)urlStr
{
    //NSURL *url = [NSURL URLWithString:@"http://topane.com/dev/ovdex/flight_detail.txt"];
    
    //NSString *urlStr = [NSString stringWithFormat:@"http://ovdex.solentus.com/Florence/webresources/flights/%@", flightId];
    //NSURL *url = [NSURL URLWithString:urlStr];
    
    [JSONLoader loadJSON:self
                 withURL:urlStr
             andCallback:@""];
}

- (void)jsonDidLoad:(NSArray *)dataArr callback:(NSString *)callbackStr
{
    //NSLog(@"-> JSON Loaded: %lu", (unsigned long)dataArr.count);
    //NSLog(@"-> JSON Loaded: %@", dataArr);
    
    if ([callbackStr isEqualToString:@""])
    {
        // reload component
        
        [self setupWithArray:dataArr];
        
        [self showPickerPanel];
    }
    else if ([callbackStr isEqualToString:@"filterFlight"])
    {
        //mapController.totalFlight = dataArr.count;
    }
    else
    {
        // or do nothing
    }
}

- (void)jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr
{
    
    NSString *dataNoLineBreak = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    dataNoLineBreak = [dataNoLineBreak stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    
    if ([callbackStr isEqualToString:@""])
    {
        // do nothing
    }
    else if ([callbackStr isEqualToString:@"filterFlight"])
    {
        [self hidePickerPanel];
        [self hide];
        
        //NSLog(@"-> JSON DATA: %@", dataNoLineBreak);
        
        [mapController filterFlight:dataNoLineBreak];
    }
    else
    {
        // or do nothing
    }
}

- (void)filterBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger btnId = btn.tag;
    
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
            NSLog(@"TYPE AIRCRAFT ID");
            [self showAircraftFilter];
            break;
            
        default:
            NSLog(@"No btn id!");
            break;
    }
}

- (void) pickerCancelClick
{
    [self hidePickerPanelAndShowFirstPanel];
}

- (void) pickerApplyClick
{
    // APPLY DATA TO THE MAP...
    
    switch (_selectedId) {
        case 0:
            [self filterFlightByOriginDepart];
            break;
            
        case 1:
            [self filterFlightByAirport];
            break;
            
        case 2:
            [self filterFlightByAirline];
            break;
            
        case 3:
            [self filterFlightByAircraftId];
            break;
            
        default:
            break;
    }
}

- (void) filterFlightByAircraftId
{
    NSString *param = _inputAircraftTxt.text;
    
    NSLog(@"filter aircraft '%@'", param);
    
    if (![param isEqualToString:initInputAircraft])
    {
        [self hide];
        
        _inputAlertTxt.text = @"Filtering...";
        
        [mapController filterFlightByAircraftId:param];
    } else {
        _inputAlertTxt.text = @"Please enter Aircraft ID";
    }
}

- (void) filterFlightByAirline
{
    NSMutableString * param = [[NSMutableString alloc] initWithString:@""];
    
    for (NSInteger i=0; i<selectedArr.count; i++) {
        NSString *selectedStr = [selectedArr objectAtIndex:i];
        //selectedStr = [selectedStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSData *plainData = [selectedStr dataUsingEncoding:NSUTF8StringEncoding];
        selectedStr = [plainData base64EncodedStringWithOptions:0];
        
        [param appendString:selectedStr];
        
        if (i < selectedArr.count-1) {
            [param appendString:@"~"];
        }
    }
    
    NSLog(@"filter param: %@", param);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://ovdex.solentus.com/Florence/webresources/flights/byairlines/%@", param];
    //NSURL *url = [NSURL URLWithString:urlStr];
    
    [JSONLoader loadJSON:self withURL:urlStr andCallback:@"filterFlight"];
}

- (void) filterFlightByAirport
{
    NSMutableString * param = [[NSMutableString alloc] initWithString:@""];
    
    for (NSInteger i=0; i<selectedArr.count; i++) {
        NSString *selectedStr = [selectedArr objectAtIndex:i];
        selectedStr = [selectedStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [param appendString:selectedStr];
        
        if (i < selectedArr.count -1) {
            [param appendString:@"~"];
        }
    }
    
    NSLog(@"filter param: %@", param);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://ovdex.solentus.com/Florence/webresources/flights/byArrivalDepartairports/%@", param];
    //NSURL *url = [NSURL URLWithString:urlStr];
    
    [JSONLoader loadJSON:self withURL:urlStr andCallback:@"filterFlight"];
}

- (void) filterFlightByOriginDepart
{
    NSMutableString * param = [[NSMutableString alloc] initWithString:@""];
    
    for (NSInteger i=0; i<selectedArr.count; i++) {
        NSString *selectedStr = [selectedArr objectAtIndex:i];
        selectedStr = [selectedStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [param appendString:selectedStr];
        
        if (i < selectedArr.count -1) {
            [param appendString:@"~"];
        }
    }
    
    NSLog(@"filter param: %@", param);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://ovdex.solentus.com/Florence/webresources/flights/byairports/%@", param];
    //NSURL *url = [NSURL URLWithString:urlStr];
    
    [JSONLoader loadJSON:self withURL:urlStr andCallback:@"filterFlight"];
}

- (void) showAircraftFilter
{
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _panelHolder.frame = pickerLeftFrame;
                         _inputView.frame = pickerCenterFrame;
                     }
                     completion:^(BOOL finished){
                         //do something?
                     }];
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
                         _inputView.frame = pickerLeftFrame;
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
                         _inputView.frame = pickerRightFrame;
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
