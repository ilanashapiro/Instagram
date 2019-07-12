//
//  LoginViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/8/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@import Parse;;
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)didTapLogin:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (PFFileObject *)getPFFileFromImage:(UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (IBAction)didTapLogin:(id)sender {
    if ([self.usernameTextField.text isEqual:@""]) {
        [self showErrorAlertWithMessage:@"Username missing"];
        return;
    }
    
    if ([self.passwordTextField.text isEqual:@""]) {
        [self showErrorAlertWithMessage:@"Password missing"];
        return;
    }
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self showErrorAlertWithMessage:error.localizedDescription];
        } else {
            NSLog(@"image: %@", [UIImage imageNamed:@"Icon-60"]);
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
            // display view controller that needs to shown after successful login
            
        }
    }];
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
