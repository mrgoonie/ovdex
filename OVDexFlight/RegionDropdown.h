//
//  FilterPanelController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/18/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionDropdown : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isShow;
@property (weak, nonatomic) IBOutlet UIButton *b0;
@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIButton *b4;
@property (weak, nonatomic) IBOutlet UIButton *b5;
@property (weak, nonatomic) IBOutlet UIButton *b6;
@property (weak, nonatomic) IBOutlet UIButton *b7;

- (void)show;
- (void)hide;

@end
