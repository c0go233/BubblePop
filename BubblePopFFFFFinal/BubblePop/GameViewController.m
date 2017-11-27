#import "GameViewController.h"
#import "ScoreLabel.h"
#import "BlockView.h"
#import "ResultView.h"
#import "BalloonImageView.h"
#import "LaunchingTimerView.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

typedef enum { REDPROB = 40, PINKPROB = 70, GREENPROB = 85, BLUEPROB = 95, BLACKBPROB = 100} balloonProbability;
typedef enum {REDPOINT = 1, PINKPOINT = 2, GREENPOINT = 5, BLUEPOINT = 8, BLACKPOINT = 10} balloonPoints;
typedef enum {RED, PINK, GREEN, BLUE, BLACK} balloonColorIndex;

//I have made the size of bubbles responsive to the main view with formula "balloonLength = main view's size / balloonLengthRatio"
//But since the assignment specification does not clarify basic size of bubbles, I set default ratio to 6
//You can simply change the ratio here 
typedef enum { defaultBalloonLengthRatio = 6, smallerBalloonLengthRatio = 8 } balloonLengthRatio;
const int defaultBalloonNum = 15;
const double bonusMultiplyRatio = 1.5;
const int defaultLaunchingTimerMinute = 3;


@interface GameViewController () {
    const NSMutableDictionary *fileNameArray;
    const NSMutableArray *colorNameArray;
    NSMutableArray *onDisplayBalloonArray;
    NSMutableArray *offDisplayBalloonArray;
    NSTimer *timer;
    NSString *previousBalloonColor;
    BlockView *blockView;
    LaunchingTimerView *launchingTimerView;
    int maxBalloonNumber;
    int timerMinute;
    int launchingTimerMinute;
    int balloonLength;
    int score;
    int highScore;
    BOOL itemFlag;

}

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet ResultView *resultView;
@property (weak, nonatomic) IBOutlet ScoreLabel *scoreLabel;
@property (weak, nonatomic) IBOutlet ScoreLabel *highScoreLabel;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self setArrays];
    [self setItemFlag];
    [self setBalloonLengthOnBalloonNumber];
    [self createBalloons:maxBalloonNumber];
    [self startGame];
}

-(void)setItemFlag {
    if ([[self.currentItem itemName] isEqualToString:@"Basic"]) {
        itemFlag = false;
    }
    itemFlag = true;
}

- (void)setArrays {
    [self setFileNameArray];
    [self setColorNameArray];
    onDisplayBalloonArray = [[NSMutableArray alloc] init];
    offDisplayBalloonArray = [[NSMutableArray alloc] init];
}

-(void)setColorNameArray {
    colorNameArray = [[NSMutableArray alloc] initWithObjects:@"red", @"pink", @"green", @"blue", @"black", nil];
}

- (void)setFileNameArray {
    fileNameArray = [[NSMutableDictionary alloc] init];
    [fileNameArray setValue:@"redBalloon" forKey:@"red"];
    [fileNameArray setValue:@"pinkBalloon" forKey:@"pink"];
    [fileNameArray setValue:@"greenBalloon" forKey:@"green"];
    [fileNameArray setValue:@"blueBalloon" forKey:@"blue"];
    [fileNameArray setValue:@"blackBalloon" forKey:@"black"];
}

-(void)setBalloonLengthOnBalloonNumber {
    maxBalloonNumber = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"BalloonNum"];
    int totalWidth = self.view.bounds.size.width;
    int balloonLengthRatio = defaultBalloonLengthRatio;
    if (maxBalloonNumber > defaultBalloonNum) {
        balloonLengthRatio = smallerBalloonLengthRatio;
    }
    balloonLength = totalWidth / balloonLengthRatio;
}

-(void)createBalloons: (int)amount {
    for (int i = 0; i < amount; i++) {
        BalloonImageView *balloon = [[BalloonImageView alloc] init];
        [self setGuestureRecognizerToView:balloon];
        [offDisplayBalloonArray addObject:balloon];
    }
}

-(void)setGuestureRecognizerToView: (BalloonImageView*)balloon {
    balloon.userInteractionEnabled = YES;
    UIGestureRecognizer *singleTap = [self getTapRecognizerWithTapNumber:1];
    [balloon addGestureRecognizer: singleTap];
}

-(UIGestureRecognizer*)getTapRecognizerWithTapNumber: (int)tapNumber {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(popBalloon:)];
    [tapRecognizer setDelaysTouchesBegan:YES];
    [tapRecognizer setNumberOfTapsRequired:tapNumber];
    return tapRecognizer;
}

