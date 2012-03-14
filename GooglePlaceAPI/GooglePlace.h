//
//  GooglePlace.h
//  Henry
//
//  Created by Samuel Kitono on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GooglePlace : NSObject{
    NSString * name;
    NSString * formattedAddress;
    CLLocationCoordinate2D centerCoordinate;
    MKCoordinateRegion region;
}

-(id) initWithDictionary:(NSDictionary *) dictionary;

@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * formattedAddress;
@property(nonatomic) CLLocationCoordinate2D centerCoordinate;
@property(nonatomic) MKCoordinateRegion region;

@end
