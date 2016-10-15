//
//  TTSameLabelViewController.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/14.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTSameLabelViewController.h"
#import "TTFavoriteManager.h"
#import "TTFavoriteEntity.h"
#import "TTFavoriteTableViewCell.h"

@interface TTSameLabelViewController ()<UITableViewDataSource, UITableViewDelegate, TTFavoriteTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sameLabelTableView;


@property NSMutableArray *sameLabelEntityList;

@end

@implementation TTSameLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sameLabelEntityList = [[NSMutableArray alloc] init];
    
    self.sameLabelTableView.estimatedRowHeight = 240;
    self.sameLabelTableView.rowHeight = UITableViewAutomaticDimension;
    self.sameLabelTableView.delegate = self;
    self.sameLabelTableView.dataSource = self;
    
    // cellの登録
    UINib *nib = [UINib nibWithNibName:@"TTFavoriteTableViewCell" bundle:nil];
    [self.sameLabelTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    // 更読みセルの登録
    UINib *moreLoadingNib = [UINib nibWithNibName:@"TTMoreLoadingTableViewCell" bundle:nil];
    [self.sameLabelTableView registerNib:moreLoadingNib forCellReuseIdentifier:@"LoadCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    for (TTFavoriteEntity *entity in [[TTFavoriteManager singleton]  favoriteList]) {
        if ([entity.label isEqualToString:self.label]) {
            // 前画面で選択したラベルと永続化されているEntityのラベルが同じ時Entityを自身の配列に格納
            [self.sameLabelEntityList addObject: entity];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma -mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //　永続化された配列から選択されたラベルのEnittyのみを取り出した配列の要素数
    return self.sameLabelEntityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTFavoriteTableViewCell *cell =
    [self.sameLabelTableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    TTFavoriteEntity *entity = [[TTFavoriteEntity alloc] init];
    entity = self.sameLabelEntityList[indexPath.row];
    
    cell.delagate = self;
    
    [cell setMyProperty:entity];
    
    if (entity.icon) {
        NSURL *url = [NSURL URLWithString:entity.icon];
        [cell iconRefresh:url];
    }
    
    return cell;
}

- (void)showAddLabelView:(TTFavoriteEntity *)entity
{
    NSLog(@"デリゲートが呼ばれました");
}


@end
