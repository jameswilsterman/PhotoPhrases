//
//  WritePhraseViewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "WritePhraseViewController.h"
#import "UIColor+ColorExtensions.h"
#import "FriendTableViewController.h"
#import <Parse/Parse.h>

@interface WritePhraseViewController ()
@property (weak, nonatomic) IBOutlet UITextView *phraseTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *sendRandomButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *instructions;
@property (weak, nonatomic) IBOutlet UIButton *generatePhraseButton;
@property BOOL isPlaceholder;
@property (weak, nonatomic) NSString *placeholderText;
@property (weak, nonatomic) NSString *lastChar;
@property (weak, nonatomic) IBOutlet UIButton *dismissKeyboardButton;
@end

@implementation WritePhraseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator setHidden:YES];
    [self disableSendButtons];
    [self.generatePhraseButton setEnabled:YES];
    if (!self.showInstructions) {
        self.instructions.hidden = YES;
    }
    
    /*
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(makeFirstResponder:) userInfo:nil repeats:NO];
    */
    
    [self.phraseTextView setTintColor:[UIColor textGrayColor]];
    
    // initialize placeholder text
    self.placeholderText = @"Tap here and describe what you want someone to draw.";
    self.isPlaceholder = YES;
    self.phraseTextView.text = self.placeholderText;
    self.phraseTextView.textColor = [UIColor logoBlueColorWithAlpha];
    [self.phraseTextView setSelectedRange:NSMakeRange(0, 0)];
    
    UIImage *image = [[UIImage imageNamed:@"keyboard-104.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.dismissKeyboardButton setImage:image forState:UIControlStateNormal];
    [self.dismissKeyboardButton setTintColor:[UIColor accentRedColor]];
    
    [self.dismissKeyboardButton setHidden:YES];
    [self.dismissKeyboardButton setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor logoBlueColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.phraseTextView resignFirstResponder];
}

- (void)disableSendButtons {
    [self.sendFriendButton setEnabled:NO];
    [self.sendFriendButton setAlpha:0.5];
    [self.sendRandomButton setEnabled:NO];
    [self.sendRandomButton setAlpha:0.5];
}

- (void)enableSendButtons {
    [self.sendFriendButton setEnabled:YES];
    [self.sendFriendButton setAlpha:1.0];
    [self.sendRandomButton setEnabled:YES];
    [self.sendRandomButton setAlpha:1.0];
}

- (void)makeFirstResponder:(NSTimer *)timer {
    [self.phraseTextView becomeFirstResponder];
    [self.phraseTextView setSelectedRange:NSMakeRange(0, 0)];
}

- (void)textViewDidBeginEditing:(UITextView *)phraseTextView {
    NSLog(@"textViewDidBeginEditing");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.lastChar = text;
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)phraseTextView {
    
    if (phraseTextView.text.length == 0) {
        phraseTextView.textColor = [UIColor logoBlueColorWithAlpha];
        phraseTextView.text = self.placeholderText;
        [phraseTextView setSelectedRange:NSMakeRange(0, 0)];
        self.isPlaceholder = YES;
        [self disableSendButtons];
    } else if (self.isPlaceholder && ![phraseTextView.text isEqualToString:self.placeholderText]) {
        phraseTextView.text = self.lastChar;
        phraseTextView.textColor = [UIColor logoBlueColor];
        self.isPlaceholder = NO;
        [self enableSendButtons];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)phraseTextView {
    NSLog(@"textViewDidChangeSelection");
    if (self.isPlaceholder && [phraseTextView.text isEqualToString:self.placeholderText]) {
        [phraseTextView setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (void)keyboardWillShow {
    [self.dismissKeyboardButton setHidden:NO];
    [self.dismissKeyboardButton setEnabled:YES];
}

- (void)keyboardWillHide {
    [self.dismissKeyboardButton setHidden:YES];
    [self.dismissKeyboardButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generatePhrase:(UIButton *)sender {
    NSLog(@"generatePhrase");
    [self.phraseTextView resignFirstResponder];
    [self.generatePhraseButton setEnabled:NO];
    [self disableSendButtons];
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
                                        [self enableSendButtons];
                                        [self.activityIndicator setHidden:YES];
                                    }
                                }];
}

- (IBAction)pressCancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressDismissKeyboard:(id)sender {
    [self.phraseTextView resignFirstResponder];
}

- (void)addChainActivity {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        PFObject *chainActivity = [PFObject objectWithClassName:@"ChainActivity"];
        chainActivity[@"fromPFUser"] = currentUser;
        chainActivity[@"phraseText"] =  self.phraseTextView.text;
        chainActivity[@"responded"] = @NO;
        
        if (self.selectedObject){
            chainActivity[@"partOfChain"] = [self.selectedObject objectForKey:@"partOfChain"];
            chainActivity[@"linkIndex"] =  [NSNumber numberWithInteger:[[self.selectedObject objectForKey:@"linkIndex"] integerValue] + 1];
        } else {
            chainActivity[@"linkIndex"] = @0;
        }
        
        if (self.selectedUser) {
            chainActivity[@"toPFUser"] = self.selectedUser;
        }
        
        [self disableSendButtons];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [chainActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.activityIndicator stopAnimating];
                [self.activityIndicator setHidden:YES];
                self.selectedUser = nil;
            } else {
                // There was a problem, check error.description
            }
        }];
    } else {
        // show the signup or login screen?
    }
}

- (IBAction)pressSend:(UIButton *)sender{
    
    if (self.phraseTextView.text.length > 0){// Only do something if we have some text to send
        [self.phraseTextView resignFirstResponder];
   
        if ([sender isEqual:self.sendRandomButton]) {
            NSLog(@"sendRandomButton pressed");
            [self addChainActivity];
            
        } else if ([sender isEqual:self.sendFriendButton]) {
            NSLog(@"sendFriendButton pressed");
            [self performSegueWithIdentifier:@"showFriends" sender:self];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navigationController = segue.destinationViewController;
    FriendTableViewController *modalVC = (FriendTableViewController * )navigationController.topViewController;
    modalVC.somethingHappenedInModalVC = ^(PFUser *response) {
        NSLog(@"Something was selected in the modalVC");
        self.selectedUser = response;
        [self addChainActivity];
    };
}

@end
