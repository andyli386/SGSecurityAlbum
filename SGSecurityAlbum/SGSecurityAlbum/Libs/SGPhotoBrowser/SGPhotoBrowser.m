//
//  SGPhotoBrowserViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoBrowser.h"
#import "SGPhotoCollectionView.h"
#import "SGPhotoModel.h"
#import "SGPhotoCell.h"
#import "SGPhotoViewController.h"

@interface SGPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat _margin, _gutter;
}

@property (nonatomic, weak) SGPhotoCollectionView *collectionView;
@property (nonatomic, assign) CGSize photoSize;

@end

@implementation SGPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    SGPhotoCollectionView *collectionView = [[SGPhotoCollectionView alloc] initWithFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size} collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
}

- (void)initParams {
    _margin = 0;
    _gutter = 1;
    self.numberOfPhotosPerRow = 3;
    self.margin = 2;
}

- (void)checkImplementation {
    if (self.photoAtIndexHandler && self.numberOfPhotosHandler) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView reloadData];
    }
}

- (void)setphotoAtIndexBlockHandler:(SGPhotoBrowserDataSourcePhotoBlock)handler {
    _photoAtIndexHandler = handler;
    [self checkImplementation];
}

- (void)setNumberOfPhotosBlockHandler:(SGPhotoBrowserDataSourceNumberBlock)handler {
    _numberOfPhotosHandler = handler;
    [self checkImplementation];
}

- (void)setNumberOfPhotosPerRow:(NSInteger)numberOfPhotosPerRow {
    _numberOfPhotosPerRow = numberOfPhotosPerRow;
    [self.collectionView setNeedsLayout];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(self.numberOfPhotosHandler != nil, @"you must implement 'numberOfPhotosHandler' block to tell the browser how many photos are here");
    return self.numberOfPhotosHandler();
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat value = (self.view.bounds.size.width - (self.numberOfPhotosPerRow - 1) * _gutter - 2 * _margin) / self.numberOfPhotosPerRow;
    return CGSizeMake(value, value);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _gutter;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _gutter;
}

#pragma mark -
#pragma mark UICollectionView Delegate (FlowLayout)
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.photoAtIndexHandler != nil, @"you must implement 'photoAtIndexHandler' block to provide photos for the browser.");
    SGPhotoModel *model = self.photoAtIndexHandler(indexPath.row);
    SGPhotoCell *cell = [SGPhotoCell cellWithCollectionView:collectionView forIndexPaht:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SGPhotoViewController *vc = [SGPhotoViewController new];
    vc.browser = self;
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
