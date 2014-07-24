//
//  SuaViewController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 6/4/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuaViewController : UIViewController

@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameTxt;
@property (weak, nonatomic) IBOutlet UITextView *noteTxt;
@property (strong, nonatomic) IBOutlet UITableView *schedule;

@property (nonatomic,assign) BOOL isShow;

- (void) show;
- (void) hide;
- (void)loadWithJsonData:(NSString*)jsonData;

@end
