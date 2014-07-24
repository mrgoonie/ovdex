//
//  TrackCount.h
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/16/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCount : UIView

@property (nonatomic,weak) IBOutlet UILabel *trackNumber;
@property (nonatomic,weak) IBOutlet UILabel *trackLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

- (void)viewDidLoad;
- (void)setTrack:(NSInteger)total;
- (void)setAvailableFlight:(NSInteger)current inTotal:(NSInteger)total;

@end
