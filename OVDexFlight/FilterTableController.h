//
//  FilterTableController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 5/2/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isShow;

@property (strong, nonatomic) NSArray *dataArray;

@property (nonatomic, weak) IBOutlet UIView *panelHolder;
@property (strong, nonatomic) IBOutlet UIView *panelPicker;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (nonatomic, weak) IBOutlet UILabel *viewTitle;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIButton *inputCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *inputApplyBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputAircraftTxt;
@property (weak, nonatomic) IBOutlet UILabel *inputAlertTxt;

@property (weak, nonatomic) IBOutlet UIButton *pickerCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickerApplyBtn;
@property (weak, nonatomic) IBOutlet UITextView *selectedTxt;

@property (nonatomic, assign) NSInteger selectedId;

@property (nonatomic, assign) NSString * currentItemStr;

@property (weak, nonatomic) IBOutlet UIButton *b0;
@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (strong, nonatomic) IBOutlet UITableView *picker;

- (void)show;
- (void)hide;

@end
