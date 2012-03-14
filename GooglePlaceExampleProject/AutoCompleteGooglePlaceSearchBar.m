//
//  AutoCompleteGooglePlaceSearchBar.m
//  AutoScrollView
//
//  Created by Samuel Kitono on 13/03/12.
//  Copyright (c) 2012 Twenty2 Digital. All rights reserved.
//

#import "AutoCompleteGooglePlaceSearchBar.h"
#import "GooglePlace.h"
#import "GooglePlaceAutoComplete.h"


@implementation AutoCompleteGooglePlaceSearchBar
@synthesize autoCompleteTableView,autoCompleteResultArray,delegateAutoComplete;

-(void) initialise{
    self.delegate = self;
    googlePlaces = [GooglePlacesAPI new];
    googlePlaces.delegate = self;
    historySearchArray = [NSMutableArray new];
    historySearchReferenceArray = [NSMutableArray new];
    historySearchArrayFiltered = [NSMutableArray new];
    historySearchReferenceFiltered = [NSMutableArray new];
    self.autoCompleteTableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] autorelease];
    autoCompleteTableView.delegate = self;
    autoCompleteTableView.dataSource = self;
    autoCompleteTableView.hidden = YES;
}

-(id) init{
    self = [super init];
    if (self) {
        [self initialise];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialise];
    }
    return self;
}

#pragma mark SearchBar delegate
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (isFromSelected) {
        isFromSelected = NO;
        return;
    }
    NSString * newString = searchText;
    //if ([newString length] > 3) {
    [googlePlaces returnAutoCompletePlacesWithSearchString:newString];
    //}
    
    [historySearchArrayFiltered removeAllObjects];
    [historySearchReferenceFiltered removeAllObjects];
    
    self.autoCompleteResultArray = nil;
    
    
    for (int i = 0; i < [historySearchArray count]; i++) {
        NSString * historyString = [historySearchArray objectAtIndex:i];
        NSRange range;
        range = [[historyString lowercaseString] rangeOfString:newString];
        if (range.location != NSNotFound) {
            [historySearchArrayFiltered addObject:historyString];
            [historySearchReferenceFiltered addObject:[historySearchReferenceArray objectAtIndex:i]];
        }
    }
     
    
    [autoCompleteTableView reloadData];
}

#pragma mark Tableview delegate

-(void) addToHistoryName:(NSString *) historyName andReference:(NSString *) historyReference{
    
    //Check if it is in history list
    for (NSString * name in historySearchArray) {
        if ([name isEqualToString:historyName]) {
            return;
        }
    }
    
    //if not then add
    [historySearchArray addObject:historyName];
    [historySearchReferenceArray addObject:historyReference];
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isFromSelected = YES;
    if (indexPath.row < [historySearchArrayFiltered count]) {
        [googlePlaces getGooglePlaceDetailWithReference:[historySearchReferenceFiltered objectAtIndex:indexPath.row]];
        [self setText:[historySearchArrayFiltered objectAtIndex:indexPath.row]];
    }else{
        GooglePlaceAutoComplete * googlePlaceAutoComplete = [autoCompleteResultArray objectAtIndex:(indexPath.row - [historySearchArrayFiltered count])];
        [googlePlaces getGooglePlaceDetailWithReference:googlePlaceAutoComplete.reference];
        [self addToHistoryName: googlePlaceAutoComplete.description andReference:googlePlaceAutoComplete.reference];
        self.text = googlePlaceAutoComplete.description;
    }
    [self resignFirstResponder];
    [autoCompleteTableView setHidden:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark tableview datasource
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==autoCompleteTableView) {
        int autocompletecount = [autoCompleteResultArray count] + [historySearchArrayFiltered count];
        if (autocompletecount == 0) {
            autoCompleteTableView.hidden = YES;
        }else{
            autoCompleteTableView.hidden = NO;
        }
        return autocompletecount;
    }
    
    /*
    if (tableView==alertTableView) {
        return [autoCompleteResultArray count];
    }
     */
    
    return 0;
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSString *) getFormatAddressFromDict:(NSDictionary *) dictResult{
    return [dictResult objectForKey:@"formatted_address"];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.minimumFontSize = 9;
    }
    
    if (tableView == autoCompleteTableView) {
        if (indexPath.row < [historySearchArrayFiltered count]) {
            cell.textLabel.text = [historySearchArrayFiltered objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = @"History";
        }else{
            GooglePlaceAutoComplete *googeAutoComplete = [autoCompleteResultArray objectAtIndex:indexPath.row-[historySearchArrayFiltered count]] ;
            cell.textLabel.text = googeAutoComplete.description;
        }
    }
    
    
    
    return cell;
}

#pragma mark Google Places API delegate
/*
-(void) googlePlacesFinishedAutoCompleteRequest:(GooglePlacesAPI *)googlePlaceAPI withResults:(NSArray *)results{
    self.autoCompleteResultArray = results;
    [autoCompleteTableView reloadData];
}

-(void) googlePlacesFinishedDetail:(GooglePlacesAPI *)googlePlaceAPI withDetail:(NSDictionary *)dictResult{
    NSDictionary * dictGeometry = [dictResult objectForKey:@"geometry"];
    NSDictionary * dictLocation = [dictGeometry objectForKey:@"location"];
    
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[dictLocation objectForKey:@"lat"] floatValue], [[dictLocation objectForKey:@"lng"] floatValue]);
    //CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(5, 5);
    MKCoordinateSpan  span = MKCoordinateSpanMake(0.005, 0.005);
    NSDictionary * dictViewport = [dictGeometry objectForKey:@"viewport"];
    
    if (dictViewport != nil) {
        NSDictionary * southWest = [dictViewport objectForKey:@"southwest"];
        NSDictionary * northeast = [dictViewport objectForKey:@"northeast"];
        span =  MKCoordinateSpanMake([[northeast objectForKey:@"lat"] floatValue] - [[southWest objectForKey:@"lat"] floatValue], [[northeast objectForKey:@"lng"] floatValue] - [[southWest objectForKey:@"lng"] floatValue]);
    }
    
    [delegateAutoComplete didSelectGooglePlaceWithCoordinate:coord andViewPortSpan:span];
    
}
 */


-(void) googlePlacesFinishedAutoCompleteRequest:(GooglePlacesAPI *)googlePlaceAPI withResultsGooglePlaceAutoComplete:(NSArray *)results{
    self.autoCompleteResultArray = results;
    [autoCompleteTableView reloadData];
}

-(void) googlePlacesFinishedDetail:(GooglePlacesAPI *)googlePlaceAPI withDetailGooglePlace:(GooglePlace *)resultGooglePlace{
    [delegateAutoComplete didSelectGooglePlaceWithCoordinate:resultGooglePlace.centerCoordinate andViewPortSpan:resultGooglePlace.region.span];
}

-(void) dealloc{
    [autoCompleteResultArray release];
    [googlePlaces release];
    [autoCompleteTableView release];
    [historySearchReferenceFiltered release];
    [historySearchArrayFiltered release];
    [historySearchReferenceArray release];
    [historySearchArray release];
    [super dealloc];
}

@end
