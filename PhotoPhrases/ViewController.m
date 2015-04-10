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
@property (weak, nonatomic) IBOutlet UILabel *addChainLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.addChainLabel.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        NSLog(@"We have a currentUser.");
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:currentUser forKey:@"user"];
        [currentInstallation saveInBackground];
        [self setAddChainLabel];
        
    } else {
        // show the signup or login screen
        [self performSegueWithIdentifier:@"presentWelcome" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma METHODS

- (void) setAddChainLabel {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ChainActivity"];
    [query whereKey:@"toPFUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"responded" equalTo:@NO];
    [query includeKey:@"fromPFUser"];
    [query includeKey:@"Photo"];
    [query orderByDescending:@"createdAt"];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error){
        if (!error){
            
            if (count > 0) {
                
                self.addChainLabel.text = [NSString stringWithFormat:@"%d", count];
                self.addChainLabel.hidden = NO;
            }
            
        } else {
            NSLog(@"Something went wrong %@:",[error description]);
        }
    }];
}

#pragma SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"newChain"]) {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        WritePhraseViewController *destViewController = (WritePhraseViewController* )[navController topViewController];
        destViewController.navigationItem.title = @"NEW CHAIN";
        destViewController.showInstructions = YES;
    }
    
}



@end
