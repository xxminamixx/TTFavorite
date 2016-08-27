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

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation TTHomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

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

// デバイスにtwitterアカウントが紐付いているか確認
- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}

// タイムライン取得処理
- (void)fetchTimelineForUser:(NSString *)username
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        ACAccountType *twitterAccountType =　[self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore　requestAccessToAccountsWithType:twitterAccountType　options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *twitterAccounts =
                [self.accountStore accountsWithAccountType:twitterAccountType];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                              @"/1.1/statuses/user_timeline.json"];
                NSDictionary *params = @{@"screen_name" : username,
                                         @"include_rts" : @"0",
                                         @"trim_user" : @"1",
                                         @"count" : @"1"};
                SLRequest *request =
                [SLRequest requestForServiceType:SLServiceTypeTwitter
                                   requestMethod:SLRequestMethodGET
                                             URL:url
                                      parameters:params];
                
                //  Attach an account to the request
                [request setAccount:[twitterAccounts lastObject]];
                
                [request performRequestWithHandler:
                 ^(NSData *responseData,
                   NSHTTPURLResponse *urlResponse,
                   NSError *error) {
                     
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 &&
                             urlResponse.statusCode < 300) {
                             
                             NSError *jsonError;
                             NSDictionary *timelineData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             if (timelineData) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond ... were we rate-limited?
                             NSLog(@"The response status code is %ld", (long)urlResponse.statusCode);
                         }
                     }
                 }];
            }
            else {
                // Access was not granted, or an error occurred
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

//　お気に入り取得メソッド
- (void)fetchFavorite
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/list.json"];
    
}

@end
