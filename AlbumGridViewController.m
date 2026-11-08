#import "AlbumGridViewController.h"
#import "TrackListViewController.h"
#import "Theme.h"
#import "Library.h"

#pragma mark - Header

@interface MCGridHeader : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sectionLabel;
@end

@implementation MCGridHeader
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:34];
        [self addSubview:_titleLabel];
        _sectionLabel = [[UILabel alloc] init];
        _sectionLabel.font = [UIFont boldSystemFontOfSize:22];
        [self addSubview:_sectionLabel];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    _titleLabel.frame = CGRectMake(28, 8, w - 56, 44);
    _sectionLabel.frame = CGRectMake(28, 68, w - 56, 30);
    _sectionLabel.hidden = (_sectionLabel.text.length == 0);
}
@end

#pragma mark - Cell

@interface MCAlbumCell : UICollectionViewCell
- (void)setTitle:(NSString *)title artist:(NSString *)artist art:(UIImage *)art;
@end

@implementation MCAlbumCell {
    UIImageView *_art;
    UILabel *_t, *_s;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _art = [[UIImageView alloc] init];
        _art.layer.cornerRadius = 8;
        _art.layer.masksToBounds = YES;
        _art.layer.borderWidth = 0.5;
        _art.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.12].CGColor;
        [self.contentView addSubview:_art];
        _t = [[UILabel alloc] init];
        _t.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        [self.contentView addSubview:_t];
        _s = [[UILabel alloc] init];
        _s.font = [UIFont systemFontOfSize:14];
        _s.textColor = [MCTheme secondaryText];
        [self.contentView addSubview:_s];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.contentView.bounds.size.width;
    _art.frame = CGRectMake(0, 0, w, w);
    _t.frame = CGRectMake(0, w + 8, w, 18);
    _s.frame = CGRectMake(0, w + 27, w, 17);
}
- (void)setTitle:(NSString *)title artist:(NSString *)artist art:(UIImage *)art {
    _t.text = title;
    _s.text = artist;
    _art.image = art;
}
@end

#pragma mark - Controller

@implementation MCAlbumGridViewController {
    MCGridMode _mode;
    NSArray *_albums;
    BOOL _demo;
    NSString *_bigTitle;
    NSString *_sectionTitle;
}

- (instancetype)initWithMode:(MCGridMode)mode {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(176, 246);
    layout.minimumInteritemSpacing = 22;
    layout.minimumLineSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(8, 28, 110, 28);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _mode = mode;
        switch (mode) {
            case MCGridModeHome:   _bigTitle = @"Home";   _sectionTitle = @"Recently Added"; break;
            case MCGridModeNew:    _bigTitle = @"New";    _sectionTitle = @"Featured Albums"; break;
            case MCGridModeAlbums: _bigTitle = @"Albums"; _sectionTitle = nil; break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[MCAlbumCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[MCGridHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];

    if (_mode == MCGridModeHome) _albums = [MCLibrary recentAlbums];
    else if (_mode == MCGridModeAlbums) _albums = [MCLibrary albums];
    else _albums = @[];

    if (_albums.count == 0) {
        _albums = [MCLibrary demoAlbums];
        _demo = YES;
        if (_mode != MCGridModeNew) _sectionTitle = @"Sample Albums";
    }

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.headerReferenceSize = CGSizeMake(100, _sectionTitle ? 112 : 70);
}

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
    return _albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)ip {
    MCAlbumCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:ip];
    NSDictionary *a = _albums[ip.item];
    MPMediaItem *rep = a[@"rep"];
    UIImage *art = rep ? [MCTheme artworkForItem:rep size:176] : [MCTheme gradientArtForSeed:a[@"title"] size:176];
    [cell setTitle:a[@"title"] artist:a[@"artist"] art:art];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)cv viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)ip {
    MCGridHeader *h = [cv dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:ip];
    h.titleLabel.text = _bigTitle;
    h.sectionLabel.text = _sectionTitle;
    [h setNeedsLayout];
    return h;
}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)ip {
    NSDictionary *a = _albums[ip.item];
    if (_demo) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Sample Content"
            message:@"These are placeholder albums. Add songs to this iPad and your real library will appear here."
            preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    MCTrackListViewController *v = [[MCTrackListViewController alloc] initWithItems:a[@"items"] title:a[@"title"]];
    [self.navigationController pushViewController:v animated:YES];
}

@end
