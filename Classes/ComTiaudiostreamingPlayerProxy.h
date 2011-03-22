//
//  ComTiaudiostreamingPlayer.h
//  tiaudiostreaming
//
//  Created by KATAOKA,Atsushi on 11/03/14.
//  Copyright 2011 LANGRISE Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TiProxy.h"
#import "TiUtils.h"
#import "AudioStreamer.h"

@interface ComTiaudiostreamingPlayerProxy : TiProxy {
	NSString *url;
	AudioStreamer *streamer;
	double lastProgress;
    float volume;
	NSTimer *progressUpdateTimer;
    NSTimer *fadeinTimer;
    float fadeinDuration;
}
@property (nonatomic, retain) NSString *url;

@property (nonatomic, readonly) NSNumber *idle;
@property (nonatomic, readonly) NSNumber *waiting;
@property (nonatomic, readonly) NSNumber *playing;
@property (nonatomic, readonly) NSNumber *state;
@property (nonatomic, readonly) NSNumber *errorCode;
@property (nonatomic, readonly) NSNumber *duration;
@property (nonatomic, readonly) NSNumber *progress;
@property (nonatomic, readonly) NSNumber *bitRate;
@property (nonatomic, readwrite, assign) NSNumber *volume;

@property (nonatomic, readonly) NSNumber *STATE_INITIALIZED;
@property (nonatomic, readonly) NSNumber *STATE_STARTING_FILE_THREAD;
@property (nonatomic, readonly) NSNumber *STATE_WAITING_FOR_DATA;
@property (nonatomic, readonly) NSNumber *STATE_FLUSHING_EOF;
@property (nonatomic, readonly) NSNumber *STATE_WAITING_FOR_QUEUE_TO_START;
@property (nonatomic, readonly) NSNumber *STATE_PLAYING;
@property (nonatomic, readonly) NSNumber *STATE_BUFFERING;
@property (nonatomic, readonly) NSNumber *STATE_STOPPING;
@property (nonatomic, readonly) NSNumber *STATE_STOPPED;
@property (nonatomic, readonly) NSNumber *STATE_PAUSED;

@property (nonatomic, readonly) NSNumber *ERR_NO_ERROR;
@property (nonatomic, readonly) NSNumber *ERR_NETWORK_CONNECTION_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_FILE_STREAM_GET_PROPERTY_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_FILE_STREAM_SEEK_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_FILE_STREAM_PARSE_BYTES_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_FILE_STREAM_OPEN_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_FILE_STREAM_CLOSE_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_DATA_NOT_FOUND;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_CREATION_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_ENQUEUE_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_ADD_LISTENER_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_REMOVE_LISTENER_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_START_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_PAUSE_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_BUFFER_MISMATCH;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_DISPOSE_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_STOP_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_QUEUE_FLUSH_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_STREAMER_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_GET_AUDIO_TIME_FAILED;
@property (nonatomic, readonly) NSNumber *ERR_AUDIO_BUFFER_TOO_SMALL;

@end
