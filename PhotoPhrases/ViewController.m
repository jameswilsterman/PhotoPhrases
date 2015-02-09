//
//  ViewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        NSLog(@"We have a currentUser.");
        // NSArray *blocked = [currentUser objectForKey:@"blocked"];
        // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // [userDefaults setObject:blocked forKey:@"blocked"];
        
    } else {
        // show the signup or login screen
        [self attemptFacebookLogIn];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(215.0f/255.0f) green:(246.0f/255.0f) blue:(254.0f/255.0f) alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(255.0f/255.0f) green:(117.0f/255.0f) blue:(131.0f/255.0f) alpha:1.0f];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:(137.0f/255.0f) green:(144.0f/255.0f) blue:(175.0f/255.0f) alpha:1.0f]}];
}

- (void)attemptFacebookLogIn {
    
    NSArray *permissions = @[@"public_profile"];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
