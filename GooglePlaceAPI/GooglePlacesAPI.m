//
//  GooglePlacesAutoComplete.m
//  Henry
//
//  Created by Samuel Kitono on 9/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GooglePlacesAPI.h"
#import "NSString+SBJSON.h"

@implementation GooglePlacesAPI
@synthesize delegate;

-(void) requestAutoCompleteFinished:(ASIHTTPRequest *) request{
    NSLog(@"Request autocomplete %@",[request responseString]);
    NSArray * predictions = [[[request responseString] JSONValue] objectForKey:@"predictions"];
    
    if ([delegate respondsToSelector:@selector(googlePlacesFinishedAutoCompleteRequest:withResults:)]) {
        [delegate googlePlacesFinishedAutoCompleteRequest:self withResults:predictions];
    }else if([delegate respondsToSelector:@selector(googlePlacesFinishedAutoCompleteRequest:withResultsGooglePlaceAutoComplete:)]){
        NSMutableArray * googlePlaceAutoCompleteArray = [NSMutableArray new];
        
        for (NSDictionary * dictResult in predictions) {
            GooglePlaceAutoComplete * autoComplete = [[GooglePlaceAutoComplete alloc] initWithDictionary:dictResult];
            [googlePlaceAutoCompleteArray addObject:autoComplete];
            [autoComplete release];
        }
        
        [delegate googlePlacesFinishedAutoCompleteRequest:self withResultsGooglePlaceAutoComplete:googlePlaceAutoCompleteArray];
        [googlePlaceAutoCompleteArray release];
    }
}

-(void) requestGooglePlaceDetailFinished:(ASIHTTPRequest *) request{
    NSLog(@"REquest detail is %@",[request responseString]);
    NSDictionary * dictResult = [[[request responseString] JSONValue] objectForKey:@"result"];
    
    if ([delegate respondsToSelector:@selector(googlePlacesFinishedDetail:withDetail:)]) {
        [delegate googlePlacesFinishedDetail:self withDetail:dictResult];
    }else if([delegate respondsToSelector:@selector(googlePlacesFinishedDetail:withDetailGooglePlace:)]){
        GooglePlace * googlePlace = [[GooglePlace alloc] initWithDictionary:dictResult];
        [delegate googlePlacesFinishedDetail:self withDetailGooglePlace:googlePlace];
        [googlePlace release];
    }
    
}

-(void) requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"GOOGLE PLACES REQUEST FAILED with response %@",[request responseString]);
}

-(void) returnAutoCompletePlacesWithSearchString:(NSString *)inputSearchString{
    NSArray * addressArray = [inputSearchString componentsSeparatedByString:@" "];
    
    NSString * searchString = [addressArray objectAtIndex:0];
    
    for (int i = 1; i<[addressArray count]; i++) {
        NSString * string = [addressArray objectAtIndex:i];
        searchString = [NSString stringWithFormat:@"%@+%@",searchString,string];
    }
    //FOR AUSTRALIA ONLY
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&location=-25.88138678,134.784477&radius=2257000&sensor=true&key=%@&",searchString,GOOGLE_API_KEY];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request setDidFinishSelector:@selector(requestAutoCompleteFinished:)];
    [request startAsynchronous];
}


-(void) getGooglePlaceDetailWithReference:(NSString *)reference{

    //FOR AUSTRALIA ONLY    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@",reference,GOOGLE_API_KEY];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request setDidFinishSelector:@selector(requestGooglePlaceDetailFinished:)];
    [request startAsynchronous];
}

@end
