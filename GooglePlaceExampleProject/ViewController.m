//
//  ViewController.m
//  GooglePlaceExampleProject
//
//  Created by Samuel Kitono on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    autoCompleteSearchBar.autoCompleteTableView.frame = CGRectMake(0, 44, 320, 460-44-216);
    [self.view addSubview:autoCompleteSearchBar.autoCompleteTableView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [autoCompleteSearchBar release];
    autoCompleteSearchBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [autoCompleteSearchBar release];
    [super dealloc];
}
@end
