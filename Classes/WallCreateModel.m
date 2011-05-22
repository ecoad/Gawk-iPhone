//
//  WallCreateModel.m
//  Gawk
//
//  Created by Tom Gallacher on 20/05/2011.
//  Copyright 2011 Clock Ltd. All rights reserved.
//

#import "WallCreateModel.h"
#import "ASIFormDataRequest.h"
#import "GawkAppDelegate.h"
#import "JSON.h"

@interface WallCreateModel ()
- (void)createWallFailed:(ASIHTTPRequest *)request;
- (void)createWallFinished:(ASIHTTPRequest *)request;
- (void)createWallStarted;
@end

@implementation WallCreateModel
@synthesize url, description, publicGawk, publicView;

-(void) createWallFailed:(ASIHTTPRequest *)request {
	
}

-(void) createWallFinished:(ASIHTTPRequest *)request {
	NSString *responseData = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
	SBJsonParser *parser = [SBJsonParser new];
  id object = [parser objectWithString:responseData];
  if (object) {
		NSDictionary *errors = [[NSDictionary alloc] initWithDictionary:[object objectForKey:@"errors"]];
		if ([errors count] > 0) {
			NSString *errorMessage = [[[NSString alloc] init] autorelease]; 
			for (id key in errors) {
				errorMessage = [errorMessage stringByAppendingFormat:@"%@\n", [errors objectForKey:key]];
			}
			[self displayErrorMessage:errorMessage];
		}
		[errors release];
	} else {
		[self createWallFailed:request];
	}
	[parser release];
}

-(void) createWallStarted {
}

-(void) createWall {
	NSDictionary *member = [[NSDictionary alloc] initWithDictionary:[self getMember]];
	
	NSString *createWallJSON = [NSString stringWithFormat:@"{\"memberSecureId\": \"%@\", \"url\" : \"%@\", \"description\" : \"\", \"publicView\" : \"%@\", \"publicGawk\": \"%@\" }", [member objectForKey:@"secureId"], url, publicView, publicGawk];
	
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	httpRequest  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:GAWK_API_LOCAITON]];
	[httpRequest setPostValue:@"Wall.Save" forKey:@"Action"];
	[httpRequest setPostValue:[member objectForKey:@"token"] forKey:@"Token"];
	[httpRequest setPostValue:createWallJSON forKey:@"WallData"];
	[httpRequest setTimeOutSeconds:5];
	[httpRequest setDelegate:self];
	[httpRequest setDidFailSelector:@selector(createWallFailed:)];
	[httpRequest setDidFinishSelector:@selector(createWallFinished:)];
	[httpRequest setDidStartSelector:@selector(createWallStarted)];
	[httpRequest startAsynchronous];
	[member release];
}

- (NSDictionary *)getMember {
	return [[[((GawkAppDelegate *)([UIApplication sharedApplication].delegate)) loginView] loginModel] member];
}

- (void) displayErrorMessage: (NSString *) errorMessage {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Validation Error"
																											message:errorMessage
																										 delegate:nil
																						cancelButtonTitle:@"Okay"
																						otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@end
