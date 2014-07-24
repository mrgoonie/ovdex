//
//  JSONLoader.h
//  OVDexFlight
//
//  Created by Goon on 4/21/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONLoaderDelegate <NSObject, NSURLConnectionDelegate>
@optional
- (void) jsonDidLoad:(NSArray*)dataArr callback:(NSString*)callbackStr;
- (void) jsonDidLoadInString:(NSString *)dataStr callback:(NSString *)callbackStr;
- (void) jsonDidError;
@end

@interface JSONLoader : NSObject

@property (nonatomic, weak) id <JSONLoaderDelegate> delegateView;
@property (weak) NSString *callbackString;

@property (nonatomic, weak) NSString *urlStr;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) NSDictionary * dataDict;

//- (void) loadDataFromURL:(id)object withURL:(NSURL *)url  andCallback:(SEL)responseFunc;
+ (id) loadJSON:(id<JSONLoaderDelegate>)delegate
        withURL:(NSString*)url
    andCallback:(NSString*)callbackStr;

+ (void) loadJSONfromFile:(id<JSONLoaderDelegate>)delegate
                 fileName:(NSString*)filename
              andCallback:(NSString*)callbackStr;

@end
