//
//  DetailNewsViewController.h
//  jyChoiReport
//
//  Created by JuYoung choi on 4/21/24.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class CustomWKWebView;
@protocol CustomWKWebViewDelegate;

@interface DetailNewsViewController : UIViewController<CustomWKWebViewDelegate>

@property(assign) NSString * url;
@property(assign) NSString * newsTitle;
@property(weak) CustomWKWebView *webView;

- (id) init:(NSString *) title url:(NSString *) url;

@end

NS_ASSUME_NONNULL_END
