//
//  MenuController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/14/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuController : UIView

@property (nonatomic, strong) NSArray *menuArr;

@property (nonatomic, assign) BOOL isShow;
- (void)viewDidLoad;
- (void)initMenu;
- (void)showMenu;
- (void)hideMenu;

@end
