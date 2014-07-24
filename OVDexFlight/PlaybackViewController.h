//
//  PlaybackViewController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/24/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaybackViewController : UIViewController

@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,assign) NSString * flightId;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIView *step1;
@property (weak, nonatomic) IBOutlet UIView *step2;


@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *hourBtn;
@property (weak, nonatomic) IBOutlet UIButton *minBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn1;

@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *slowBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *fastBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;

@property (nonatomic,assign) BOOL isShow;

- (void) show;
- (void) hide;



@end
