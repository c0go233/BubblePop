//
//  LaunchingTimerView.h
//  BubblePop
//
//  Created by Kisung Tae on 9/05/2016.
//  Copyright © 2016 Kisung Tae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchingTimerView : UIView

-(id)initWithLabelAndFrame: (CGRect) frame;
-(void)updateLanuchingTimerLabel: (NSString*)msg;
@end
