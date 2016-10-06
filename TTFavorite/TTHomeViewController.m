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
#import "TTFavoriteTableViewCell.h"



@interface TTHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) ACAccountStore *accountStore;
@property NSMutableArray *favoriteList;
@property TTFavoriteTableViewCell *dummyCell;

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

    // 高さ計算が上手くいかない場合は以下を追加する
//    self.favoriteTableView.estimatedRowHeight = 240;
//    self.favoriteTableView.rowHeight = UITableViewAutomaticDimension;
    
    // cellの登録
    UINib *nib = [UINib nibWithNibName:@"TTFavoriteTableViewCell" bundle:nil];
    [self.favoriteTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    self.dummyCell = [self.favoriteTableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    self.favoriteTableView.delegate = self;
    self.favoriteTableView.dataSource = self;
    
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
    
    __weak typeof(self) weakSelf = self;
    completedBlock completed = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [self.favoriteTableView reloadData];
        }
    };
    
    [self fetchFavoriteForUser:@"xxxxx_hobby" completed:completed];
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
- (void)fetchFavoriteForUser:(NSString *)userName completed:(completedBlock)block;
{
    self.favoriteList = [NSMutableArray array];
    
    if ([self userHasAccessToTwitter]) {
        self.accountStore = [[ACAccountStore alloc] init];
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
//                                 NSLog(@"%@", favoriteData);
                                 for (NSDictionary *dic in favoriteData) {
                                     TTFavoriteEntity *entity = [TTFavoriteEntity new];
                                     entity.text = [dic valueForKey:@"text"];
                                     entity.name = [dic valueForKeyPath:@"user.name"];
                                     entity.image = [dic valueForKeyPath:@"entities.media.media_url"];
                                     entity.icon = [dic valueForKeyPath:@"user.profile_image_url"];
                                     NSLog(@"%@", entity.text);
                                     NSLog(@"%@", entity.name);
                                     NSLog(@"%@", entity.image);
                                     NSLog(@"%@", entity.icon);
                                     [self.favoriteList addObject:entity];
                                 }
                                 block();
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

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return self.favoriteList.count;
}

- (UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTFavoriteTableViewCell *cell =
    [self.favoriteTableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[TTFavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    TTFavoriteEntity *entity = [[TTFavoriteEntity alloc] init];
    entity = self.favoriteList[indexPath.row];
    
    [cell setMyProperty:entity];
    
    // Entityのimageをurlに変換
    NSURL *url = [NSURL URLWithString:entity.image];
    [cell imageRefresh:url];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTFavoriteEntity *entity = [[TTFavoriteEntity alloc] init];
    entity = self.favoriteList[indexPath.row];
    [self.dummyCell setMyProperty:entity];
    
    // Entityのimageをurlに変換
    NSURL *url = [NSURL URLWithString:entity.image];
    [self.dummyCell imageRefresh:url];
    
    return self.dummyCell.height;
}

@end