-(void)startGame {
    [self setGameBasicSettings];
    [self displayScores];
    [self startLaunchingTimer];
}

-(void)startLaunchingTimer {
    launchingTimerMinute = defaultLaunchingTimerMinute;
    launchingTimerView = [[LaunchingTimerView alloc] initWithLabelAndFrame:self.view.frame];
    [self.view addSubview:launchingTimerView];
    [launchingTimerView updateLanuchingTimerLabel: [NSString stringWithFormat:@"%i", launchingTimerMinute]];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(launchingCountDown) userInfo:nil repeats:YES];
}

-(void)launchingCountDown {
    launchingTimerMinute -= 1;
    if (launchingTimerMinute == 0) {
        [launchingTimerView updateLanuchingTimerLabel:@"Start"];
    }
    else if  (launchingTimerMinute == -1) {
        [timer invalidate];
        [self proceedToGame];
    }
    else  {
    [launchingTimerView updateLanuchingTimerLabel: [NSString stringWithFormat:@"%i", launchingTimerMinute]];
    }
}

-(void)proceedToGame {
    [launchingTimerView removeFromSuperview];
    [self startTimer];
    [self displayRandomBalloons];
}

-(void)setGameBasicSettings {
    timerMinute = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MaximumMinute"];
    highScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"HighestScore"];
    [self.timerLabel setText:[NSString stringWithFormat:@"%i", timerMinute ]];
    score = 0;
    previousBalloonColor = nil;
}

-(void)displayScores {
    [[self scoreLabel] setText:[NSString stringWithFormat:@"%i", score]];
    [[self highScoreLabel] setText:[NSString stringWithFormat:@"%i", highScore]];
}

-(void)displayRandomBalloons {
    int createLimit = (int)[offDisplayBalloonArray count];
    int randomNumForCreation = arc4random_uniform(createLimit + 1);
    if ([onDisplayBalloonArray count] == 0) {
        randomNumForCreation = arc4random_uniform(createLimit) + 1;
    }
    for (int i = 0; i < randomNumForCreation; i++) {
        int randomIndex = arc4random_uniform((int)[offDisplayBalloonArray count]);
        NSLog(@"array index: %i, randomdisplayedIndex: %i", i , randomIndex);
        [self displayBalloon:randomIndex];
    }
}

-(void)displayBalloon: (int)index {
    BalloonImageView *tempBalloon = [offDisplayBalloonArray objectAtIndex:index];
    [offDisplayBalloonArray removeObject:tempBalloon];
    [onDisplayBalloonArray addObject:tempBalloon];
    [self setBalloon:tempBalloon];
    //testTSETSTESTSETES
    UILabel *la = [[UILabel alloc] init];
    la.text = [NSString stringWithFormat:@"%i", index];
    la.frame = CGRectMake(tempBalloon.frame.origin.x, tempBalloon.frame.origin.y, 10, 10);
    [self.view addSubview:tempBalloon];
    [self.view addSubview:la];

    [tempBalloon appearAnimation];
}

-(void)setBalloon: (BalloonImageView*)balloon {
    CGRect frame = [self getFrame];
    NSString *randomColor = [self getRandomColor];
    NSString *balloonImageFileName = [fileNameArray objectForKey: randomColor];
    [balloon setRoundBalloon:frame WithFileName:balloonImageFileName AndColor: randomColor];
}

-(CGRect)getFrame {
    CGPoint newCenterPoint;
    do {
        newCenterPoint = [self getNewCenterPoint];
    } while (newCenterPoint.x == 0 && newCenterPoint.y == 0);
    return [self getCGrectFromCGpoint:newCenterPoint];
}

-(CGPoint)getNewCenterPoint {
    CGPoint newCenterPoint = [self getRandomCenterPoint];
    for (BalloonImageView* currentBalloon in onDisplayBalloonArray) {
        CGPoint currentBalloonCenterPoint = currentBalloon.center;
        BOOL distanceFlag = [self isDistanceBetweenFirstPoint:newCenterPoint AndSecondPoint:currentBalloonCenterPoint InLength:balloonLength];
        if (distanceFlag) {
            return CGPointZero;
        }
    }
    return newCenterPoint;
}

-(CGPoint)getRandomCenterPoint {
    CGFloat newX = [self getRandomCenterPointInSuperview: self.view.bounds.size.width];
    CGFloat newY = [self getRandomCenterPointInSuperview: self.view.bounds.size.height];
    return CGPointMake(newX, newY);
}

