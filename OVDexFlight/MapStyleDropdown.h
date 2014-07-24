//
//  MapStyleDropdown.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/18/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapStyleDropdown : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *b0;
@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIImageView *tickBox;
@property (nonatomic, assign) BOOL isLabel;

@property (nonatomic, assign) BOOL isShow;

- (IBAction)toggleSatellite:(id)sender;
- (IBAction)toggleNormal:(id)sender;
- (IBAction)toggleLabel:(id)sender;

- (void)show;
- (void)hide;

@end
