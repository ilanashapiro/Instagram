//
//  RegisterViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/8/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)didTapRegister:(id)sender;
- (IBAction)didTapBack:(id)sender;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapRegister:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    if ([self.usernameTextField.text isEqual:@""]) {
        [self showErrorAlertWithMessage:@"Username missing"];
        return;
    }
    
    if ([self.passwordTextField.text isEqual:@""]) {
        [self showErrorAlertWithMessage:@"Password missing"];
        return;
    }
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    newUser.email = self.emailTextField.text;
    newUser.password = self.passwordTextField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self showErrorAlertWithMessage:error.localizedDescription];
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"homeScreenSegue" sender:nil];
        }
    }];
}

- (IBAction)didTapBack:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginScreeenViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginScreeenViewController;
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
