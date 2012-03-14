//
//  GooglePlaceAutoComplete.m
//  Henry
//
//  Created by Samuel Kitono on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GooglePlaceAutoComplete.h"

@implementation GooglePlaceAutoComplete

@synthesize description,reference;

-(id) initWithDictionary:(NSDictionary *)dictResult{
    self = [super init];
    if (self) {
        self.description = [dictResult objectForKey:@"description"];
        self.reference = [dictResult objectForKey:@"reference"];
    }
    return self;
}


-(void) dealloc{
    [description release];
    [reference release];
    [super dealloc];
}

@end
