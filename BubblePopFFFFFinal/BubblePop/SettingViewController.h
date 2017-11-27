//
//  SettingViewController.h
//  BubblePop
//
//  Created by Kisung Tae on 27/04/2016.
//  Copyright © 2016 Kisung Tae. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum { BALLOON_NUM, MAXIMUM_MINUTE }settingKey;


@interface SettingViewController : UIViewController

@property (weak, nonatomic) NSMutableArray *settingKeyArray;
@end
