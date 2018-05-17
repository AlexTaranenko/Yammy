//
//  AudioManager.m
//  Yammy
//
//  Created by Alex on 05.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AudioManager.h"

@interface AudioManager()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) AVAudioPlayer *player;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AudioManager {
  NSURL *recordFilePath;
  NSURL *playbackFilePath;
  AudioRecordedCallback _currentAudioRecordedCallback;
  AudioPlaybackCallback _currentAudioPlaybackCallback;
  NSString *_recordingError;
}

+ (AudioManager *)sharedManager {
  static AudioManager *manager = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    manager = [[AudioManager alloc] init];
  });
  
  return manager;
}

- (instancetype)init {
  self = [super init];
  
  if (self) {
    [self setupPathComponents];
  }
  
  return self;
}

- (void)requestToMicrophone {
  [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
    if (granted == NO) {
      [UIAlertHelper alert:nil title:@"Запрещена аудиозапись" cancelButton:@"ОК" successButton:@"Настройки" successCompletion:^(UIAlertAction *action) {
        [self presentAudioSettings];
      }];
    }
  }];
}

- (BOOL)checkPermision {
  if ([[AVAudioSession sharedInstance] recordPermission] == AVAudioSessionRecordPermissionGranted) {
    return YES;
  } else {
    return NO;
  }
}

- (void)presentAudioSettings {
  NSURL *urlSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
  if (urlSettings) {
    if ([[UIApplication sharedApplication] canOpenURL:urlSettings]) {
      [[UIApplication sharedApplication] openURL:urlSettings options:@{} completionHandler:nil];
    }
  }
}

- (void)setupPathComponents {
  NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  if(![[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
    NSLog(@"AudioManager setupPathComponents fileExistsAtPath FAILED");
    return;
  }
  
  
  recordFilePath = [NSURL fileURLWithPathComponents:@[docPath, @"Record.aac"]];
  playbackFilePath = [NSURL fileURLWithPathComponents:@[docPath, @"PlayBack.aac"]];
  
  
  // Setup audio session
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
  
  NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
  
  [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
  [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
  [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
  [recordSetting setValue:[NSNumber numberWithInt: AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
  
  NSError *err = nil;
  
  self.recorder = [[AVAudioRecorder alloc] initWithURL:recordFilePath settings:recordSetting error:&err];
  if(err) {
    NSLog(@"AVAudioRecorder ERROR %@", [err localizedDescription]);
  } else {
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    if(![self.recorder prepareToRecord]) {
      NSLog(@"AVAudioRecorder prepareToRecord FAILED");
    }
  }
}

- (void) startRecord {
  _recordingError = nil;
  NSError *audioSessionError;
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setActive:YES error:&audioSessionError];
  if (audioSessionError) {
    _recordingError = [audioSessionError localizedDescription];
  } else {
    [self.recorder recordForDuration:(NSTimeInterval)30];
  }
}

- (void)stopRecord {
  [self.recorder stop];
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  [audioSession setActive:NO error:nil];
}

- (void) stopPlaying {
  [self.player stop];
  self.player = nil;
  [self stopTimer];
}

- (void) stopTimer {
  if(self.timer != nil || [self.timer isValid])
  {
    [self.timer invalidate];
    self.timer = nil;
    _currentAudioPlaybackCallback = nil;
  }
}

- (void) releaseResources {
  if ([self isRecording]) {
    [self stopRecord];
  }
  
  if ([self isPlaying]) {
    [self stopPlaying];
  }
}

- (BOOL) isBusy {
  return [self isPlaying] || [self isRecording];
}

- (BOOL) isPlaying {
  return (self.player != nil && self.player.playing);
}

- (BOOL) isRecording {
  return (self.recorder != nil && self.recorder.recording);
}

- (void)playAudioFromUrl:(NSString*)urlString withCompletion:(AudioPlaybackCallback)audioPlaybackCallback
{
  [self releaseResources];
  
  _currentAudioPlaybackCallback = audioPlaybackCallback;
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSData *soundData = [NSData dataWithContentsOfURL:url];
  [soundData writeToURL:playbackFilePath atomically:YES];
  
  NSError *error;
  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:playbackFilePath error:&error];
  if(error) {
    // TODO: show error alert
    NSLog(@"playAudioFromUrl Error: %@", [error localizedDescription]);
  } else {
    [self.player setDelegate:self];
    [self.player play];
    if(_currentAudioPlaybackCallback)
    {
      self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _currentAudioPlaybackCallback(self.player.currentTime, self.player.duration, NO);
      }];
    }
  }
  
  
  
  
}

- (void) beginRecordAudio {
  [self releaseResources];
  [self startRecord];
}

- (void) endRecordAudioWithCompletion:(AudioRecordedCallback)audioRecordedCallback {
  _currentAudioRecordedCallback = audioRecordedCallback;
  [self stopRecord];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  if(_currentAudioPlaybackCallback)
    _currentAudioPlaybackCallback(self.player.currentTime, self.player.duration, YES);
  
  [self stopTimer];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
  
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
  _recordingError = [error localizedDescription];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
  if (_currentAudioRecordedCallback) {
    if (flag) {
      _currentAudioRecordedCallback(flag, [NSData dataWithContentsOfURL:recordFilePath], recorder.currentTime, nil);
    } else {
      _currentAudioRecordedCallback(flag, nil, 0, _recordingError);
    }
  }
}

@end

