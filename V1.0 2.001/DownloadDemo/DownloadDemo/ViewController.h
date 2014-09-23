//
//  ViewController.h
//  DownloadDemo
//
//  Created by Peter Yuen on 6/26/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnDowning;
@property (weak, nonatomic) IBOutlet UIButton *btnFinish;

- (IBAction)downingClick:(id)sender;
- (IBAction)finishedClick:(id)sender;

@end
