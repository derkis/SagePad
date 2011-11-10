//
//  SagePadViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 10/20/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "SagePadViewController.h"

@implementation SagePadViewController
@synthesize touchBeginLabel;
@synthesize touchMovedLabel;
@synthesize touchFinishedLabel;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)handleNewTouch:(CGPoint *)touchCoordinates {
    self.touchBeginLabel.text = [NSString stringWithFormat:@"Began touch at: (%4.0f,%4.0f)", touchCoordinates->x, touchCoordinates->y];
}

- (void)handleMovedTouch:(CGPoint *)touchCoordinates {
    self.touchMovedLabel.text = [NSString stringWithFormat:@"Moved to: (%4.0f,%4.0f)", touchCoordinates->x, touchCoordinates->y];
}

- (void)handleFinishedTouch:(CGPoint *)touchCoordinates {
    self.touchFinishedLabel.text = [NSString stringWithFormat:@"Finished touch at: (%4.0f,%4.0f)", touchCoordinates->x, touchCoordinates->y];
}

- (void)viewDidUnload
{
    [self setTouchBeginLabel:nil];
    [self setTouchMovedLabel:nil];
    [self setTouchFinishedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc {
    [touchBeginLabel release];
    [touchMovedLabel release];
    [touchFinishedLabel release];
    [super dealloc];
}
@end