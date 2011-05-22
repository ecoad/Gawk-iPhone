//
//  WallCreateViewController.m
//  Gawk
//
//  Created by Tom Gallacher on 12/05/2011.
//  Copyright 2011 Clock Ltd. All rights reserved.
//

#import "WallCreateViewController.h"


@implementation WallCreateViewController

@synthesize url, wallCreateModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
			wallCreateModel = [[WallCreateModel alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
	[wallCreateModel release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[url becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == url) {
		wallCreateModel.url = url.text;
		wallCreateModel.publicView = [NSNumber numberWithBool:publicToView.on];
		wallCreateModel.publicGawk = [NSNumber numberWithBool:friendsCanGawk.on];
		[wallCreateModel createWall];
	}
	return NO;
}

@end
