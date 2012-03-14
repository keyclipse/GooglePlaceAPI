//
//  GooglePlace.m
//  Henry
//
//  Created by Samuel Kitono on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GooglePlace.h"

@implementation GooglePlace

@synthesize name,formattedAddress,centerCoordinate,region;

-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        NSDictionary * dictResult = dictionary;
        NSDictionary * dictGeometry = [dictResult objectForKey:@"geometry"];
        NSDictionary * dictLocation = [dictGeometry objectForKey:@"location"];
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[dictLocation objectForKey:@"lat"] floatValue], [[dictLocation objectForKey:@"lng"] floatValue]);
        MKCoordinateSpan  span = MKCoordinateSpanMake(0.005, 0.005);
        NSDictionary * dictViewport = [dictGeometry objectForKey:@"viewport"];
        
        if (dictViewport != nil) {
            NSDictionary * southWest = [dictViewport objectForKey:@"southwest"];
            NSDictionary * northeast = [dictViewport objectForKey:@"northeast"];
            span =  MKCoordinateSpanMake([[northeast objectForKey:@"lat"] floatValue] - [[southWest objectForKey:@"lat"] floatValue], [[northeast objectForKey:@"lng"] floatValue] - [[southWest objectForKey:@"lng"] floatValue]);
        }
        self.centerCoordinate = coord;
        MKCoordinateRegion aregion = MKCoordinateRegionMake(coord, span);
        self.name = [dictResult objectForKey:@"name"];
        self.formattedAddress = [dictResult objectForKey:@"formatted_address"];
        region = aregion;
    }
    return self;
}

-(void) dealloc{
    [name release];
    [formattedAddress release];
    [super dealloc];
}

@end
