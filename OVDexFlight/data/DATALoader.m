//
//  DATALoader.m
//  OVDexFlight
//
//  Created by Goon Nguyen on 6/24/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "DATALoader.h"
#define SAFE_PERFORM_WITH_ARG(THE_OBJECT, THE_SELECTOR, THE_ARG) (([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG] : nil)

@implementation DATALoader
{
    NSMutableData *responseData;
}

@synthesize delegateView, callbackString, urlStr;

+ (id) loadData:(id<DATALoaderDelegate>)delegate
        withURL:(NSString*)url
    andCallback:(NSString*)callbackStr
{
    NSLog(@"-> DATALoader is loading: %@", url);
    
    DATALoader *loadData = [[self alloc] init];
    //loadData.callbackString = callbackStr;
    loadData.delegateView = delegate;
    loadData.urlStr = url;
    
    [loadData load];
    
    return loadData;
}

- (void)load
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *e;
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&e];
    
    NSString *dataStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if ([delegateView respondsToSelector:@selector(jsonDidLoadInString:callback:)]) {
        [delegateView jsonDidLoadInString:dataStr callback:callbackString];
    }
    
    if ([delegateView respondsToSelector:@selector(jsonDidLoad:callback:)]) {
        [delegateView jsonDidLoad:array callback:callbackString];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    if ([delegateView respondsToSelector:@selector(jsonDidError)]) {
        [delegateView jsonDidError];
    }
}

@end
