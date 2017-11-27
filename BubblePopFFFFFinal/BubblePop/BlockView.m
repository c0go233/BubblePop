#import "BlockView.h"

@implementation BlockView

-(id)initBlockViewWithFrame: (CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setAlpha:0.5];
        [self setBackgroundColor:[UIColor blackColor]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

@end
