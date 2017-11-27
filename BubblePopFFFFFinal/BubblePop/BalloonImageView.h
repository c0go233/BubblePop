//
//  BalloonImageView.h
//  BubblePop
//
//  Created by Kisung Tae on 2/05/2016.
//  Copyright © 2016 Kisung Tae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalloonImageView : UIImageView

@property (nonatomic) NSString *color;

-(void)setRoundBalloon: (CGRect)frame WithFileName: (NSString*)fileName AndColor: (NSString*)color;
-(void)appearAnimation;
-(void)disappearAnimation;
-(void)clickDisappearAnimation;
-(void)moveUpAnimation: (int)time;
@end
