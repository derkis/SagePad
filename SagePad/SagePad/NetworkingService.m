//
//  NetworkingService.m
//  SagePad
//
//  Created by Matthew Cobb on 11/23/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "NetworkingService.h"
#import "Server.h"
#import "InputTranslator.h"
#import "OutputTranslator.h"
#import "SagePadSettings.h"

@implementation NetworkingService

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator
         withOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator {
    
    self = [super init];
    if (self) {
        SagePadSettings *sagePadSettings = [[SagePadSettings alloc] init];
        server = [[Server alloc] initWithIp:[sagePadSettings.ipAddress copy]
                              andPortNumber:[sagePadSettings.portNumber integerValue]];
        [sagePadSettings release];
        
        inputTranslator = _inputTranslator;
        outputTranslator = _outputTranslator;
        
    }
    
    return self;
}

- (void)dealloc {
    [server release];    
    [super dealloc];
}

- (void)startServer {
    NSLog(@"StartingServer");
    [server start]; 
}

- (void)stopServer {
    [server stop];
}


- (void)translatePinchEvent:(CGFloat *)scalef isFirst:(BOOL)first {
    if(first) [outputTranslator translatePinchEvent:scalef isFirst:YES];
    else [outputTranslator translatePinchEvent:scalef isFirst:NO];
}

- (void)translateTouchEvent:(CGPoint *)coordinates isFirst:(BOOL)first {
    if(first) [outputTranslator translateTouchEvent:coordinates isFirst:YES];
    else [outputTranslator translateTouchEvent:coordinates isFirst:NO];
}


@end
