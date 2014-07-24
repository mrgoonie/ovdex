//
//  SuaViewController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 6/4/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "SuaViewController.h"
#import "MapController.h"

@interface SuaViewController ()
{
    MapController* mapController;
}

@end

@implementation SuaViewController

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
    
    _isShow = NO;
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
    }
    
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    self.dataArray = @[@"ITEM 1", @"ITEM 2", @"ITEM 3", @"ITEM 4", @"ITEM 5", @"ITEM 6"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TABLE VIEW :

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"total items: %i", [_dataArray count]);
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    UILabel *startDateTxt = (UILabel *)[cell viewWithTag:1];
    UILabel *endDateTxt = (UILabel *)[cell viewWithTag:2];
    UILabel *dayTxt = (UILabel *)[cell viewWithTag:3];
    UILabel *startTimeTxt = (UILabel *)[cell viewWithTag:4];
    UILabel *endTimeTxt = (UILabel *)[cell viewWithTag:5];
    
    startDateTxt.text   = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"startDate"];
    endDateTxt.text     = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"endDate"];
    dayTxt.text         = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"day"];
    startTimeTxt.text   = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"startTime"];
    endTimeTxt.text     = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"endTime"];
    
    return cell;
}

- (void)setupWithArray:(NSArray*)arr
{
    _dataArray = arr;
    
    [_schedule reloadData];
}

- (void)loadWithJsonData:(NSString*)jsonData
{
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    /*NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                         options: NSJSONReadingMutableContainers
                                                           error: &e];*/
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    
    NSLog(@"%@",jsonData);
    NSLog(@"SCHEDULE : %@", [array valueForKey:@"schedule"]);
    
    [self setupWithArray:[array valueForKey:@"schedule"]];
    
    //
    
    _nameTxt.text = [array valueForKey:@"name"];
    _noteTxt.text = [array valueForKey:@"note"];
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
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
    }
    
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
    
    //[mapController unclickAllMarker];
    
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
}

@end
