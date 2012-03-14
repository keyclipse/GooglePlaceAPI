//
//  GooglePlacesAutoComplete.h
//  Henry
//
//  Created by Samuel Kitono on 9/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "GooglePlaceAutoComplete.h"
#import "GooglePlace.h"

#define GOOGLE_API_KEY @"AIzaSyAGJo_zTZ9mKFUKsvgbjyPlJX45D9rUQpU"
@class GooglePlacesAPI;

@protocol GooglePlacesAPIDelegate <NSObject>

//Returniing raw dictionary result
-(void) googlePlacesFinishedAutoCompleteRequest:(GooglePlacesAPI *) googlePlaceAPI withResults:(NSArray *) results; 
-(void) googlePlacesFinishedDetail:(GooglePlacesAPI *)googlePlaceAPI withDetail:(NSDictionary *) dictResult;

//Returning google places object
-(void) googlePlacesFinishedAutoCompleteRequest:(GooglePlacesAPI *) googlePlaceAPI withResultsGooglePlaceAutoComplete:(NSArray *) results; 
-(void) googlePlacesFinishedDetail:(GooglePlacesAPI *)googlePlaceAPI withDetailGooglePlace:(GooglePlace *) googlePlaceResult; 

@end


@interface GooglePlacesAPI : NSObject<ASIHTTPRequestDelegate>{
    id<GooglePlacesAPIDelegate> delegate;
}

@property(nonatomic,assign) id<GooglePlacesAPIDelegate> delegate;

-(void) returnAutoCompletePlacesWithSearchString:(NSString *) inputSearchString;
-(void) getGooglePlaceDetailWithReference:(NSString *) reference;

@end
