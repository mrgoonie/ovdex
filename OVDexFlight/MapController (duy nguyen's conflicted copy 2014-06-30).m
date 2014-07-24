//
//  MapController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/14/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "MapController.h"
#import "MenuController.h"
#import "JSONLoader.h"
//#import "AboutPanelController.h"

@interface MapController () <JSONLoaderDelegate, UIWebViewDelegate>
{
    NSString* flightDataStr;
    BOOL firstTime;
    JSONLoader *jsonLoader;
}

@end

@implementation MapController

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
    
    self.view.window.rootViewController = self;
    
    firstTime = YES;
    
    _menuArr = @[_b0, _b1, _b2, _b3, _b4, _b5, _b6, _b7, _b8];
    
    _menuNormalImgArr = @[@"menu_0.png", @"menu_1.png", @"menu_2.png", @"menu_3.png",
                          @"menu_4.png", @"menu_5.png", @"menu_6.png", @"menu_7.png", @"menu_8.png"];
    
    _menuActiveImgArr = @[@"menu_active_0.png", @"menu_active_1.png", @"menu_active_2.png", @"menu_active_3.png",
                          @"menu_active_4.png", @"menu_active_5.png", @"menu_active_6.png", @"menu_active_7.png", @"menu_active_8.png"];
    
    _isFiltering = NO;
    _isLabel = YES;
    _isWeather = NO;
    _isTemperature = NO;
    _isBoundaries = NO;
    _isSAA = NO;
    _isAirport = NO;
    _isPlayback = NO;
    
    _mapView.delegate = self;
    
    // Login :
    
    _usernameTxt.text = [NSString stringWithFormat:@"Welcome %@", _username];
    
    // WEBVIEW :
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html" inDirectory:nil];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [_mapView loadHTMLString:htmlString baseURL:baseURL];
    [_mapView setDelegate:self];
    
    // Init side menu
    
    [self initSideMenu];
    
    // Init about popup
    
    _aboutPopup = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutPanel"];
    
    // Init filter popup
    
    _filterPopup = [self.storyboard instantiateViewControllerWithIdentifier:@"filterPanel"];
    
    // Init detail popup
    
    _detailPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"flightDetail"];
    
    // Init sua panel
    
    _suaPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"suaDetail"];
    
    // Init playback popup
    
    _playbackPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"playbackPanel"];
    
    // Init track count
    
    [self.trackCount viewDidLoad];
    
    // Init preloader
    
    _preloader = [self.storyboard instantiateViewControllerWithIdentifier:@"Preloader"];
    
    [self showPreloader];
    
}

- (void)onTimerReload
{
    if(!self.searchPanel.isShow
       && !self.aboutPopup.isShow
       && !self.filterPopup.isShow
       && !self.playbackPanel.isShow
       && !self.menu.isShow
       && !self.detailPanel.isShow
       && !self.isFiltering)
    {
        NSLog(@"RELOADING DATA....");
        
        [self showPreloader];
        
        [self performSelector:@selector(loadMapData) withObject:self afterDelay:0.7];
        //[self loadMapData];
    } else {
        NSLog(@"Some panel is showing. No need to reload data.");
    }
}

