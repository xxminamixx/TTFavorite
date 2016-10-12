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
#import "TTMoreLoadingTableViewCell.h"
#import "TTAddLabelView.h"
#import "TTAddLabelViewController.h"

NSInteger numberOfPage;

@interface TTHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, TTFavoriteTableViewCellDelegate, TTAddLabelViewDelegate>

@property (nonatomic) ACAccountStore *accountStore;
@property NSMutableArray *favoriteList;
@property TTFavoriteTableViewCell *cell;
@property NSString *page; // お気に入りのページ数
@property NSString *count; // お気に入りの取得数
@property TTAddLabelView *addLabelView;

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
    
    self.favoriteList = [[NSMutableArray alloc] init];
    
    self.count = @"10";
    self.page = @"0";
    
    self.navigationItem.title = @"お気に入りビューワー＠みなみ";

    // 高さ計算が上手くいかない場合は以下を追加する
    self.favoriteTableView.estimatedRowHeight = 240;
    self.favoriteTableView.rowHeight = UITableViewAutomaticDimension;
    
    // cellの登録
    UINib *nib = [UINib nibWithNibName:@"TTFavoriteTableViewCell" bundle:nil];
    [self.favoriteTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    // 更読みセルの登録
    UINib *moreLoadingNib = [UINib nibWithNibName:@"TTMoreLoadingTableViewCell" bundle:nil];
    [self.favoriteTableView registerNib:moreLoadingNib forCellReuseIdentifier:@"LoadCell"];
    
    self.favoriteTableView.delegate = self;
    self.favoriteTableView.dataSource = self;
    self.addLabelView.delegate = self;
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    UIBarButtonItem* left1 = [[UIBarButtonItem alloc]
                              initWithTitle:@"リロード"
                              style:UIBarButtonItemStylePlain
                              target:self
                              action:@selector(reload)];
    
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
//                NSLog(@"%@",userName);
                
                // ユーザID
                NSString* userID = [account valueForKeyPath:@"properties.user_id"];
//                NSLog(@"%@",userID);
                
            } else {
//                NSLog(@"登録アカウントなし");
            }
        }
    };
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:accountBlock ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self callFetchFavorite];
}

- (void)callFetchFavorite
{
    __weak typeof(self) weakSelf = self;
    completedBlock completed = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self.favoriteTableView reloadData];
            });
        }
    };
    
    [self fetchFavoriteForUser:@"yellowflog" completed:completed];
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
    
    if ([self userHasAccessToTwitter]) {
        self.accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *twitterAccounts =
                [self.accountStore accountsWithAccountType:twitterAccountType];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/list.json"];
                NSDictionary *parameter = @{@"screen_name" : userName,
                                            @"count": self.count,
                                            @"page" : self.page,
                                            };
                NSLog(@"ページ番号：%@",self.page);
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
//                                NSLog(@"%@", favoriteData);
                                for (NSDictionary *dic in favoriteData) {
                                     TTFavoriteEntity *entity = [TTFavoriteEntity new];
                                     entity.text = [dic valueForKey:@"text"];
                                     entity.name = [dic valueForKeyPath:@"user.name"];
                                     entity.imageList = [dic valueForKeyPath:@"extended_entities.media.media_url_https"];
                                     entity.icon = [dic valueForKeyPath:@"user.profile_image_url_https"];
//                                     NSLog(@"%@", entity.text);
//                                     NSLog(@"%@", entity.name);
//                                     NSLog(@"%@", entity.image);
//                                     NSLog(@"%@", entity.icon);
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
    // 更読み用のセルのために+1
    return self.favoriteList.count + 1;
}

- (UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.favoriteList.count > indexPath.row)
    {
        TTFavoriteTableViewCell *cell =
        [self.favoriteTableView dequeueReusableCellWithIdentifier:@"Cell"];
        
//        if (cell == nil) {
//            cell = [[TTFavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//        }
        
        TTFavoriteEntity *entity = [[TTFavoriteEntity alloc] init];
        entity = self.favoriteList[indexPath.row];
        
        cell.delagate = self;
        
        [cell setMyProperty:entity];
        
        if (entity.icon) {
            NSURL *url = [NSURL URLWithString:entity.icon];
            [cell iconRefresh:url];
        }
        
        return cell;
        
    } else {
        TTMoreLoadingTableViewCell *cell = [self.favoriteTableView dequeueReusableCellWithIdentifier:@"LoadCell"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.favoriteList.count <= indexPath.row)
    {
        numberOfPage = [self.page intValue];
        self.page = [NSString stringWithFormat:@"%ld",numberOfPage + 1];
        [self callFetchFavorite];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TTFavoriteEntity *entity = [[TTFavoriteEntity alloc] init];
//    entity = self.favoriteList[indexPath.row];
//    [self.dummyCell setMyProperty:entity];
//    
//    [self.dummyCell imageRefresh:entity.imageList];
//    
//    if (entity.icon) {
//        NSURL *url = [NSURL URLWithString:entity.icon];
//        [self.dummyCell iconRefresh:url];
//    }
//    
//    return self.dummyCell.height;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //一番下までスクロールしたかどうか
//    if(self.favoriteTableView.contentOffset.y >= (self.favoriteTableView.contentSize.height - self.favoriteTableView.bounds.size.height))
//    {
//        numberOfPage = [self.page intValue];
//        self.page = [NSString stringWithFormat:@"%ld",numberOfPage + 1];
//        [self callFetchFavorite];
//    }
//    
//    
//}

- (void)reload
{
    [self.favoriteTableView reloadData];
}

- (void)showAddLabelView
{
    NSLog(@"ラベルボタンが押されました");
    TTAddLabelView *view = [[TTAddLabelView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:view];
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
    NSArray *array = self.view.subviews;
    for(id any in array){
        NSLog(@"%@", any);
    }
    
    if(![view isDescendantOfView:self.view]) {
        // 存在していない
        NSLog(@"ビューが追加されていません");
    } else {
        // 存在している
        NSLog(@"ビューが追加されています");
    }
    
//    TTAddLabelViewController *viewContorller =  [self.storyboard instantiateViewControllerWithIdentifier:@"TTAddLabelViewController"];
//    [self presentViewController:viewContorller animated:YES completion:nil];

    
}

- (void)addLabelViewClose
{
    NSLog(@"閉じる");
    // subView全て削除
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
}

@end
