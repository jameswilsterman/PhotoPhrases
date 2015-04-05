//
//  WelcomeViewController.m
//  PhotoPhrases
//
//  Created by James M. Wilsterman on 2/9/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WebViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showTerms"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        NSURL *termsURL = [NSURL URLWithString:@"http://www.volleythat.com/the-welcoming-committee/2015/2/9/fraze-terms-of-service"];
        [(WebViewController *)[navController viewControllers][0] setBrowserURL:termsURL];
    }
}

- (IBAction)pressedSignUp:(id)sender {
    NSLog(@"pressedSignUp");
    [self attemptFacebookLogIn];
}

- (void)attemptFacebookLogIn {
    NSLog(@"attemptFacebookLogIn...");
    
    NSArray *permissions = @[@"public_profile"];
    
    if (![PFUser currentUser]) {
        NSLog(@"no user, signing in");
        [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
            if (error) {
                NSLog(@"Error logging in with Facebook %@", error);
            } else if (user) {
                NSLog(@"got user...");
                [self setupFBUser];
            }
        }];
    } else {
        NSLog(@"current user, just linking");
        if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissions block:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Error linking Facebook %@", error);
                }
                
                if (succeeded) {
                    [self setupFBUser];
                }
            }];
        }
    }
    
    /*
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self setupFBUser];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier:@"finishedSignUp" sender:self];
        }
    }];
     */
    
}

- (void)setupFBUser {
    NSLog(@"setupFBUser...");
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *fbError) {
        if (!fbError) {
            // Store the current user's Facebook ID on the user
            [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                     forKey:@"facebookId"];
            [[PFUser currentUser] setObject:[result objectForKey:@"name"]
                                     forKey:@"displayName"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"User logged in through Facebook!");
                    [self performSegueWithIdentifier:@"finishedSignUp" sender:self];
                }
            }];
        }
    }];
}

- (IBAction)cancelAsking:(UIStoryboardSegue *)segue {
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
