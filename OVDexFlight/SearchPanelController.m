//
//  SearchPanelController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/20/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "SearchPanelController.h"
#import "MapController.h"
#import "JSONLoader.h"

@interface SearchPanelController () <JSONLoaderDelegate, UITextFieldDelegate>
{
    MapController* mapController;
    CGRect initFrame;
    CGRect hiddenFrame;
    
    NSInteger curPage;
    NSInteger totalPage;
    NSInteger itemPerPage;
    
    NSArray *sortBtnArr;
    NSMutableArray *sortStatusArr;
    
    NSArray *displayArr;
    NSMutableArray *searchArr;
}

@end

@implementation SearchPanelController

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
    
    itemPerPage = 20;
    curPage = 0;
    totalPage = 0;
    
    _showTxt.text = @"Loading...";
    _pageTxt.text = @"Loading...";
    
    displayArr = @[];
    
    // setup table view :
    
    _dataArr = @[@"item 1", @"item 2",@"item 3", @"item 4",@"item 5",@"item 1", @"item 2",@"item 3", @"item 4",@"item 5",
                 @"item 1", @"item 2",@"item 3", @"item 4",@"item 5",@"item 1", @"item 2",@"item 3", @"item 4",@"item 5"];
    
    [_tableView setUserInteractionEnabled:YES];
    
    [_prevBtn addTarget:self action:@selector(prevClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [_firstBtn addTarget:self action:@selector(firstClick:) forControlEvents:UIControlEventTouchUpInside];
    [_lastBtn addTarget:self action:@selector(lastClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_searchTxt resignFirstResponder];
    [_searchTxt setDelegate:self];
    
    [_resetBtn addTarget:self action:@selector(resetToJSONArray) forControlEvents:UIControlEventTouchUpInside];
    
    // sorting
    
    [self initSorting];
    
    // position setup
    
    _isShow = NO;
    
    CGRect beginFrame = _panelHolder.frame;
    initFrame = beginFrame;
    beginFrame.origin.y = 1024;
    _panelHolder.frame = beginFrame;
    hiddenFrame = _panelHolder.frame;
    
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    //
    
    _preloader.alpha = 1;
    [_preloader startAnimating];
    
    _tableView.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// SORTING

- (void)initSorting
{
    sortBtnArr = @[_s0, _s1, _s2, _s3, _s4];
    sortStatusArr = [[NSMutableArray alloc] initWithArray:@[@"NO", @"NO", @"NO", @"NO", @"NO"]];
    
    for (NSInteger i=0; i<sortBtnArr.count; i++) {
        UIButton *btn = (UIButton*)[sortBtnArr objectAtIndex:i];
        
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)sortClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    NSInteger tag = (NSInteger)btn.tag;
    
    NSSortDescriptor *sort;
    
    NSLog(@"sorting: %ld", (long)btn.tag);
    
    BOOL curStatus;
    
    if([[sortStatusArr objectAtIndex:tag] isEqualToString:@"YES"]){
        curStatus = NO;
    } else {
        curStatus = YES;
    }
    
    if(curStatus){
        [sortStatusArr replaceObjectAtIndex:tag withObject:@"YES"];
    } else {
        [sortStatusArr replaceObjectAtIndex:tag withObject:@"NO"];
    }
    
    switch (btn.tag) {
        case 0:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"gufi" ascending:curStatus];
        break;
        
        case 1:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"acid" ascending:curStatus];
        break;
        
        case 2:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"airlineName" ascending:curStatus];
        break;
        
        case 3:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"originAirport" ascending:curStatus];
        break;
        
        case 4:
            sort = [NSSortDescriptor sortDescriptorWithKey:@"destinationAirport" ascending:curStatus];
        break;
        
        default:
        break;
    }
    
    NSArray *sortedArr = [_dataArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    [self setupWithArray:sortedArr displayPage:curPage];
}