-(int)getRandomCenterPointInSuperview: (int)superviewLength {
    int maximumRange = superviewLength - balloonLength;
    int randomNumber = arc4random_uniform(maximumRange + 1);
    return randomNumber + (balloonLength/2);
}

-(BOOL)isDistanceBetweenFirstPoint: (CGPoint)firstPoint AndSecondPoint: (CGPoint)secondPoint InLength:(int) length  {
    CGFloat distance = hypotf(firstPoint.x - secondPoint.x, firstPoint.y - secondPoint.y);
    return distance <= length;
}

-(CGRect)getCGrectFromCGpoint: (CGPoint)cgpoint {
    CGFloat newX = cgpoint.x - (balloonLength / 2.0f);
    CGFloat newY = cgpoint.y - (balloonLength / 2.0f);
    CGRect frame = CGRectMake(newX, newY, balloonLength, balloonLength);
    return frame;
}

-(void)displayOffBalloon: (BalloonImageView*)balloon {
    [offDisplayBalloonArray addObject:balloon];
    [onDisplayBalloonArray removeObject:balloon];
}

-(void)disappearBalloon: (int)index {
    BalloonImageView *balloon = [onDisplayBalloonArray objectAtIndex: index];
    [balloon disappearAnimation];
    [self displayOffBalloon: balloon];
    
}

-(void)disappearClickedBalloon: (int)index {
    BalloonImageView *balloon = [onDisplayBalloonArray objectAtIndex: index];
    [balloon clickDisappearAnimation];
    [self displayOffBalloon:balloon];
}

-(void)popBalloon: (UITapGestureRecognizer*) tapRecognizer {
    CGRect clickedBalloonFrame = [tapRecognizer.view frame];
    BOOL popClickedBalloonFlag = [self popClickedBalloon:tapRecognizer];
    if (popClickedBalloonFlag && itemFlag) {
        [self popItemBalloon:clickedBalloonFrame];
    }
}

-(BOOL)popClickedBalloon: (UITapGestureRecognizer*) tapRecognizer {
    CGPoint touchPoint = [tapRecognizer locationInView: self.view];
    BOOL isInside = [self pointInside:touchPoint View:tapRecognizer.view];
    int clickedBalloonIndex = [self getClickedBalloonIndex:tapRecognizer];
    if(isInside) {
        [self clickPoppingBallons:clickedBalloonIndex];
        return true;
    }
    return false;
}

-(void)popItemBalloon: (CGRect)clickedBalloonFrame {
    NSMutableArray *itemBalloons = [self.currentItem pop:onDisplayBalloonArray WithAniToSuperView:self.view AtFrame:clickedBalloonFrame];
    for (int i = 0; i < [itemBalloons count]; i++) {
        int balloonIndex = (int)[[itemBalloons objectAtIndex:i] integerValue];
        [self clickPoppingBallons:balloonIndex];
        NSLog(@"deleted balloon index: %i", balloonIndex);
    }
}

-(void)clickPoppingBallons: (int)clickedBalloonIndex {
    if (clickedBalloonIndex < [onDisplayBalloonArray count]) {
       [self updateScore: clickedBalloonIndex];
       [self disappearClickedBalloon:clickedBalloonIndex];

    }
}

-(BOOL)pointInside: (CGPoint)point View:(UIView*)currentView {
    CGPoint viewCenterPoint = currentView.center;
    double radius = balloonLength / 2.0;
    return [self isDistanceBetweenFirstPoint: point AndSecondPoint:viewCenterPoint InLength:radius];
}

-(int)getClickedBalloonIndex: (UITapGestureRecognizer*) tapRecognizer {
    BalloonImageView *balloon = (BalloonImageView*)tapRecognizer.view;
    int balloonIndex = (int)[onDisplayBalloonArray indexOfObject:balloon];
    return balloonIndex;
}

-(void)updateScore: (int)clickedBalloonIndex {
    BalloonImageView *current = [onDisplayBalloonArray objectAtIndex:clickedBalloonIndex];
    NSString *currentBalloonColor = current.color;
    int tempAddingPoint = [self getAddingPointForColor:currentBalloonColor];
    score += tempAddingPoint;
    previousBalloonColor = currentBalloonColor;
    [self updateDisplayingScores:tempAddingPoint];
}

-(int)getAddingPointForColor: (NSString*)currentBalloonColor {
    int balloonPoint = [self getBalloonPoint:currentBalloonColor];
    if ([self isMatchWithPreviousBalloon: currentBalloonColor]) {
        double multipleBalloonPoint = balloonPoint * bonusMultiplyRatio;
        balloonPoint = (int)lroundf(multipleBalloonPoint);
    }
    return balloonPoint;
}

