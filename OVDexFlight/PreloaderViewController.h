//
//  PreloaderViewController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/24/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreloaderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingTxt;
@property (nonatomic,assign) BOOL isShow;

- (void) show;
- (void) hide;

@end
