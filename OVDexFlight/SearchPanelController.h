//
//  SearchPanelController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/20/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPanelController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *panelHolder;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isShow;

@property (weak, nonatomic) IBOutlet UILabel *showTxt;
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *preloader;

// SORT BTNS:

@property (weak, nonatomic) IBOutlet UIButton *s0; // gufi
@property (weak, nonatomic) IBOutlet UIButton *s1; // aircraft id
@property (weak, nonatomic) IBOutlet UIButton *s2; // airline
@property (weak, nonatomic) IBOutlet UIButton *s3; // origin
@property (weak, nonatomic) IBOutlet UIButton *s4; // dest

// Controller buttons:

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UILabel *pageTxt;

// Arrays

@property (nonatomic, strong) NSArray *jsonDataArr;
@property (nonatomic, strong) NSArray *dataArr;

- (void)setupWithArray:(NSArray*)arr displayPage:(NSInteger)page;

- (void)show;
- (void)hide;

@end
