//
//  HomeViewController.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/08/23.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTHomeViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TTHomeViewController ()

@end

@implementation TTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:
                           ACAccountTypeIdentifierTwitter];
    
    
    
    UIBarButtonItem* left1 = [[UIBarButtonItem alloc]
                              initWithTitle:@"複数選択"
                              style:UIBarButtonItemStylePlain
                              target:self
                              action:nil];
    
    self.navigationItem.rightBarButtonItems = @[left1];
    
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];
    ACAccountType* accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    void (^accountBlock)(BOOL, NSError*) = ^(BOOL granted, NSError* error) {
        if (granted) {
            
            // Twitterは複数アカウントでログイン可能の為、結果がArrayで返ってくる
            NSArray* accounts = [accountStore accountsWithAccountType:accountType];
            
            if ([accounts count] > 0) {
                ACAccount* account = [accounts objectAtIndex:0];
                
                // ユーザ名
                NSString* userName = account.username;
                NSLog(@"%@",userName);
                
                // ユーザID
                NSString* userID = [account valueForKeyPath:@"properties.user_id"];
                NSLog(@"%@",userID);
                
            } else {
                NSLog(@"登録アカウントなし");
            }
        }
    };
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:accountBlock ];
//    [store requestAccessToAccountsWithType:type
//                                   options:nil
//                                completion:^(BOOL granted, NSError *error) {
//                                    
//                                    if (!granted) {
//                                        
//                                        NSLog(@"not granted");
//                                        
//                                        return;
//                                    }
//                                    
//                                    NSArray *twitterAccounts = [store accountsWithAccountType:type];
//                                    
//                                    if (!(twitterAccounts > 0)) {
//                                        
//                                        NSLog(@"no twitter accounts");
//                                        
//                                        return;
//                                    }
//                                    
//                                    ACAccount *account = [twitterAccounts lastObject];
//                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
