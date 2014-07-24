//
//  DATALoader.h
//  OVDexFlight
//
//  Created by Goon Nguyen on 6/24/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DATALoaderDelegate <NSObject, NSURLConnectionDelegate>
@optional
- (void) jsonDidLoad:(NSArray*)dataArr callback:(NSString*)callbackStr;
- (void) jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr;
- (void) jsonDidError;
@end

@interface JSONLoader : NSObject

@property (nonatomic, weak) id <DATALoaderDelegate> delegateView;
@property (weak) NSString *callbackString;

@property (nonatomic, weak) NSString *urlStr;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) NSDictionary * dataDict;

//- (void) loadDataFromURL:(id)object withURL:(NSURL *)url  andCallback:(SEL)responseFunc;
+ (id) loadData:(id<DATALoaderDelegate>)delegate
        withURL:(NSString*)url
    andCallback:(NSString*)callbackStr;

@end