- (void)loadMapData
{
    //NSURL *url = [NSURL URLWithString:@"http://ovdex.solentus.com/Florence/webresources/flights/"];
    //[JSONLoader loadJSON:self withURL:url andCallback:@"flightList"];
    
    NSString *url = @"http://ovdex.solentus.com/Florence/webresources/flights/";
    
    jsonLoader = [JSONLoader loadJSON:self withURL:url andCallback:@"flightList"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *urlStr = [url absoluteString];
    
    //NSLog(@"%@", urlStr);
    
    if ([urlStr hasPrefix:@"too:openMarkerDetail"]) {
        NSArray* data = [urlStr componentsSeparatedByString: @":"];
        NSString* flightId = [data objectAtIndex:2];
        
        [self openMarkerDetail:flightId];
        return YES;
    }

    if ([urlStr hasPrefix:@"too:updateAvailableMarker"]) {
        NSArray* data = [urlStr componentsSeparatedByString: @":"];
        _availableFlight = [[data objectAtIndex:2] intValue];

        //NSLog(@"available marker is: %ld", (long)availableFlight);
        
        [self.trackCount setAvailableFlight:_availableFlight inTotal:_totalFlight];
        
        return YES;
    }
    
    if ([urlStr hasPrefix:@"too:openSuaDetail"]) {
        //NSLog(@"%@",[urlStr substringFromIndex:18]);
        NSString *data = [[urlStr substringFromIndex:18] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        data = [data stringByReplacingOccurrencesOfString:@"/" withString:@"\\"];
        //NSLog(@"%@",data);
        [self openSuaDetail:data];
    }
    
    if ([urlStr hasPrefix:@"too:openAirportDetail"]) {
        NSArray * data = [urlStr componentsSeparatedByString: @":"];
        NSString * airportName = [[data objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * shortName = [[data objectAtIndex:3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self openAirportDetail:airportName withInShort:shortName];
        return YES;
    }
    
    if ([urlStr hasPrefix:@"too:alertMessage"]) {
        NSArray * data = [urlStr componentsSeparatedByString: @":"];
        NSString * msg = [[data objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self showAlert:@"ALERT" msg:msg];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //webViewDidFinishLoadBool = YES;
    
    // Load data:
    
    //NSURL *url = [NSURL URLWithString:@"http://ovdex.solentus.com/Florence/webresources/flights/"];
    //NSURL *url = [NSURL URLWithString:@"http://topane.com/dev/ovdex/flight_data.txt"];
    //[JSONLoader loadJSON:self withURL:url andCallback:@"flightList"];
    
    [self loadMapData];
}

- (void)jsonDidError
{
    NSLog(@"-> JSON error!");
}

- (void)jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr
{
    NSLog(@"-> JSON DATA: %@", callbackStr);
    
    NSString *dataNoLineBreak = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    dataNoLineBreak = [dataNoLineBreak stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    
    if ([callbackStr isEqualToString:@"flightList"])
    {
        flightDataStr = dataNoLineBreak;
        
        // then install markers :
        
        NSString *jsMethod = [NSString stringWithFormat:@"installMarkers('%@')", flightDataStr];
        
        [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
        
        if (_preloader.isShow) {
            [self hidePreloader];
        }
        
        // Start Reload Timer
        
        if (firstTime) {
            firstTime = NO;
            _reloadTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                                            target: self
                                                          selector: @selector(onTimerReload)
                                                          userInfo: nil
                                                           repeats: YES];
        }
        
        // START LOAD AIRPORTS..
        
        if(!self.isAirportInstalled){
            _isAirportInstalled = YES;
            [self loadAirport];
        }
    }
    else if ([callbackStr isEqualToString:@"airportLoadComplete"])
    {
        //NSString *dataNoLineBreak = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        //[dataNoLineBreak stringByReplacingOccurrencesOfString:[NSCharacterSet newlineCharacterSet] withString:@" "];
        
        //dataNoLineBreak = [dataNoLineBreak stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSString *jsMethod = [NSString stringWithFormat:@"installAirport('%@')", dataNoLineBreak];
        
        //NSLog(@"-> JS METHOD: installAirport('%@')", dataNoLineBreak);
        //NSLog(@"-> JS METHOD: %@", dataNoLineBreak);
        
        [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
    }
    else
    {
        
    }
    
    
}

- (void)jsonDidLoad:(NSArray *)dataArr callback:(NSString *)callbackStr
{
    NSLog(@"-> JSON Loaded: %lu", (unsigned long)dataArr.count);
    //NSLog(@"-> JSON Loaded: %@", dataArr);
    
    if ([callbackStr isEqualToString:@"flightList"])
    {
        _flightDataArr = dataArr;
        _totalFlight = dataArr.count;
        // then do nothing
        
        //NSLog(@"%lu", (unsigned long)_flightDataArr.count);
    }
    else if ([callbackStr isEqualToString:@"airportLoadComplete"])
    {
        
    }
    else
    {
        
    }
    
    //[self.trackCount setTrack:_totalFlight];
}

- (void)openSuaDetail:(NSString*)data
{
    //NSLog(@"%@", data);
    
    [self addChildViewController:_suaPanel];
    [self.view addSubview:_suaPanel.view];
    
    CGRect frame = _suaPanel.view.frame;
    frame.origin.x = self.view.bounds.size.width;
    frame.origin.y = 10;
    frame.size.width = 278;
    frame.size.height = 490;
    _suaPanel.view.frame = frame;
    
    [_suaPanel didMoveToParentViewController:self];
    
    [_suaPanel show];
    [_suaPanel loadWithJsonData:data];
}

- (void)openMarkerDetail:(NSString*)flightId
{
    NSLog(@"OPEN MARKER DETAIL: %@", flightId);
    
    [self addChildViewController:_detailPanel];
    [self.view addSubview:_detailPanel.view];
    
    CGRect frame = _detailPanel.view.frame;
    frame.origin.x = self.view.bounds.size.width;
    frame.origin.y = 10;
    frame.size.width = 278;
    frame.size.height = 490;
    _detailPanel.view.frame = frame;
    
    [_detailPanel didMoveToParentViewController:self];
    
    [_detailPanel show];
    [_detailPanel loadData:flightId];
}

- (void)openAirportDetail:(NSString*)airportName withInShort:(NSString*)shortname
{
    NSString *displayStr = [NSString stringWithFormat:@"%@\n(%@)", airportName, shortname];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"AIRPORT"
                                                      message:displayStr
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

-(void) showAlert:(NSString*)title msg:(NSString*)msgStr
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:msgStr
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

- (void)unclickAllMarker
{
    NSString *jsMethod = @"unclickAllMarkers()";
    
    [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
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

//

- (void)initSideMenu
{
    [_menu viewDidLoad];
    
    _curActiveId = -1;
    
    for(NSInteger i=0; i<_menuActiveImgArr.count; i++){
        UIImage * btnActiveImg = [UIImage imageNamed:[_menuActiveImgArr objectAtIndex:(i)]];
        UIImage * btnNormalImg = [UIImage imageNamed:[_menuNormalImgArr objectAtIndex:(i)]];
        
        UIButton * btn = [_menuArr objectAtIndex:(i)];
        
        [btn setTag:i];
        
        [btn setImage:btnNormalImg forState:UIControlStateNormal];
        [btn setImage:btnActiveImg forState:UIControlStateHighlighted];
    }
    
    [_mapStyleBtn addTarget:self action:@selector(mapStyleClick) forControlEvents:UIControlEventTouchUpInside];
    [_regionBtn addTarget:self action:@selector(regionClick) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)showSideMenu:(id)sender {
    NSLog(@"Menu isShow = %d", self.menu.isShow);
    if(self.menu.isShow){
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

- (void) mapStyleClick
{
    NSLog(@"MAP STYLE CLICK");
    
    if (_regionPanel.isShow) [_regionPanel hide];
    
    _mapStylePanel = [self.storyboard instantiateViewControllerWithIdentifier:@"MapStyleDropdown"];
    
    [self addChildViewController:_mapStylePanel];
    [self.view addSubview:_mapStylePanel.view];
    //_mapStylePanel.view.frame = self.view.bounds;
    
    CGRect frame = _mapStylePanel.view.frame;
    frame.origin.x = 264;
    frame.origin.y = 643;
    frame.size.width = 254;
    frame.size.height = 88;
    _mapStylePanel.view.frame = frame;
    
    [_mapStylePanel didMoveToParentViewController:self];
    
    [_mapStylePanel show];
}

- (void) regionClick
{
    NSLog(@"REGION SELECTION CLICK");
    
    if (_mapStylePanel.isShow) [_mapStylePanel hide];
    
    _regionPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"RegionDropdown"];
    
    [self addChildViewController:_regionPanel];
    [self.view addSubview:_regionPanel.view];
    //_mapStylePanel.view.frame = self.view.bounds;
    
    CGRect frame = _regionPanel.view.frame;
    frame.origin.x = 264;
    frame.origin.y = 545;
    frame.size.width = 255;
    frame.size.height = 175;
    _regionPanel.view.frame = frame;
    
    [_regionPanel didMoveToParentViewController:self];
    
    [_regionPanel show];
}

- (void) searchClick
{
    [self hideMenu];
    
    _searchPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"searchPanel"];
    
    [self addChildViewController:_searchPanel];
    [self.view addSubview:_searchPanel.view];
    _searchPanel.view.frame = self.view.bounds;
    
    [_searchPanel didMoveToParentViewController:self];
    
    [_searchPanel show];
    
    //NSLog(@"Flight data array: %lu", (unsigned long)_flightDataArr.count);
    
    //[_searchPanel setupWithArray:_flightDataArr];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        
        //NSLog(@"added failure requirement to: %@", otherGestureRecognizer);
    }
    
    return YES;
}

- (void)drawFlightPath:(NSString*)jsonData
{
    NSString *dataNoLineBreak = [jsonData stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSString *jsMethod = [NSString stringWithFormat:@"showFlightPath('%@')", dataNoLineBreak];
    
    //NSLog(@"-> JS METHOD: %@", jsMethod);
    
    [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
}

- (void)clearFlightPath
{
    NSString *jsMethod = @"hideFlightPath()";
    
    //NSLog(@"-> JS METHOD: %@", jsMethod);
    
    [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
}

// AIRPORT

- (void)loadAirport
{
    //NSURL *url = [NSURL URLWithString:@"http://ovdex.solentus.com/quercus/ovdex/fljson/majorairports.json"];
    //NSURL *url = [NSURL URLWithString:@"http://topane.com/dev/ovdex/airport.txt"];
    //[JSONLoader loadJSON:self withURL:url andCallback:@"airportLoadComplete"];
    
    /*jsonLoader = [JSONLoader loadJSON:self
                              withURL:@"http://topane.com/dev/ovdex/airport.txt"
                          andCallback:@"airportLoadComplete"];*/
    
    NSLog(@"Loading AIRPORT");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"airport" ofType:@"txt"];
    
    [JSONLoader loadJSONfromFile:self fileName:filePath andCallback:@"airportLoadComplete"];
}

// FILTER :

- (void)filterFlight:(NSString*)str
{
    _isFiltering = YES;
    
    [_reloadTimer invalidate];
    
    NSString *jsMethod = [NSString stringWithFormat:@"filterFlights('%@')", str];
    
    NSLog(@"-> JS METHOD: %@", jsMethod);
    
    [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
}

- (void)filterFlightByAircraftId:(NSString*)str
{
    _isFiltering = YES;
    
    [_reloadTimer invalidate];
    
    NSString *jsMethod = [NSString stringWithFormat:@"filterFlightByAircraftId('%@')", str];
    
    //NSLog(@"-> JS METHOD: %@", jsMethod);
    
    [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
}

// TOGGLES :

- (void)toggleSatellite {
    NSLog(@"-> Toggle satellite!");
    [self.mapView stringByEvaluatingJavaScriptFromString:@"showMapHybrid()"];
}

- (void)toggleNormal {
    NSLog(@"-> Toggle normal!");
    [self.mapView stringByEvaluatingJavaScriptFromString:@"showMapNormal()"];
}

- (void)toggleLabel
{
    if(_isLabel){
        _isLabel = NO;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideCountryLabel()"];
    } else {
        _isLabel = YES;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"showCountryLabel()"];
    }
}

- (IBAction)toggleWeather:(id)sender {
    if(_isWeather){
        _isWeather = NO;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideWeather()"];
    } else {
        _isWeather = YES;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"showWeather()"];
    }
}

- (IBAction)toggleTemperature:(id)sender {
    if(_isTemperature){
        _isTemperature = NO;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideTempature()"];
    } else {
        _isTemperature = YES;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"showTemperature()"];
    }
}

- (IBAction)toggleAbout:(id)sender {
    if(!_aboutPopup.isShow){
        [self showAbout];
    } else {
        [self hideAbout];
    }
}

-(void) showAbout
{
    [self hideMenu];
    
    [self addChildViewController:_aboutPopup];
    [self.view addSubview:_aboutPopup.view];
    _aboutPopup.view.frame = self.view.bounds;
    [_aboutPopup didMoveToParentViewController:self];
    
    [_aboutPopup show];
}

-(void) hideAbout
{
    [self hideMenu];
    [_aboutPopup hide];
}

- (IBAction)menuClick:(id)sender {
    UIButton *curTarget = (UIButton*)sender;
    
    // HIDE SUB MENUS
    
    if (_regionPanel.isShow) [_regionPanel hide];
    if (_mapStylePanel.isShow) [_mapStylePanel hide];
    
    if(_curActiveId != curTarget.tag){
        _curActiveId = curTarget.tag;
        
        // REACTIVE SPECIAL BUTTONS :
        
        if(_curActiveId != 8 && _curActiveId != 2 && _curActiveId != 0 && _curActiveId != 1){
            UIImage * btnActiveImg = [UIImage imageNamed:[_menuActiveImgArr objectAtIndex:_curActiveId]];
            [curTarget setImage:btnActiveImg forState:UIControlStateNormal];
        }
        
        // ACTIVE BUTTONS :
        
        for(NSInteger i=0; i<_menuArr.count; i++){
            if(i != _curActiveId){
                UIImage * btnNormalImg = [UIImage imageNamed:[_menuNormalImgArr objectAtIndex:(i)]];
                UIButton * btn = [_menuArr objectAtIndex:i];
                
                [btn setImage:btnNormalImg forState:UIControlStateNormal];
            }
        }
    } else {
        _curActiveId = -1;
        UIImage * btnActiveImg = [UIImage imageNamed:[_menuNormalImgArr objectAtIndex:curTarget.tag]];
        [curTarget setImage:btnActiveImg forState:UIControlStateNormal];
    }
    
    // SWITCH TOGGLE :
    
    switch (curTarget.tag) {
        case 0:
            [self resetMap];
            break;
        case 1:
            //[self togglePlayback];
            [self showAlert:@"PLAYBACK" msg:@"COMING SOON"];
            break;
            
        case 2:
            [self showFilter];
            break;
        
        case 4:
            [self toggleAirport];
            break;
            
        case 3:
            [self toggleBoundaries];
            break;
            
        case 5:
            [self toogleSAA];
            break;
            
        default:
            break;
    }
}

- (void)resetMap
{
    NSLog(@"-> RESET MAP!!!");
    
    [_reloadTimer invalidate];
    
    _isFiltering = NO;
    _isLabel = YES;
    _isWeather = NO;
    _isTemperature = NO;
    _isBoundaries = NO;
    _isSAA = NO;
    _isAirport = NO;
    _isPlayback = NO;
    
    firstTime = YES;
    
    [self hideMenu];
    
    if(_playbackPanel.isShow) [_playbackPanel hide];
    
    if(_filterPopup.isShow) [_filterPopup hide];
    
    if (_detailPanel.isShow) {
        [self.detailPanel hide];
    }
    
    [self.mapView stringByEvaluatingJavaScriptFromString:@"resetMap()"];
    
    //
    
    [self showPreloader];
    
    [self performSelector:@selector(loadMapData) withObject:self afterDelay:0.5];
}

- (void)showMarkerOnMapByGUFI:(NSString*)gufi
{
    NSString *jsMethod = [NSString stringWithFormat:@"showFlightOnMapByGUFI('%@')", gufi];
    NSLog(@"JS Method: %@", jsMethod);
    [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
}

- (void)togglePlayback
{
    if(_isPlayback){
        _isPlayback = NO;
        
        [_playbackPanel hide];
    } else {
        _isPlayback = YES;
        
        [self hideMenu];
        
        [self addChildViewController:_playbackPanel];
        [self.view addSubview:_playbackPanel.view];
        
        CGRect frame = _playbackPanel.view.frame;
        frame.size.width = 420;
        frame.size.height = 162;
        frame.origin.x = (self.view.bounds.size.width - frame.size.width)/2;
        frame.origin.y = self.view.bounds.size.height;
        _playbackPanel.view.frame = frame;
        
        [_playbackPanel didMoveToParentViewController:self];
        
        [_playbackPanel show];
    }
}

- (void)showFilter
{
    [self hideMenu];
    
    NSLog(@"-> SHOW FILTER PANEL");
    [self addChildViewController:_filterPopup];
    [self.view addSubview:_filterPopup.view];
    _filterPopup.view.frame = self.view.bounds;
    [_filterPopup didMoveToParentViewController:self];
    
    [_filterPopup show];
}

- (void)toggleAirport
{
    if(_isAirport){
        _isAirport = NO;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideAirport()"];
    } else {
        _isAirport = YES;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"showAirport()"];
    }
}

- (void)toggleBoundaries
{
    if(_isSAA){
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideSAA()"];
        _isSAA = NO;
    }
    
    if(_isBoundaries){
        _isBoundaries = NO;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideBoundaries()"];
    } else {
        _isBoundaries = YES;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"showBoundaries()"];
    }
}

- (void)toogleSAA
{
    if(_isBoundaries){
        _isBoundaries = NO;
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideBoundaries()"];
    }
    
    if(_isSAA){
        _isSAA = NO;
        NSLog(@"hideSUA");
        [self.mapView stringByEvaluatingJavaScriptFromString:@"hideSUA()"];
    } else {
        _isSAA = YES;
        NSLog(@"showSUA");
        [self.mapView stringByEvaluatingJavaScriptFromString:@"showSUA()"];
    }
}

- (void) showRegion: (NSString*)region
{
    
    NSString *jsMethod = [NSString stringWithFormat:@"showRegionByName('%@')", region];
    NSLog(@"JS Method: %@", jsMethod);
    [self.mapView stringByEvaluatingJavaScriptFromString:jsMethod];
}

// PRELOADER

- (void)showPreloader
{
    [_preloader willMoveToParentViewController:self];
    [self addChildViewController:_preloader];
    [self.view addSubview:_preloader.view];
    
    CGRect f = _preloader.view.frame;
    f.size.width = 1024;
    f.size.height = 768;
    _preloader.view.frame = f;
    
    [_preloader didMoveToParentViewController:self];
    [_preloader show];
}

- (void)hidePreloader
{
    [_preloader hide];
}

// MENU

- (void)showMenu
{
    [self.menu showMenu];
    
    CGRect newMenuFrame = self.menuBtn.frame;
    newMenuFrame.origin.x = 277 + 20;
    
    CGRect newMapFrame = self.mapView.frame;
    newMapFrame.origin.x = 277;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.menuBtn.frame = newMenuFrame;
                         self.mapView.frame = newMapFrame;
                     }
                     completion:^(BOOL finished){
                         //somecode...
                     }];
}

- (void)hideMenu
{
    [self.menu hideMenu];
    
    CGRect newMenuFrame = self.menuBtn.frame;
    newMenuFrame.origin.x = 20;
    
    CGRect newMapFrame = self.mapView.frame;
    newMapFrame.origin.x = 0;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.menuBtn.frame = newMenuFrame;
                         self.mapView.frame = newMapFrame;
                     }
                     completion:^(BOOL finished){
                         //somecode...
                     }];
}

@end
