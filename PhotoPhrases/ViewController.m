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
#import "WritePhraseViewController.h"

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
        // [self attemptFacebookLogIn];
        [self performSegueWithIdentifier:@"presentWelcome" sender:self];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"newChain"]) {
        WritePhraseViewController *wpvc = segue.destinationViewController;
        wpvc.showInstructions = YES;
    }
    
}



@end
