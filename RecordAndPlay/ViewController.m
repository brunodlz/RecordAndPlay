//
//  ViewController.m
//  RecordAndPlay
//
//  Created by Bruno on 10/28/14.
//  Copyright (c) 2014 Bruno. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_actionStop setEnabled:NO];
    [_actionPlay setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlay:) name:@"updatePlay" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)actionRecordPause:(id)sender {
    if (recorder.recording) {
        [self playOrStop];
        [self actionStop:nil];
        
        [self setPlayOn];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recording" message:@"Insert name for file" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}

- (IBAction)actionStop:(id)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [_actionRecordPause setEnabled:YES];
    [_actionStop setEnabled:NO];
    
    [self setPlayOn];
}

- (IBAction)actionPlay:(id)sender {
    if (!recorder.recording){
        
        if ([self.outletRecName.text isEqualToString:@""]) {
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
            [player setDelegate:self];
            [player play];
        } else {
            [self replay:self.outletRecName.text];
        }
        
        [self setPlayOn];
    }
}

#pragma mark - Recorder

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [_actionStop setEnabled:NO];
    [_actionPlay setEnabled:YES];
    [_actionRecordPause setEnabled:YES];
    
    [self setPlayOn];
}

#pragma mark - Played

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [_actionRecordPause setEnabled:YES];
    [_actionStop setEnabled:NO];
    [_actionPlay setEnabled:NO];
    
    [self setPlayOff];
}

#pragma mark - Edit name audio

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self setNameRec:[alertView textFieldAtIndex:0].text];
        [self playOrStop];
        
        [_actionStop setEnabled:YES];
        [_actionPlay setEnabled:NO];
        
        [self.imgPlay setImage:[UIImage imageNamed:@"play.png"]];
        self.outletRecName.text = @"";
    }
}

-(void)playOrStop
{
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [self setRecordOn];
        [recorder record];
    } else {
        [self setPlayOn];
        [recorder pause];
    }
}

-(void)setNameRec:(NSString *)nameAudio
{
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               [NSString stringWithFormat:@"%@.caf", nameAudio],
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

-(void)updatePlay:(NSNotification *)userInfo
{
    NSString *fileName = [userInfo.userInfo valueForKey:@"rec"];
    
    self.outletRecName.text = fileName;
    
    [_actionPlay setEnabled:YES];
    [self setPlayOn];
}

- (void) replay:(NSString *)fileName {
    NSString *path = [[NSString stringWithFormat:@"~/Documents/%@", fileName] stringByExpandingTildeInPath];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player play];
}

-(void)setPlayOn
{
    [self.imgPlay setImage:[UIImage imageNamed:@"play_green.png"]];
    [self.imgStop setImage:[UIImage imageNamed:@"stop.png"]];
    [self.imgRecordPause setImage:[UIImage imageNamed:@"record.png"]];
    
}

-(void)setPlayOff
{
    [self.imgPlay setImage:[UIImage imageNamed:@"play.png"]];
    [self.imgStop setImage:[UIImage imageNamed:@"stop.png"]];
    [self.imgRecordPause setImage:[UIImage imageNamed:@"record.png"]];
}

-(void)setRecordOn
{
    [self.imgPlay setImage:[UIImage imageNamed:@"play.png"]];
    [self.imgStop setImage:[UIImage imageNamed:@"stop_red.png"]];
    [self.imgRecordPause setImage:[UIImage imageNamed:@"pause.png"]];
}

@end
