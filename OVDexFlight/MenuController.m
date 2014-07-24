//
//  MenuController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/14/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "MenuController.h"
#import "MapController.h"

@implementation MenuController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"MENU - initWithFrame");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        // Initialization code
        
        //NSLog(@"x = %f and y = %f", self.frame.origin.x, self.frame.origin.y);
    }
    return self;
}

- (void)viewDidLoad
{
    [self initMenu];
}

- (void)initMenu
{
    NSLog(@"initMenu");
    self.isShow = NO;
    
    CGRect hideFrame = self.frame;
    hideFrame.origin.x = -277;
    
    self.frame = hideFrame;
    
    //[self hideMenu];
    self.hidden = YES;
    
}



- (void)showMenu
{
    if(!self.isShow){
        self.isShow = YES;
        
        self.hidden = NO;
        
        CGRect hideFrame = self.frame;
        hideFrame.origin.x = -277;
        
        self.frame = hideFrame;
        
        CGRect showFrame = self.frame;
        showFrame.origin.x = 0;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = showFrame;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Show done!");
                         }];
    }
}

-(void)hideMenu
{
    if(self.isShow){
        self.isShow = NO;
        
        CGRect hideFrame = self.frame;
        hideFrame.origin.x = -277;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = hideFrame;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Hide done!");
                         }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
