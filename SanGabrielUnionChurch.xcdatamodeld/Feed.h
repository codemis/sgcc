//
//  Feed.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 4/6/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Feed :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * feedType;
@property (nonatomic, retain) NSDate * publishedOn;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * feedLink;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * podcastGUID;

@end



