//
//  AutoCompleteGooglePlaceSearchBar.h
//  AutoScrollView
//
//  Created by Samuel Kitono on 13/03/12.
//  Copyright (c) 2012 Twenty2 Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GooglePlacesAPI.h"
#import <MapKit/MapKit.h>

@protocol AutoCompleteGooglePlaceSearchBarDelegate <NSObject>

-(void) didSelectGooglePlaceWithCoordinate:(CLLocationCoordinate2D) coord andViewPortSpan:(MKCoordinateSpan) span;

@end

@interface AutoCompleteGooglePlaceSearchBar : UISearchBar<GooglePlacesAPIDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UITableView * autoCompleteTableView;
    NSArray * autoCompleteResultArray;
    NSMutableArray * historySearchArray;
    NSMutableArray * historySearchReferenceArray;
    NSMutableArray * historySearchArrayFiltered;
    NSMutableArray * historySearchReferenceFiltered;
    GooglePlacesAPI * googlePlaces;
    BOOL isFromSelected;
    IBOutlet id<AutoCompleteGooglePlaceSearchBarDelegate> delegateAutoComplete;
}

@property(nonatomic,assign) id<AutoCompleteGooglePlaceSearchBarDelegate> delegateAutoComplete;
@property(nonatomic,retain) UITableView * autoCompleteTableView;
@property(nonatomic,retain) NSArray * autoCompleteResultArray;

@end
