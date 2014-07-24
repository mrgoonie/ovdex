//
//  MapController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/14/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import "TrackCount.h"
#import "AboutPanelController.h"
#import "MapStyleDropdown.h"
#import "RegionDropdown.h"
#import "FilterPanelController.h"
#import "SearchPanelController.h"
#import "FlightDetailController.h"
#import "PlaybackViewController.h"
#import "PreloaderViewController.h"
#import "SUA/SuaViewController.h"

@interface MapController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSArray *flightDataArr;
@property (nonatomic, weak) NSTimer *reloadTimer;

// LOGIN :

@property (nonatomic,weak) NSString * username;
@property (weak, nonatomic) IBOutlet UILabel *usernameTxt;

// TRACK COUNT :

@property (assign, nonatomic) NSInteger totalFlight;
@property (assign, nonatomic) NSInteger availableFlight;

// BUTTONS

@property (strong, nonatomic) IBOutlet UIWebView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UIButton *aboutCloseBtn;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

// SUB VIEW CONTROLLERS :

@property (strong, nonatomic) IBOutlet MenuController *menu;
@property (weak, nonatomic) IBOutlet TrackCount *trackCount;
@property (strong, nonatomic) AboutPanelController *aboutPopup;
@property (strong, nonatomic) FilterPanelController *filterPopup;
@property (strong, nonatomic) SearchPanelController *searchPanel;
@property (strong, nonatomic) FlightDetailController *detailPanel;
@property (strong, nonatomic) SuaViewController *suaPanel;
@property (strong, nonatomic) PlaybackViewController *playbackPanel;
@property (strong, nonatomic) PreloaderViewController *preloader;

// MAP STYLE

@property (strong, nonatomic) MapStyleDropdown *mapStylePanel;
@property (nonatomic, strong) IBOutlet UIButton *mapStyleBtn;

- (void) toggleSatellite;
- (void) toggleNormal;
- (void) toggleLabel;

// MAP REGION :

@property (strong, nonatomic) RegionDropdown *regionPanel;
@property (nonatomic, strong) IBOutlet UIButton *regionBtn;

- (void) showRegion: (NSString*)region;

// SIDE MENU
@property (strong, nonatomic) IBOutlet UIButton *b0;
@property (strong, nonatomic) IBOutlet UIButton *b1;
@property (strong, nonatomic) IBOutlet UIButton *b2;
@property (strong, nonatomic) IBOutlet UIButton *b3;
@property (strong, nonatomic) IBOutlet UIButton *b4;
@property (strong, nonatomic) IBOutlet UIButton *b5;
@property (strong, nonatomic) IBOutlet UIButton *b6;
@property (strong, nonatomic) IBOutlet UIButton *b7;
@property (strong, nonatomic) IBOutlet UIButton *b8;

@property NSInteger curActiveId;
@property (strong, nonatomic) NSArray *menuArr;
@property (strong, nonatomic) NSArray *menuActiveImgArr;
@property (strong, nonatomic) NSArray *menuNormalImgArr;

// FLIGHT DETAILS :

- (void)unclickAllMarker;

// SEARCH :

- (void)showMarkerOnMapByGUFI:(NSString*)gufi;

// FILTERS :

@property (nonatomic, assign) BOOL isFiltering;

- (void)filterFlight:(NSString*)str;

- (void)filterFlightByAircraftId:(NSString*)str;

// TOGGLES

@property (nonatomic, assign) BOOL isAirportInstalled;
@property (nonatomic, assign) BOOL isLabel;
@property (nonatomic, assign) BOOL isWeather;
@property (nonatomic, assign) BOOL isTemperature;
@property (nonatomic, assign) BOOL isBoundaries;
@property (nonatomic, assign) BOOL isSAA;
@property (nonatomic, assign) BOOL isAirport;
@property (nonatomic, assign) BOOL isPlayback;

- (IBAction)showSideMenu:(id)sender;
- (IBAction)toggleWeather:(id)sender;
- (IBAction)toggleTemperature:(id)sender;
- (IBAction)toggleAbout:(id)sender;
- (IBAction)menuClick:(id)sender;

- (void)drawFlightPath:(NSString*)jsonData;
- (void)clearFlightPath;

@end
