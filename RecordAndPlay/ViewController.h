//
//  ViewController.h
//  RecordAndPlay
//
//  Created by Bruno on 10/28/14.
//  Copyright (c) 2014 Bruno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <UIAlertViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *outletRecName;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecordPause;
@property (weak, nonatomic) IBOutlet UIImageView *imgStop;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlay;

@property (weak, nonatomic) IBOutlet UIButton *actionRecordPause;
@property (weak, nonatomic) IBOutlet UIButton *actionStop;
@property (weak, nonatomic) IBOutlet UIButton *actionPlay;

- (IBAction)actionRecordPause:(id)sender;
- (IBAction)actionStop:(id)sender;
- (IBAction)actionPlay:(id)sender;

@end

