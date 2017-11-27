//
//  LaunchingTimerView.m
//  BubblePop
//
//  Created by Kisung Tae on 9/05/2016.
//  Copyright © 2016 Kisung Tae. All rights reserved.
//

#import "LaunchingTimerView.h"


@interface LaunchingTimerView() {
    UILabel *launchingTimerLabel;
}
@end


@implementation LaunchingTimerView

-(id)initWithLabelAndFrame: (CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setLabel];
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.8;
    }
    return self;
}

-(void)setLabel {
    launchingTimerLabel = [[UILabel alloc] init];
    launchingTimerLabel.frame = CGRectMake(0, 0, 10, 10);
    launchingTimerLabel.textAlignment = NSTextAlignmentCenter;
    [launchingTimerLabel setFont: [launchingTimerLabel.font fontWithSize: self.frame.size.width / 8 ]];
}

-(void)updateLanuchingTimerLabel: (NSString*)msg {
    [self addSubview:launchingTimerLabel];
    [launchingTimerLabel setText:msg];
    [launchingTimerLabel sizeToFit];
    launchingTimerLabel.center = self.center;
    launchingTimerLabel.transform = CGAffineTransformIdentity;
    [UILabel animateWithDuration: 0.5
                      animations:^(void) { launchingTimerLabel.transform = CGAffineTransformMakeScale(2.0, 2.0);
                          launchingTimerLabel.alpha = 0.5; }
                      completion:^(BOOL finished) { [launchingTimerLabel removeFromSuperview]; launchingTimerLabel.alpha = 1; } ];

}

@end
