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
#import "Utils.h"
#import "TTFavoriteEntity.h"

@interface TTHomeViewController ()

@property (nonatomic) ACAccountStore *accountStore;
@property NSMutableArray *favoriteList;

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
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
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

//　お気に入り取得メソッド
- (void)fetchFavoriteForUser:(NSString *)userName
{
    if ([self userHasAccessToTwitter]) {
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *twitterAccounts =
                [self.accountStore accountsWithAccountType:twitterAccountType];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/list.json"];
                NSDictionary *parameter = @{@"screen_name" : userName,
                                            @"count": @"100",
                                            };
                
                // リクエスト作成
                SLRequest *request =
                [SLRequest requestForServiceType:SLServiceTypeTwitter
                                   requestMethod:SLRequestMethodGET
                                             URL:url
                                      parameters:parameter];
                
                [request setAccount:[twitterAccounts lastObject]];
                
                [request performRequestWithHandler:
                 ^(NSData *responseData,
                   NSHTTPURLResponse *urlResponse,
                   NSError *error) {
                     
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 &&
                             urlResponse.statusCode < 300) {
                             
                             NSError *jsonError;
                             NSDictionary *favoriteData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                          options:NSJSONReadingAllowFragments
                                                                                            error:&jsonError];
                             //　フェッチしたデータがfavoriteDataに格納
                             if (favoriteData) {
                                 self.favoriteList = [[NSMutableArray alloc] init];
                                 for (NSDictionary *dic in favoriteData) {
                                     TTFavoriteEntity *entity = [TTFavoriteEntity new];
                                     entity.text = [dic valueForKey:@"text"];
                                     entity.user = [dic valueForKeyPath:
                                                    @"user.name"];
                                     NSLog(@"%@", entity.text);
                                     NSLog(@"%@", entity.user);
                                     [self.favoriteList addObject:entity];
                                 }
                                 NSLog(@"%@", self.favoriteList);
                             }
                             else {
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
//                             NSLog(@"The response status code is %ld", (long)urlResponse.statusCode);
                         }
                     }
                 }];
            }
            else {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

@end
