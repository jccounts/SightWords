//
//  Word.h
//  SightWordsMD
//
//  Created by J.C. Counts on 5/4/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * soundEdit;
@property (nonatomic, retain) NSData * soundFemale;
@property (nonatomic, retain) NSData * soundMale;

@end