-(void)updateDisplayingScores: (int)addingPoint {
    [[self scoreLabel] displayScore:score WithAddingPoint:addingPoint];
    if (score >= highScore) {
        [[self highScoreLabel] displayScore:score WithAddingPoint:addingPoint];
    }
}

-(int)getBalloonPoint: (NSString*)balloonColor {
    if ([balloonColor  isEqual: [colorNameArray objectAtIndex:RED]]) return REDPOINT;
    else if ([balloonColor isEqual:[colorNameArray objectAtIndex:PINK]]) return PINKPOINT;
    else if ([balloonColor isEqual:[colorNameArray objectAtIndex:GREEN]]) return GREENPOINT;
    else if ([balloonColor isEqual:[colorNameArray objectAtIndex:BLUE]]) return BLUEPOINT;
    else return BLACKPOINT;
}

-(BOOL)isMatchWithPreviousBalloon: (NSString*)currentColor {
    return previousBalloonColor == currentColor;
}

-(void)displayOffRandomBalloons {
    int removalLimit = (int)[onDisplayBalloonArray count];
    if (removalLimit != 0) {
    int numForRemoval = arc4random_uniform(removalLimit) + 1;
    for (int i = 0; i < numForRemoval; i++) {
        int randomIndex = arc4random_uniform((int)[onDisplayBalloonArray count]);
        [self disappearBalloon:randomIndex];
    }
  }
}

- (NSString*)getRandomColor {
    int randomNum = arc4random_uniform(100);
    if(randomNum >= 0 && randomNum < REDPROB) return [colorNameArray objectAtIndex:RED];
    else if(randomNum >= REDPROB && randomNum < PINKPROB) return [colorNameArray objectAtIndex:PINK];
    else if(randomNum >= PINKPROB && randomNum < GREENPROB) return [colorNameArray objectAtIndex:GREEN];
    else if(randomNum >= GREENPROB && randomNum < BLUEPROB) return [colorNameArray objectAtIndex:BLUE];
    else return [colorNameArray objectAtIndex:BLACK];
}

-(void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

-(void)countDown {
    timerMinute -= 1;
    [self.timerLabel setText:[NSString stringWithFormat:@"%i", timerMinute]];
    [self refreshBalloons];
     if (timerMinute == 0) {
        [timer invalidate];
        [self stopGame];
    }
}

-(void)refreshBalloons{
    [self displayOffRandomBalloons];
    int previousBalloonMaxIndex = (int)([onDisplayBalloonArray count] - 1);
    [self displayRandomBalloons];
    [self moveUpBalloonsByIndex: previousBalloonMaxIndex];
}

-(void)moveUpBalloonsByIndex: (int)index {
    for (int i = index; i >= 0; i--) {
        if(i < [onDisplayBalloonArray count]) {
           [self disappearMovingUp:i WithTime:timerMinute];
        }
    }
}

-(void)disappearMovingUp: (int)index WithTime: (int)time{
    BalloonImageView *balloon = [onDisplayBalloonArray objectAtIndex: index];
    [balloon moveUpAnimation:time];
    [self displayOffBalloon:balloon];
}

-(void)stopGame {
    blockView = [[BlockView alloc] initBlockViewWithFrame:self.view.frame];
    [self.view addSubview:blockView];
    [self.view addSubview:self.resultView];
    [self.resultView showWithScore: score];
    [self saveScore];
    [self saveHighestScore];
}

-(void)saveHighestScore {
    if (score > highScore) {
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"HighestScore"];
    }
}

-(void)saveScore {
    NSString *gameResult = [NSString stringWithFormat:@"%@, %i\n", self.playerName, score];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *scores = [docPath stringByAppendingPathComponent:@"scores.csv"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:scores]) {
        [[NSFileManager defaultManager] createFileAtPath: scores contents:nil attributes:nil];
    }
    NSFileHandle *filehandler = [NSFileHandle fileHandleForUpdatingAtPath:scores];
    [filehandler seekToEndOfFile];
    [filehandler writeData: [gameResult dataUsingEncoding:NSUTF8StringEncoding]];
    [filehandler closeFile];
    
}

- (IBAction)restart:(id)sender {
    [blockView removeFromSuperview];
    [[self resultView] hide];
    [self resetBalloons];
    [self startGame];
}

-(void)resetBalloons {
    for (int i = ((int)[onDisplayBalloonArray count] - 1); i >= 0; i--) {
        [self disappearBalloon:i];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
