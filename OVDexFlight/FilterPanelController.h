//
//  FilterPanelController.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/19/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterPanelController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) BOOL isShow;

@property (strong, nonatomic) NSArray *dataArray;

@property (nonatomic, weak) IBOutlet UIView *panelHolder;
@property (strong, nonatomic) IBOutlet UIView *panelPicker;
@property (nonatomic, weak) IBOutlet UILabel *viewTitle;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIButton *pickerCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickerApplyBtn;

@property (nonatomic, assign) NSInteger selectedId;

@property (nonatomic, assign) NSString * currentItemStr;

@property (weak, nonatomic) IBOutlet UIButton *b0;
@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIButton *dropdown;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)dropdownClick:(id)sender;

- (void)show;
- (void)hide;


@end
