//
//  ProfilePageViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/11/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "ProfilePageView.h"
@import Parse;

@interface ProfilePageViewController () <UIImagePickerControllerDelegate>

- (IBAction)didTapCameraButton:(id)sender;
- (IBAction)didTapPhotoLibraryButton:(id)sender;

@property (weak, nonatomic) IBOutlet ProfilePageView *profilePageView;

@end

@implementation ProfilePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.profilePageView.post = self.post;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapCameraButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (IBAction)didTapPhotoLibraryButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    //resize for under 10mb photo upload
    //editedImage = [self resizeImage:editedImage withSize:<#(CGSize)#>]
    
    // Do something with the images (based on your use case)
    self.profilePageView.profileImageView.image = editedImage;
    NSData *imageData = UIImagePNGRepresentation(editedImage);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
    PFUser *user = [PFUser currentUser];
    [user setObject:imageFile forKey:@"profileImage"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            NSLog(@"User set profile pic login failed: %@", error.localizedDescription);
            [self showErrorAlertWithMessage:error.localizedDescription];
        }
        else {
            NSLog(@"User successfully changed profile pic!");
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showErrorAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

@end



/*
 PFFileObject *imageFile = [self getPFFileFromImage:[UIImage imageNamed:@"Icon-60"]] ;
 [user setObject:imageFile forKey:@"profileImage"];
 
 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 if (error != nil) {
 NSLog(@"User set profile pic login failed: %@", error.localizedDescription);
 [self showErrorAlertWithMessage:error.localizedDescription];
 }
 else {
 NSLog(@"User logged in successfully with profile pic!");
 [self performSegueWithIdentifier:@"homeScreenSegue" sender:nil];
 }
 }];
 */