// SEARCH INPUT TEXTFIELD RESPOND:

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_searchTxt)
    {
        NSLog(@"SEARCH KEY: %@", _searchTxt.text);
        
        [self searchKey:_searchTxt.text];
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

// SETUP :

- (void)setupWithArray:(NSArray*)arr displayPage:(NSInteger)page
{
    _dataArr = arr;
    
    if(page){
        curPage = page;
    } else {
        curPage = 0;
    }
    
    totalPage = ceil(_dataArr.count/itemPerPage);
    
    displayArr = [self arrayWithObjectsInPage:curPage];
    
    //NSLog(@"-> TOTAL PAGE: %ld", (long)totalPage);
    
    [_tableView reloadData];
}

- (NSArray*)arrayWithObjectsInPage:(NSInteger)pageId
{
    NSArray *arr = @[];
    
    NSLog(@"PAGE %ld of %ld", (long)pageId, (long)totalPage);
    
    NSInteger firstItemIndex = itemPerPage * pageId;
    NSInteger lastItemIndex = firstItemIndex + itemPerPage;
    
    NSInteger totalRow = itemPerPage;
    
    if (lastItemIndex > _dataArr.count) {
        lastItemIndex = _dataArr.count;
        
        totalRow = lastItemIndex - firstItemIndex;
    }
    
    arr = [_dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(firstItemIndex, totalRow)]];
    
    _pageTxt.text = [NSString stringWithFormat:@"Page %ld of %ld", (long)(curPage+1), (long)(totalPage+1)];
    
    _showTxt.text = [NSString stringWithFormat:@"Showing %ld to %ld of %lu", (long)(firstItemIndex+1), (long)lastItemIndex, (unsigned long)_dataArr.count];
    
    return arr;
}

// SEARCH :

- (void)searchKey:(NSString*)keyword
{
    searchArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i<_jsonDataArr.count; i++) {
        NSString *gufi = [[_jsonDataArr objectAtIndex:i] valueForKey:@"gufi"];
        NSString *aircraft = [[_jsonDataArr objectAtIndex:i] valueForKey:@"acid"];
        NSString *airline = [[_jsonDataArr objectAtIndex:i] valueForKey:@"airlineName"];
        NSString *origin = [[_jsonDataArr objectAtIndex:i] valueForKey:@"originAirport"];
        NSString *destination = [[_jsonDataArr objectAtIndex:i] valueForKey:@"destinationAirport"];
        
        if ([[gufi lowercaseString] rangeOfString:[keyword lowercaseString]].location != NSNotFound) {
            [searchArr addObject:[_jsonDataArr objectAtIndex:i]];
        }
        else // dont have in GUFI > search in AIRCRAFT
        {
            if ([[aircraft lowercaseString] rangeOfString:[keyword lowercaseString]].location != NSNotFound) {
                [searchArr addObject:[_jsonDataArr objectAtIndex:i]];
            }
            else // dont have in AIRCRAFT > search in AIRLINE
            {
                if ([[airline lowercaseString] rangeOfString:[keyword lowercaseString]].location != NSNotFound) {
                    [searchArr addObject:[_jsonDataArr objectAtIndex:i]];
                }
                else // dont have in AIRLINE > search in ORIGIN AIRPORT
                {
                    if ([[origin lowercaseString] rangeOfString:[keyword lowercaseString]].location != NSNotFound) {
                        [searchArr addObject:[_jsonDataArr objectAtIndex:i]];
                    }
                    else // dont have in ORIGIN AIRPORT > search in DESTINATION AIRPORT
                    {
                        if ([[destination lowercaseString] rangeOfString:[keyword lowercaseString]].location != NSNotFound) {
                            [searchArr addObject:[_jsonDataArr objectAtIndex:i]];
                        } // end DESTINATION
                    } // end ORIGIN
                } // end AIRLINE
            } // end AIRCRAFT
        } // end GUFI
    }
    
    NSLog(@"-> Results is %ld", (unsigned long)searchArr.count);
    
    [self setupWithArray:[[NSArray alloc] initWithArray:searchArr] displayPage:0];
}

-(void)resetToJSONArray
{
    [self setupWithArray:_jsonDataArr displayPage:0];
}

// NEXT & PREV

- (void)prevClick:(id)sender
{
    curPage--;
    [self checkPage];
    
    displayArr = [self arrayWithObjectsInPage:curPage];
    
    [_tableView reloadData];
}

