#import "ResultView.h"

@interface ResultView()

@property (nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ResultView

- (void)showWithScore: (int)score {
    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [self.scoreLabel setText:[NSString stringWithFormat:@"%i", score]];
    [UIView animateWithDuration:0.2
                     animations:^(void){ self.transform = CGAffineTransformMakeScale(1.1, 1.1); self.alpha = 1; }
                     completion:^(BOOL finished) { }];
}

- (void)hide {
    [UIView animateWithDuration:0.2
                     animations:^(void) { self.transform = CGAffineTransformMakeScale(0.1, 0.1); self.alpha = 0; }
                     completion:^(BOOL finished) { [self removeFromSuperview]; } ];
}

@end
