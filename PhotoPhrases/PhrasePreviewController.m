//
//  PhrasePreviewController.m
//  PhotoPhrases
//
//  Created by Greg Cheong on 2/7/15.
//  Copyright (c) 2015 Greg Cheong. All rights reserved.
//

#import "PhrasePreviewController.h"
#import <Parse/Parse.h>
#import "staticMethods.h"

@interface PhrasePreviewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
    
@end

@implementation PhrasePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator setHidden:YES];
    [self.takePhotoButton setEnabled:YES];
    self.phraseLabel.text = [self.selectedObject objectForKey:@"phraseText"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFlagOptions:(id)sender {
    
    UIAlertController *timeSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [timeSheet addAction:[UIAlertAction actionWithTitle:@"Flag as offensive" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.takePhotoButton setEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [staticMethods flagChainActivity:self.selectedObject.objectId];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }]];
    
    [timeSheet addAction:[UIAlertAction actionWithTitle:@"Block user" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        PFUser *fromUserForChain = [self.selectedObject objectForKey:@"fromPFUser"];
        NSString *objectId = fromUserForChain.objectId;
        [self.takePhotoButton setEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [staticMethods flagChainActivity:self.selectedObject.objectId];
        [staticMethods blockUser:objectId];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }]];
    [timeSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:timeSheet animated:YES completion:nil];
}

- (IBAction)respondToPhraseButtonPressed:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraController = [UIImagePickerController new];
        cameraController.delegate = self;
        
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.allowsEditing = NO;
        
        
        [self presentViewController:cameraController animated:YES completion:nil];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *photoImagePicker = [UIImagePickerController new];
            photoImagePicker.delegate = self;
        
            photoImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
            photoImagePicker.allowsEditing = NO;
        
            [self presentViewController:photoImagePicker animated:YES completion:nil];
  
    }
}

// UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
   
    //Send it down to parse
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        // do stuff with the user
        PFObject *chainActivity;
        if (self.selectedObject){
            chainActivity = [PFObject objectWithClassName:@"ChainActivity"];
            chainActivity[@"partOfChain"] = [self.selectedObject objectForKey:@"partOfChain"];
            chainActivity[@"fromPFUser"] = currentUser;
            chainActivity[@"linkIndex"] =  [NSNumber numberWithInteger:[[self.selectedObject objectForKey:@"linkIndex"] integerValue] + 1];
            chainActivity[@"responded"] = @NO;
            
            // Get an NSData representation of our images. We use JPEG for the larger image
            // for better compression and PNG for the thumbnail to keep the corner radius transparency
            NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.8f);
            PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg",[self.selectedObject objectId]] data:imageData];
            PFObject *userPhoto = [PFObject objectWithClassName:@"Photo"];
            userPhoto[@"image"] = imageFile;
            userPhoto[@"user"] = [PFUser currentUser];
            chainActivity[@"Photo"] = userPhoto;
            [self.takePhotoButton setEnabled:NO];
            [self.activityIndicator setHidden:NO];
            [self.activityIndicator startAnimating];
            [chainActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.activityIndicator stopAnimating];
                    [self.activityIndicator setHidden:YES];
                } else {
                    // There was a problem, check error.description
                }
            }];
            
        }
        
        
    } else {
        // show the signup or login screen?
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
