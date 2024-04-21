//
//  DetailNewsViewController.m
//  jyChoiReport
//
//  Created by JuYoung choi on 4/21/24.
//

#import "DetailNewsViewController.h"
#import "jyChoiReport-Swift.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController

- (id) init:(NSString *) title url:(NSString *) url {
    
    self = [super initWithNibName:nil bundle:nil];
    
    self.url = url;
    self.newsTitle = title;
    
    return self;
}

- (void) startWebViewIndigator {
    UIActivityIndicatorView *indigator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    
    indigator.tintColor = [UIColor darkGrayColor];
    
    [self.view addSubview: indigator];
    
    [indigator startAnimating];
    
    indigator.center = self.view.center;
}

- (void) stopWebViewIndigator {
    
    for(int i = 0; i<self.view.subviews.count; i++) {
        
        if ([self.view.subviews[i] isKindOfClass: UIActivityIndicatorView.class ]) {
            
            UIActivityIndicatorView * indigator = ((UIActivityIndicatorView *)self.view.subviews[i]);
            [indigator stopAnimating];
            [indigator removeFromSuperview];
            break;
        }
    }
}

- (void) uiSetting {
    
    CustomWKWebView *webView = [[CustomWKWebView alloc] init];
   
    webView.translatesAutoresizingMaskIntoConstraints = FALSE;
    [self.view addSubview:webView];
    self.webView = webView;
    
    [webView setWebviewDelegate: self];
    [webView requestUrl: self.url];
    [webView setUseProgressBar];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0];
    
    [self.view addConstraints:@[leading, trailing, top, bottom]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self uiSetting];
    self.title = self.newsTitle;
    self.navigationController.navigationBar.tintColor = UIColor.grayColor;
}

// MARK: - CustomWebview delegate
- (BOOL)isHttpRequestUrlWithCallUrl:(NSURL * _Nullable)callUrl {
    return TRUE;
}

- (void) loadingFinish {
    
    if ([self.webView.title isEqual: @""]) {
        
        return;
    }
    
    self.title = self.webView.title;
}

@end
