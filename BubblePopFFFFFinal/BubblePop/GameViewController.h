#import <UIKit/UIKit.h>
#import "Item.h"
#import "ScoreViewController.h"

@interface GameViewController : UIViewController

@property (nonatomic) NSString *playerName;
@property (nonatomic) Item *currentItem;

@end
