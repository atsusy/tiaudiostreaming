//
//  ComTiaudiostreamingPlayer.m
//  tiaudiostreaming
//
//  Created by KATAOKA,Atsushi on 11/03/14.
//  Copyright 2011 LANGRISE Co.,Ltd. All rights reserved.
//

#import "ComTiaudiostreamingPlayerProxy.h"

@implementation ComTiaudiostreamingPlayerProxy
@synthesize url;
@synthesize idle;
@synthesize waiting;
@synthesize playing;
@synthesize state;
@synthesize errorCode;
@synthesize duration;
@synthesize progress;
@synthesize bitRate;

- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{   
        @synchronized(self)
        {
            if (streamer.duration > 0)
            {
                double currentProgress = streamer.progress;
                if(currentProgress!= lastProgress){
                    lastProgress = currentProgress;
                    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                                           NUMDOUBLE(currentProgress),  @"progress",
                                           NUMDOUBLE(streamer.duration),@"duration",
                                           self,					    @"source",
                                           @"progress",                 @"type",nil];
                    [self fireEvent:@"progress" withObject:event];
                }
            }
        }
	}
}

- (void)stateChanged
{
	NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
						   NUMINT(streamer.state),@"state",
						   self,				  @"source",
						   @"change",			  @"type",nil];
	
	[self fireEvent:@"change" withObject:event];
}

- (void)dealloc
{
	[progressUpdateTimer invalidate];
    [fadeinTimer invalidate];
    [streamer stop];
    
	RELEASE_TO_NIL(url);
	RELEASE_TO_NIL(streamer);
	RELEASE_TO_NIL(progressUpdateTimer);
    RELEASE_TO_NIL(fadeinTimer);
	[super dealloc];	
}
 
- (void)setUrl:(id)value
{
	ENSURE_SINGLE_ARG(value, NSString);
	
	url = [value retain];

	NSString *escapedValue = 
		[(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
															 (CFStringRef)url,
															 NULL,
															 NULL,
															 kCFStringEncodingUTF8) autorelease];
	if([streamer isPlaying]){
		[streamer stop];
	}
	RELEASE_TO_NIL(streamer);
	streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:escapedValue]];
	
	[progressUpdateTimer invalidate];
	RELEASE_TO_NIL(progressUpdateTimer);
    
    [fadeinTimer invalidate];
    RELEASE_TO_NIL(fadeinTimer);

	dispatch_async(dispatch_get_main_queue(), ^{
		progressUpdateTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1
																target:self
															  selector:@selector(updateProgress:)
															  userInfo:nil
															   repeats:YES] retain];
	});
    
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[nc addObserver:self selector:@selector(stateChanged) 
			   name:AS2StatusChangedNotification
			 object:nil];
	
}

- (id)idle
{
	return NUMBOOL([streamer isIdle]);
}

- (id)waiting
{
	return NUMBOOL([streamer isWaiting]);
}

- (id)playing
{
	return NUMBOOL([streamer isPlaying]);
}

- (id)state
{
	return NUMINT([streamer state]);
}

- (id)errorCode
{
	return NUMINT([streamer errorCode]);
}

- (id)duration
{
	return NUMDOUBLE([streamer duration]);
}

- (id)progress
{
	return NUMDOUBLE([streamer progress]);
}

- (id)bitRate
{
	return NUMDOUBLE([streamer bitRate]);
}

#pragma mark -
#pragma mark STATES 

#define STATE(x) MAKE_SYSTEM_PROP(STATE_##x, AS_##x)
STATE(INITIALIZED)
STATE(STARTING_FILE_THREAD)
STATE(WAITING_FOR_DATA)
STATE(FLUSHING_EOF)
STATE(WAITING_FOR_QUEUE_TO_START)
STATE(PLAYING)
STATE(BUFFERING)
STATE(STOPPING)
STATE(STOPPED)
STATE(PAUSED)
//#undef STATE

#pragma mark -
#pragma mark ERRS

#define ERR(x) MAKE_SYSTEM_PROP(ERR_##x, AS_##x)
ERR(NO_ERROR)
ERR(NETWORK_CONNECTION_FAILED)
ERR(FILE_STREAM_GET_PROPERTY_FAILED)
ERR(FILE_STREAM_SEEK_FAILED)
ERR(FILE_STREAM_PARSE_BYTES_FAILED)
ERR(FILE_STREAM_OPEN_FAILED)
ERR(FILE_STREAM_CLOSE_FAILED)
ERR(AUDIO_DATA_NOT_FOUND)
ERR(AUDIO_QUEUE_CREATION_FAILED)
ERR(AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED)
ERR(AUDIO_QUEUE_ENQUEUE_FAILED)
ERR(AUDIO_QUEUE_ADD_LISTENER_FAILED)
ERR(AUDIO_QUEUE_REMOVE_LISTENER_FAILED)
ERR(AUDIO_QUEUE_START_FAILED)
ERR(AUDIO_QUEUE_PAUSE_FAILED)
ERR(AUDIO_QUEUE_BUFFER_MISMATCH)
ERR(AUDIO_QUEUE_DISPOSE_FAILED)
ERR(AUDIO_QUEUE_STOP_FAILED)
ERR(AUDIO_QUEUE_FLUSH_FAILED)
ERR(AUDIO_STREAMER_FAILED)
ERR(GET_AUDIO_TIME_FAILED)
ERR(AUDIO_BUFFER_TOO_SMALL)
//#undef ERR

#pragma mark -
- (void)start:(id)args
{
    @synchronized(self)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [streamer start];
        });
    }
}

- (void)stop:(id)args
{
    @synchronized(self)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [streamer stop];
        });
    }
}

- (void)pause:(id)args
{
    @synchronized(self)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [streamer pause];
        });
    }
}

- (void)seek:(id)args
{
	@synchronized(self)
    {
		ENSURE_SINGLE_ARG(args, NSNumber)
		double newSeekTime = [args doubleValue];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[streamer seekToTime:newSeekTime];
		});
	}
}

- (id)volume
{
    return NUMFLOAT(volume);
}

- (void)setVolume:(NSNumber *)value
{
    volume = [value floatValue];
    [streamer setVolume:volume];
}

- (void)updateVolume:(NSTimer *)timer
{
    volume += 0.01 * (1000 / fadeinDuration);
    [streamer setVolume:pow(volume, 3)];
    if(volume >= 1.0f){
        [timer invalidate];
    }
}

- (void)fadein:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    
    fadeinDuration = 500;
    float value = [arg floatValue];
    if(value > 0.0){
        fadeinDuration = value;
    }
    
    volume = 0.0;
    if(fadeinTimer){
        [fadeinTimer invalidate];
        RELEASE_TO_NIL(fadeinTimer);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        fadeinTimer = [[NSTimer scheduledTimerWithTimeInterval:0.01
                                                        target:self
                                                      selector:@selector(updateVolume:)
                                                      userInfo:nil
                                                       repeats:YES] retain];
    });
}

@end
