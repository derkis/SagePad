//
//  SagePadViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 10/20/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "SagePadViewController.h"
#import "InputTranslator.h"
#import "OutputTranslator.h"
#import "Server.h"
#import "SagePadSettings.h"

@implementation SagePadViewController 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// --- "private" helper methods ---

// setup gesture recognizer for swipe right (to home view)
- (void)addSwipeGestureRecognizer {
    UISwipeGestureRecognizer *twoFingerSwipe = 
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeRight:)];
    twoFingerSwipe.numberOfTouchesRequired = 2;
    [twoFingerSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:twoFingerSwipe];
    [twoFingerSwipe release];
}

// setup gesture recognizer for pinch zoom
- (void)addPinchGestureRecognizer {
    UIPinchGestureRecognizer *pinch =
        [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinch];
    [pinch release];
}

- (void)addLongPressGestureRecognizer {
    UILongPressGestureRecognizer *longPress = 
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLongPress:)];
    [self.view addGestureRecognizer:longPress];
    [longPress release];
}

// initialize and start the networking service
- (void)initNetworkingService {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds); // need to account for status bar...

    SagePadSettings *sagePadSettings = [[SagePadSettings alloc] init];
    InputTranslator *inputTranslator = [[InputTranslator alloc] init];
    OutputTranslator *outputTranslator = [[OutputTranslator alloc] initWithDeviceWidth:width andHeight:height];
    Server *server = [[Server alloc] initWithIp:[sagePadSettings.ipAddress copy]
                                  andPortNumber:[sagePadSettings.portNumber integerValue]];
    networkingService = [[NetworkingService alloc] initWithInputTranslator:inputTranslator 
                                                       andOutputTranslator:outputTranslator
                                                                 andServer:server];
    [sagePadSettings release];
    [inputTranslator release];
    [outputTranslator release];
    [server release];

    [networkingService startServer];
}

// handle touches
- (void)handleTouches:(NSSet *)touches isFirst:(BOOL)isFirst {
    if([touches count] != 1) return;
    CGPoint touchCoordinates = [[touches anyObject] locationInView:self.view];
    [networkingService handleMove:&touchCoordinates isFirst:isFirst];
}

// --- "public" methods ---

// additional setup after loading the view
- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self addSwipeGestureRecognizer];
    [self addPinchGestureRecognizer];
    [self addLongPressGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initNetworkingService];   
}

// method to handle swipe event, direct back to the home view
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)swipeRight {
    [[self navigationController] popViewControllerAnimated:YES];
}

// method to handle pinch event, delegate responsibility to networkingService
- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = [pinch scale];
    switch(pinch.state) {
        case UIGestureRecognizerStateBegan:
            [networkingService handlePinch:&scale isFirst:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [networkingService handlePinch:&scale isFirst:NO];
            break;
        default:
            break;
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    CGPoint touchCoordinates = [longPress locationInView:self.view];
    switch(longPress.state) {
        case UIGestureRecognizerStateBegan:
            [networkingService handlePress:&touchCoordinates];
            break;
        case UIGestureRecognizerStateChanged:
            [networkingService handleDrag:&touchCoordinates];
            break;
        default:
            break;
    }
}

// method to handle touchDown event, delegate responsibility to networkingService
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches isFirst:YES];
}

// method to handle touchMoved and touchUp event, delegate responsibility to networkingService
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches isFirst:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // not sure what to do with cancelled touch, or how a touch is cancelled
}

- (void)viewDidDisappear:(BOOL)animated {
    [networkingService release];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [networkingService stopServer];
    [networkingService release];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [super dealloc];
}

@end
