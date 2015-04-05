//
//  WritePhraseViewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "WritePhraseViewController.h"
#import <Parse/Parse.h>

@interface WritePhraseViewController ()
@property (weak, nonatomic) IBOutlet UITextView *phraseTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendPhraseButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *instructions;
@property (weak, nonatomic) IBOutlet UIButton *generatePhraseButton;

@end

@implementation WritePhraseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.activityIndicator setHidden:YES];
    [self.sendPhraseButton setEnabled:YES];
    [self.generatePhraseButton setEnabled:YES];
    if (!self.showInstructions) {
        self.instructions.hidden = YES;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generatePhrase:(UIButton *)sender {
    NSLog(@"generatePhrase");
    [self.generatePhraseButton setEnabled:NO];
    [self.sendPhraseButton setEnabled:NO];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [PFCloud callFunctionInBackground:@"randomPhrase"
                       withParameters:@{}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        
                                        self.phraseTextView.text = result;
                                        [self.activityIndicator stopAnimating];
                                        [self.generatePhraseButton setEnabled:YES];
                                        [self.sendPhraseButton setEnabled:YES];
                                        [self.activityIndicator setHidden:YES];
                                    }
                                }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.phraseTextView.text.length > 0){
        [self.phraseTextView resignFirstResponder];
        [self pressSend:nil];
        return YES;
    }
    
    return NO;
}

- (IBAction)pressCancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressSend:(id)sender{
    
    if (self.phraseTextView.text.length > 0){// Only do something if we have some text to send
        [self.phraseTextView resignFirstResponder];
   
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
        
            // do stuff with the user
            PFObject *chainActivity;
            if (self.selectedObject){
                chainActivity = [PFObject objectWithClassName:@"ChainActivity"];
                chainActivity[@"partOfChain"] = [self.selectedObject objectForKey:@"partOfChain"];
                chainActivity[@"phraseText"] = self.phraseTextView.text;
                chainActivity[@"fromPFUser"] = currentUser;
                chainActivity[@"linkIndex"] =  [NSNumber numberWithInteger:[[self.selectedObject objectForKey:@"linkIndex"] integerValue] + 1];
                chainActivity[@"responded"] = @NO;
            
            }else {
                chainActivity = [PFObject objectWithClassName:@"ChainActivity"];
                chainActivity[@"phraseText"] =  self.phraseTextView.text;
                chainActivity[@"fromPFUser"] = currentUser;
                chainActivity[@"linkIndex"] = @0;
                chainActivity[@"responded"] = @NO;
            }
            [self.sendPhraseButton setEnabled:NO];
            [self.activityIndicator setHidden:NO];
            [self.activityIndicator startAnimating];
            [chainActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.activityIndicator stopAnimating];
                    [self.activityIndicator setHidden:YES];
                } else {
                    // There was a problem, check error.description
                }
            }];
        
        } else {
            // show the signup or login screen?
        }
    }
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
