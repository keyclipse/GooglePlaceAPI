//
//  GooglePlaceAutoComplete.h
//  Henry
//
//  Created by Samuel Kitono on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GooglePlaceAutoComplete : NSObject{
    NSString * description;
    NSString * reference;
}

@property(nonatomic,copy) NSString * description;
@property(nonatomic,copy) NSString * reference;

-(id) initWithDictionary:(NSDictionary *) dictResult;

@end
