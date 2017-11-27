#import "ViewController.h"
#import "ItemBasic.h"
#import "ItemDoubleClick.h"

typedef enum { BALLOON_DEFAULT = 15, TIME_DEFAULT = 60 } defaultSetting;

@interface ViewController () {
    NSMutableArray *settingKeyArray;
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation ViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [[self startButton] setEnabled:NO];
    [self createKeyArray];
    self.currentItem = [[ItemDoubleClick alloc] initWithItemName];
    [self makeFirstSetting];
}

- (void)createKeyArray {
    settingKeyArray = [[NSMutableArray alloc] init];
    [settingKeyArray addObject:@"BalloonNum"];
    [settingKeyArray addObject:@"MaximumMinute"];
}

- (void)makeFirstSetting {
    if (![self isThereDataForKey:BALLOON_NUM]) {
        [self setSettingData:BALLOON_DEFAULT ForKey:BALLOON_NUM];
    }
    if (![self isThereDataForKey:MAXIMUM_MINUTE]) {
        [self setSettingData:TIME_DEFAULT ForKey:MAXIMUM_MINUTE];
    }
}

- (BOOL)isThereDataForKey: (int)keyIndex {
    NSString *tempKey = [settingKeyArray objectAtIndex:keyIndex];
    return [[NSUserDefaults standardUserDefaults] objectForKey:tempKey] != nil;
}

- (void)setSettingData: (int)data ForKey: (int)keyIndex {
    NSString *tempKey = [settingKeyArray objectAtIndex:keyIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:data forKey:tempKey];
}

- (int)getIntValuesForKey: (int)key {
    NSString *tempKey = [settingKeyArray objectAtIndex:key];
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:tempKey];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toSettingView"]) {
        SettingViewController *svc = [segue destinationViewController];
        [svc setSettingKeyArray: settingKeyArray];
    }
    else if ([segue.identifier isEqualToString:@"toGameView"]) {
        GameViewController *gvc = [segue destinationViewController];
        [gvc setPlayerName: self.nameTextField.text];
        [gvc setCurrentItem: self.currentItem];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationItem] setHidesBackButton: YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)editDidChange:(id)sender {
    BOOL isTextEmpty = self.nameTextField.text.length > 0;
    [[self startButton] setEnabled: isTextEmpty];
}

- (IBAction)startGame:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
