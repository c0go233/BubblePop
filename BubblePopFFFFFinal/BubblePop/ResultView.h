//
//  ResultView.h
//  BubblePop
//
//  Created by Kisung Tae on 28/04/2016.
//  Copyright © 2016 Kisung Tae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultView : UIView

@property (nonatomic) BOOL showFlag;


-(void)showWithScore: (int)score;
-(void)hide;

@end
