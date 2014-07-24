//
//  AboutPanelController.h
//  OVDexFlight
//
//  Created by Goon on 4/18/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutPanelController : UIViewController
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) IBOutlet UIView *panelHolder;
@property (nonatomic, weak) IBOutlet UILabel *viewTitle;
@property (nonatomic, weak) IBOutlet UITextView *content;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

- (void)show;
- (void)hide;
@end
