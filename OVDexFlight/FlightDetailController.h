//
//  FlightDetailController.h
//  OVDexFlight
//
//  Created by Goon on 4/23/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightDetailController : UIViewController

// labels

@property (weak, nonatomic) IBOutlet UILabel *l0;
@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UILabel *l3;
@property (weak, nonatomic) IBOutlet UILabel *l4;
@property (weak, nonatomic) IBOutlet UILabel *l5;
@property (weak, nonatomic) IBOutlet UILabel *l6;
@property (weak, nonatomic) IBOutlet UILabel *l7;

@property (weak, nonatomic) IBOutlet UILabel *idTxt;
@property (weak, nonatomic) IBOutlet UILabel *gufiTxt;
@property (weak, nonatomic) IBOutlet UILabel *airlineTxt;
@property (weak, nonatomic) IBOutlet UILabel *dirTxt;
@property (weak, nonatomic) IBOutlet UILabel *originTxt;
@property (weak, nonatomic) IBOutlet UILabel *destTxt;
@property (weak, nonatomic) IBOutlet UILabel *altitudeTxt;
@property (weak, nonatomic) IBOutlet UILabel *speedTxt;

@property (weak, nonatomic) IBOutlet UIView *preloaderPanel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *preloaderIcon;



//

@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,assign) NSString * flightId;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,assign) BOOL isShow;

- (void) loadData:(NSString*)flightId;
- (void) show;
- (void) hide;

@end
