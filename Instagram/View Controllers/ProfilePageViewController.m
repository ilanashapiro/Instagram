//
//  ProfilePageViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/11/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "ProfilePageViewController.h"
@import Parse;

@interface ProfilePageViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate>

- (IBAction)didTapCameraButton:(id)sender;
- (IBAction)didTapPhotoLibraryButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePhotoLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UITextView *bioTextField;
@property (nonatomic) BOOL bioWasEdited;

@end

@implementation ProfilePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserData];
    
    self.bioTextField.delegate = self;
    //NSLog(@"%@ %@ %d %@ %@", self.post.author.username,[PFUser currentUser][@"username"], [self.post.author isEqual:[PFUser currentUser]], NSStringFromClass([self.post.author.username class]), NSStringFromClass([[PFUser currentUser][@"username"] class]));
    
    NSString *authorName = [NSString stringWithFormat:@"%@", self.post.author.username];
    NSString *userName = [NSString stringWithFormat:@"%@", [PFUser currentUser][@"username"]];
    //NSLog(@"%@ %@ %d", authorName, userName, [authorName isEqual:userName]);
    if (![authorName isEqual:userName]) {
        [self.changePhotoLabel setHidden:YES];
        [self.photoLibraryButton setHidden:YES];
        [self.cameraButton setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        if (self.bioWasEdited) {
            PFUser *user = self.post.author;
            [user setObject:self.bioTextField.text forKey:@"bioText"];
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error != nil) {
                    NSLog(@"User set bio failed: %@", error.localizedDescription);
                    [self showErrorAlertWithMessage:error.localizedDescription];
                }
                else {
                    NSLog(@"User successfully changed bio!");
                }
            }];
        }
        [self.delegate updateProfileData:self];
    }
}

- (void)loadUserData {
    PFUser *user = self.post.author;
    //NSLog(@"post user is: %@", user.username);
    if ([user objectForKey:@"profileImage"]) {
        [user[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                NSLog(@"Image is: %@", image);
                image = [self resizeImage:image withSize:CGSizeMake(500, 500)];
                self.profileImageView.image = image;
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
                self.profileImageView.clipsToBounds = YES;
            }
            else {
                NSLog(@"error");
            }
        }];
    }
    else {
        UIImage *defaultImage = [self resizeImage:[UIImage imageNamed:@"emptyprofile"] withSize:CGSizeMake(20, 20)];
        self.profileImageView.image = defaultImage;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = YES;
    }
    
    if ([user objectForKey:@"bioText"]) {
        self.bioTextField.text = user[@"bioText"];
    }
    
    self.nameLabel.text = user.username;
    
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
    self.profileImageView.image = editedImage;
    NSData *imageData = UIImagePNGRepresentation(editedImage);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
    PFUser *user = self.post.author;
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.bioWasEdited = YES;
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
