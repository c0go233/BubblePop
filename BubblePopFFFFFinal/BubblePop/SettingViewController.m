
#import "SettingViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *balloonNumberLabel;
@property (weak, nonatomic) IBOutlet UISlider *balloonNumberSlider;
@property (weak, nonatomic) IBOutlet UISlider *maximumtimeSlider;
@property (weak, nonatomic) IBOutlet UILabel *maximumTimeLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self display];
}

-(void)display {
    [self displaySetting:self.balloonNumberSlider andLabel:self.balloonNumberLabel WithKey:BALLOON_NUM];
    [self displaySetting:self.maximumtimeSlider andLabel:self.maximumTimeLabel WithKey:MAXIMUM_MINUTE];
}

- (void)displaySetting: (UISlider*)slider andLabel: (UILabel*)label WithKey: (int)key {
    NSString *tempKey = [_settingKeyArray objectAtIndex:key];
    int data = (int)[[NSUserDefaults standardUserDefaults] integerForKey:tempKey];
    [slider setValue:data];
    [label setText: [NSString stringWithFormat:@"%i", data]];
}

- (IBAction)changeTimeValue:(UISlider*)sender {
    [self updateValuesWithLabel:self.maximumTimeLabel AndData:sender.value AndKey:MAXIMUM_MINUTE];
}

- (IBAction)changeBalloonValue:(UISlider*)sender {
    [self updateValuesWithLabel:self.balloonNumberLabel AndData:sender.value AndKey:BALLOON_NUM];
}

- (void)updateValuesWithLabel: (UILabel*)label AndData: (int)data AndKey: (int)key {
    NSString *tempData = [NSString stringWithFormat:@"%i", data];
    [label setText:tempData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self saveDataToNsUserDefaultsFromLabel:self.balloonNumberLabel WithKey:BALLOON_NUM];
    [self saveDataToNsUserDefaultsFromLabel:self.maximumTimeLabel WithKey:MAXIMUM_MINUTE];
}

- (void)saveDataToNsUserDefaultsFromLabel: (UILabel*)label WithKey: (int) key {
    NSString *tempData = label.text;
    int data = (int)[tempData integerValue];
    NSString *tempKey = [_settingKeyArray objectAtIndex:key];
    [[NSUserDefaults standardUserDefaults] setInteger:data forKey:tempKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
