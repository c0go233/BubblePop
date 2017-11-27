
#import "BalloonImageView.h"

const double alphaPercent = 0.8;

@implementation BalloonImageView

-(void)setRoundBalloon: (CGRect)frame WithFileName: (NSString*)fileName AndColor:(NSString *)color {
    [self setFrame: frame];
    [self setImageToView: fileName];
    [self setColor:color];
    [self setRoundImageView];
    [self setAlpha:alphaPercent];
}

-(void)setImageToView: (NSString*)fileName {
    UIImage *tempImage = [UIImage imageNamed:fileName];
    [self setImage:tempImage];
}

-(void)setRoundImageView {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
}

-(void)appearAnimation {
    /*
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{     self.transform = CGAffineTransformIdentity;} completion:nil];
     */
}

-(void)disappearAnimation {
    [self removeFromSuperview];
}

-(void)clickDisappearAnimation {
    [UIView animateWithDuration:0.1 animations:^(void){ self.transform = CGAffineTransformMakeScale(3.0, 3.0); [self setAlpha:0.0]; } completion:^(BOOL finished) { [self removeFromSuperview]; self.transform = CGAffineTransformIdentity; }];

}

-(void)moveUpAnimation: (int)time {
    double movingSpeed = 0.5;
    if (time < 5) {
        movingSpeed = time * 0.1;
    }
    CGRect animationFram = CGRectMake(self.frame.origin.x, -60, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration: movingSpeed
                     animations:^(void) { [self setFrame:animationFram]; }
                     completion:^(BOOL finished) { [self removeFromSuperview]; }];
}

@end




