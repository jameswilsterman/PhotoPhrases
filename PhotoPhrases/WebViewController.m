//
//  WebViewController.m
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 2/9/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.browserURL]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(215.0f/255.0f) green:(246.0f/255.0f) blue:(254.0f/255.0f) alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(255.0f/255.0f) green:(117.0f/255.0f) blue:(131.0f/255.0f) alpha:1.0f];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:(137.0f/255.0f) green:(144.0f/255.0f) blue:(175.0f/255.0f) alpha:1.0f]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.webView stopLoading];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
