//
//  AudioManager.h
//  Yammy
//
//  Created by Alex on 05.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^AudioRecordedCallback)(BOOL status, NSData *audioData, NSTimeInterval durationTime,  NSString *errorMessage);
typedef void(^AudioPlaybackCallback)(NSTimeInterval currentTime, NSTimeInterval durationTime, BOOL status);

@interface AudioManager : NSObject

+ (AudioManager *)sharedManager;

- (void)playAudioFromUrl:(NSString*)urlString withCompletion:(AudioPlaybackCallback)audioPlaybackCallback;

- (void) beginRecordAudio;

- (void) endRecordAudioWithCompletion:(AudioRecordedCallback)audioRecordedCallback;

- (BOOL) isBusy; // record or playing

- (void)requestToMicrophone;

- (BOOL)checkPermision;

- (void)presentAudioSettings;

- (void) stopPlaying;

- (void)stopRecord;

@end