- (void)nextClick:(id)sender
{
    curPage++;
    [self checkPage];
    
    displayArr = [self arrayWithObjectsInPage:curPage];
    
    [_tableView reloadData];
}

- (void)firstClick:(id)sender
{
    curPage = 0;
    displayArr = [self arrayWithObjectsInPage:curPage];
    [_tableView reloadData];
}

- (void)lastClick:(id)sender
{
    curPage = totalPage;
    displayArr = [self arrayWithObjectsInPage:curPage];
    [_tableView reloadData];
}

- (void)checkPage
{
    if(curPage<=0) curPage = 0;
    if(curPage>=totalPage) curPage = totalPage;
}

// TABLE VIEW :

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *gufiTxt = (UILabel *)[cell viewWithTag:1];
    gufiTxt.text = [[displayArr objectAtIndex:indexPath.row] valueForKey:@"gufi"];
    
    UILabel *aircraftTxt = (UILabel *)[cell viewWithTag:2];
    aircraftTxt.text = [[displayArr objectAtIndex:indexPath.row] valueForKey:@"acid"];
    
    UILabel *airlineTxt = (UILabel *)[cell viewWithTag:3];
    airlineTxt.text = [[displayArr objectAtIndex:indexPath.row] valueForKey:@"airlineName"];
    
    UILabel *originTxt = (UILabel *)[cell viewWithTag:4];
    originTxt.text = [[displayArr objectAtIndex:indexPath.row] valueForKey:@"originAirport"];
    
    UILabel *destTxt = (UILabel *)[cell viewWithTag:5];
    destTxt.text = [[displayArr objectAtIndex:indexPath.row] valueForKey:@"destinationAirport"];
    
    UIButton *showOnMapBtn = (UIButton *)[cell viewWithTag:6];
    
    [showOnMapBtn setTitle:gufiTxt.text forState:UIControlStateNormal];
    showOnMapBtn.titleLabel.alpha = 0.0;
    
    [showOnMapBtn addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)showOnMap:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"showOnMap by GUFI = %@", btn.titleLabel.text);
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
        
        [mapController showMarkerOnMapByGUFI:btn.titleLabel.text];
        
        [self hide];
    }
}

// JSON

- (void)loadData
{
    //NSURL *url = [NSURL URLWithString:@"http://ovdex.solentus.com/Florence/webresources/flights/tinyobjectlist"];
    [JSONLoader loadJSON:self
                 withURL:@"http://ovdex.solentus.com/Florence/webresources/flights/tinyobjectlist"
             andCallback:@"listLoadComplete"];
}

- (void)jsonDidError
{
    NSLog(@"-> JSON error!");
}

- (void)jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr
{
    //NSLog(@"-> JSON DATA: %@", callbackStr);
    
    NSString *dataNoLineBreak = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    dataNoLineBreak = [dataNoLineBreak stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    
    if ([callbackStr isEqualToString:@"listLoadComplete"])
    {
        
    }
    else if ([callbackStr isEqualToString:@""])
    {
        
    }
    else
    {
        
    }
    
    
}

- (void)jsonDidLoad:(NSArray *)dataArr callback:(NSString *)callbackStr
{
    NSLog(@"-> JSON Loaded: %lu", (unsigned long)dataArr.count);
    //NSLog(@"-> JSON Loaded: %@", dataArr);
    
    if ([callbackStr isEqualToString:@"listLoadComplete"])
    {
        // then do nothing
        
        //NSLog(@"%lu", (unsigned long)_flightDataArr.count);
        
        _jsonDataArr = dataArr;
        
        [self setupWithArray:dataArr displayPage:0];
        
        _preloader.alpha = 0;
        [_preloader stopAnimating];
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _tableView.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    else if ([callbackStr isEqualToString:@""])
    {
        
    }
    else
    {
        
    }
    
    //[self.trackCount setTrack:_totalFlight];
}

-(void) showMapClick:(id)sender
{
    UIButton *btn = sender;
    NSLog(@"Show map [ %ld ] click!", (long)btn.tag);
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
    
    [UIView animateWithDuration:0.6
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _panelHolder.frame = initFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show search done!");
                         [self loadData];
                     }];
}

- (void)hide
{
    _isShow = NO;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _panelHolder.frame = hiddenFrame;
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
