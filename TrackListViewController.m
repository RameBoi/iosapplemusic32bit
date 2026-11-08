#import "TrackListViewController.h"
#import "Theme.h"
#import "Player.h"

@implementation MCTrackListViewController {
    NSArray *_items;
    NSArray *_filtered;
    NSString *_name;
}

- (instancetype)initWithItems:(NSArray *)items title:(NSString *)title {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _items = items ? items : @[];
        _filtered = _items;
        _name = [title copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.showsBigTitle) self.title = _name;
    self.tableView.rowHeight = 62;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 78, 0, 0);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 100)];

    CGFloat w = self.view.bounds.size.width, h = 0;
    UIView *hdr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 10)];
    hdr.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (self.showsBigTitle) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(28, 6, w - 56, 44)];
        l.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        l.font = [UIFont boldSystemFontOfSize:34];
        l.text = _name;
        [hdr addSubview:l];
        h = 56;
    }
    if (self.searchEnabled) {
        UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(16, h, w - 32, 44)];
        sb.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        sb.searchBarStyle = UISearchBarStyleMinimal;
        sb.placeholder = @"Songs, Artists, Albums";
        sb.delegate = self;
        [hdr addSubview:sb];
        h += 48;
    }
    if (h > 0) {
        hdr.frame = CGRectMake(0, 0, w, h);
        self.tableView.tableHeaderView = hdr;
    }

    if (_items.count == 0) {
        UILabel *empty = [[UILabel alloc] init];
        empty.text = @"No songs found.\nSync music to this iPad with iTunes.";
        empty.numberOfLines = 0;
        empty.textAlignment = NSTextAlignmentCenter;
        empty.textColor = [MCTheme secondaryText];
        empty.font = [UIFont systemFontOfSize:17];
        self.tableView.backgroundView = empty;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerChanged) name:MCPlayerStateChanged object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MCPlayerStateChanged object:nil];
}

- (void)playerChanged {
    NSArray *paths = [self.tableView indexPathsForVisibleRows];
    if (paths.count) [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)sb textDidChange:(NSString *)text {
    if (text.length == 0) {
        _filtered = _items;
    } else {
        NSMutableArray *out = [NSMutableArray array];
        for (MPMediaItem *it in _items) {
            NSString *hay = [NSString stringWithFormat:@"%@ %@ %@",
                [it valueForProperty:MPMediaItemPropertyTitle] ?: @"",
                [it valueForProperty:MPMediaItemPropertyArtist] ?: @"",
                [it valueForProperty:MPMediaItemPropertyAlbumTitle] ?: @""];
            if ([hay rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound) [out addObject:it];
        }
        _filtered = out;
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sb { [sb resignFirstResponder]; }

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return _filtered.count; }

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    static NSString *cid = @"track";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
        cell.imageView.layer.cornerRadius = 5;
        cell.imageView.layer.masksToBounds = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [MCTheme secondaryText];
        UILabel *dur = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        dur.font = [UIFont systemFontOfSize:14];
        dur.textColor = [MCTheme secondaryText];
        dur.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = dur;
    }
    MPMediaItem *it = _filtered[ip.row];
    cell.textLabel.text = [it valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [it valueForProperty:MPMediaItemPropertyArtist];
    cell.imageView.image = [MCTheme artworkForItem:it size:48];
    NSTimeInterval d = [[it valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    ((UILabel *)cell.accessoryView).text = [MCTheme timeString:d];

    MPMediaItem *cur = [MCPlayer shared].currentItem;
    BOOL isCur = cur && [[cur valueForProperty:MPMediaItemPropertyPersistentID] isEqual:[it valueForProperty:MPMediaItemPropertyPersistentID]];
    cell.textLabel.textColor = isCur ? [MCTheme accent] : [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    [[MCPlayer shared] playItems:_filtered startIndex:(NSUInteger)ip.row];
}

@end
