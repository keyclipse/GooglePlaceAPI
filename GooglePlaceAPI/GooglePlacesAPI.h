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

#define GOOGLE_API_KEY @"YOUR_API_KEY"
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
    CLLocationCoordinate2D locationCoordinate;
    float radiusSearch;
    BOOL isUsingBiasRegion;
}

@property(nonatomic) BOOL isUsingBiasRegion;
@property(nonatomic,assign) id<GooglePlacesAPIDelegate> delegate;

-(void) setBiasingWithLocationCoordinate:(CLLocationCoordinate2D) centerCoordinate andRadiusInMeters:(float) radius;
-(void) returnAutoCompletePlacesWithSearchString:(NSString *) inputSearchString;
-(void) getGooglePlaceDetailWithReference:(NSString *) reference;

@end
