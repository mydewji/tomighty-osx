//
//  Timer.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 24/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "Timer.h"

#define SIXTY_SECONDS 60

@implementation Timer {
    NSTimer *timer;
}

- (id)initWithListener:(id <TimerListener>)aListener {
    self = [super init];
    if (self) {
        _listener = aListener;
    }
    return self;
}

- (void)start:(NSInteger)minutes context:(TimerContext *)aContext {
    _secondsRemaining = minutes * SIXTY_SECONDS;
    _context = aContext;
    [self startTimer];
    [self.listener timerStarted:_secondsRemaining context:_context];
}

- (void)startTimer {
    [timer invalidate];
    timer = [NSTimer timerWithTimeInterval:1.0
            target:self
            selector:@selector(tick:)
            userInfo:nil
            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [timer invalidate];
    timer = nil;
    _context = nil;
    _secondsRemaining = 0;
    [self.listener timerStopped];
}

- (void)tick:(NSTimer *)aTimer {
    _secondsRemaining--;
    if (_secondsRemaining > 0) {
        [self.listener timerTick:_secondsRemaining];
    } else {
        [self finished];
    }
}

- (void)finished {
    TimerContext *context = _context;
    [self stop]; // we must backup context because it will get cleared in stop call
    [self.listener timerFinished:context];
}

@end
