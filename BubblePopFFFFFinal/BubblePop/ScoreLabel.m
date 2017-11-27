#import "ScoreLabel.h"

@interface ScoreLabel() {
    UILabel *addingPointLabel;
}

@end

@implementation ScoreLabel


-(void)displayScore: (int)score {
    [self setText:[NSString stringWithFormat:@"%i", score]];
}

-(void)displayScore: (int)score WithAddingPoint: (int)addingPoint {
    self.text = [NSString stringWithFormat:@"%i", score];
    [self setAddingPointLabel:addingPoint];
    [self animateAddingPoint];
}

-(void)setAddingPointLabel: (int)addingPoint{
    CGRect fr = self.frame;
    fr.origin.x += 20;
    addingPointLabel = [[UILabel alloc] initWithFrame:fr];
    [addingPointLabel setText:[NSString stringWithFormat:@"+%i", addingPoint]];
    addingPointLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)animateAddingPoint {
    [self.superview addSubview:addingPointLabel];
    CGRect frameEnd = CGRectMake(addingPointLabel.frame.origin.x, -30, addingPointLabel.frame.size.width, addingPointLabel.frame.size.height);
    [UILabel animateWithDuration:0.5
                      animations:^(void) { addingPointLabel.frame = frameEnd; addingPointLabel.alpha = 0.0; }
                      completion:^(BOOL finished) { [addingPointLabel removeFromSuperview]; }];
    
}

@end
