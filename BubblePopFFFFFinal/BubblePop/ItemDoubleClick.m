
#import "ItemDoubleClick.h"

@implementation ItemDoubleClick

-(id)initWithItemName {
    self = [super init];
    if (self) {
        [self setItemName:@"DoubleClick"];
        [self setImage];
    }
    return self;
}

-(void)setImage {
    UIImage *tempImage = [UIImage imageNamed:@"lazer"];
    [self setImage:tempImage];
}

-(NSMutableArray*)pop: (NSMutableArray*)onDisplayBalloons WithAniToSuperView: (UIView*)superView AtFrame: (CGRect)clickedFrame{
    self.frame = CGRectMake(0, clickedFrame.origin.y, superView.frame.size.width, clickedFrame.size.height);

    [superView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^(void) { [self setAlpha:0]; } completion:^(BOOL finished) { [self removeFromSuperview]; [self setAlpha:0.7];}];
    return [self getIntersectBalloons:onDisplayBalloons];
}

-(NSMutableArray*)getIntersectBalloons: (NSMutableArray*)onDisplayBalloons {
    NSMutableArray *ItemBalloons = [[NSMutableArray alloc] init];
    for (int i = 0; i < [onDisplayBalloons count]; i++) {
        BalloonImageView *currentBalloon = [onDisplayBalloons objectAtIndex:i];
        CGRect balloonFrame = currentBalloon.frame;
        if (CGRectIntersectsRect(self.frame, balloonFrame)) {
            [ItemBalloons addObject:[NSString stringWithFormat:@"%i", i]];
            NSLog(@"self Frame : x: %f y: %f", self.frame.origin.x, self.frame.origin.y);
            NSLog(@"index : %i, balloon Frame : x: %f  y: %f",i, balloonFrame.origin.x, balloonFrame.origin.y);
            NSLog(@"balloon length: %f", balloonFrame.size.height);
        }
    }
    return ItemBalloons;
}
 

@end
