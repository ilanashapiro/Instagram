//
//  PostViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/9/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "PostViewController.h"
#import "HomeScreenViewController.h"
#import "Post.h"
#import "AppDelegate.h"

@interface PostViewController ()

- (IBAction)didTapCameraButton:(id)sender;
- (IBAction)didTapPhotoLibraryButton:(id)sender;
- (IBAction)didTapSubmitButton:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captionTextField.hidden = YES;
    self.postImageView.hidden = YES;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    //resize for under 10mb photo upload
    //editedImage = [self resizeImage:editedImage withSize:<#(CGSize)#>]
    
    // Do something with the images (based on your use case)
    self.postImageView.image = editedImage;
    self.postImageView.hidden = NO;
    self.captionTextField.hidden = NO;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCameraButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapPhotoLibraryButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (IBAction)didTapSubmitButton:(id)sender {
    if (self.postImageView.image != nil) {
        [Post postUserImage:self.postImageView.image withCaption:self.captionTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self returnToTabBarController];
                    NSLog(@"Post posted!");
            }
            else {
                [self showErrorAlertWithMessage:error.localizedDescription];
            }
        }];
    }
    else {
        [self showErrorAlertWithMessage:@"Choose image before posting."];
    }
}

- (void)returnToTabBarController {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    UIViewController *homeScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
    UINavigationController *homeScreenNavigationController = [[UINavigationController alloc] initWithRootViewController:homeScreenViewController];
    UITabBarItem *allPostsTab = [[UITabBarItem alloc] initWithTitle:@"All Posts" image:[UIImage imageNamed:@"feed_tab"] tag:1];
    homeScreenViewController.title = @"All Posts";
    [homeScreenViewController setTabBarItem:allPostsTab];
    
    UIViewController *profileFeedViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileFeedViewController"];
    UINavigationController *profileFeedNavigationController = [[UINavigationController alloc] initWithRootViewController:profileFeedViewController];
    UITabBarItem *profilePostsTab = [[UITabBarItem alloc] initWithTitle:@"Your Posts" image:[UIImage imageNamed:@"profile_tab"] tag:1];
    profileFeedViewController.title = @"Your Posts";
    [profileFeedViewController setTabBarItem:profilePostsTab];
    
    [tabBarController setViewControllers:@[homeScreenNavigationController, profileFeedNavigationController] animated:YES];
    appDelegate.window.rootViewController = tabBarController;
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
