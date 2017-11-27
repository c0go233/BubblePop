#import <UIKit/UIKit.h>
#import "BalloonImageView.h"
@interface Item : UIImageView

@property (nonatomic) NSString *itemName;


-(id)initWithItemName;
-(NSMutableArray*)pop: (NSMutableArray*)onDisplayBalloons WithAniToSuperView: (UIView*)superView AtFrame: (CGRect)clickedFrame;
@end
