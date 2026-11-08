#import "SidebarViewController.h"
#import "Theme.h"
#import "Library.h"
#import "AlbumGridViewController.h"
#import "TrackListViewController.h"
#import "GroupListViewController.h"
#import "PlaceholderViewController.h"

@implementation MCSidebarViewController {
    NSArray *_sections;
    BOOL _didSelectInitial;
}

static NSDictionary *Row(NSString *name, MCGlyph g) {
    return @{@"name": name, @"glyph": @(g)};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sections = @[
        @{@"title": @"", @"rows": @[Row(@"Search", MCGlyphSearch)]},
        @{@"title": @"", @"rows": @[Row(@"Home", MCGlyphHome), Row(@"New", MCGlyphNew), Row(@"Radio", MCGlyphRadio)]},
        @{@"title": @"Library", @"rows": @[Row(@"Playlists", MCGlyphPlaylists), Row(@"Artists", MCGlyphArtists),
                                           Row(@"Albums", MCGlyphAlbums), Row(@"Songs", MCGlyphSongs)]}
    ];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.965 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;

    UIView *hdr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 280, 40)];
    l.text = @"Music";
    l.font = [UIFont boldSystemFontOfSize:30];
    [hdr addSubview:l];
    self.tableView.tableHeaderView = hdr;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_didSelectInitial) {
        _didSelectInitial = YES;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:ip];
    }
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv { return _sections.count; }
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return [_sections[s][@"rows"] count]; }

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)s {
    return [_sections[s][@"title"] length] ? 44 : 6;
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)s {
    NSString *t = _sections[s][@"title"];
    if (!t.length) return nil;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 280, 26)];
    l.text = t;
    l.font = [UIFont boldSystemFontOfSize:20];
    [v addSubview:l];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    static NSString *cid = @"side";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.backgroundColor = [UIColor clearColor];
        UIView *sel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIView *pill = [[UIView alloc] initWithFrame:CGRectMake(10, 2, 300, 40)];
        pill.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        pill.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        pill.layer.cornerRadius = 8;
        [sel addSubview:pill];
        cell.selectedBackgroundView = sel;
    }
    NSDictionary *row = _sections[ip.section][@"rows"][ip.row];
    cell.textLabel.text = row[@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.imageView.image = [MCTheme glyph:(MCGlyph)[row[@"glyph"] integerValue] size:24 color:[MCTheme accent]];
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    NSString *name = _sections[ip.section][@"rows"][ip.row][@"name"];
    UIViewController *vc = [self rootControllerNamed:name];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.tintColor = [MCTheme accent];
    [self showDetailViewController:nav sender:nil];
}

- (UIViewController *)rootControllerNamed:(NSString *)name {
    if ([name isEqualToString:@"Search"]) {
        MCTrackListViewController *v = [[MCTrackListViewController alloc] initWithItems:[MCLibrary songs] title:@"Search"];
        v.showsBigTitle = YES; v.searchEnabled = YES;
        return v;
    }
    if ([name isEqualToString:@"Home"]) return [[MCAlbumGridViewController alloc] initWithMode:MCGridModeHome];
    if ([name isEqualToString:@"New"]) return [[MCAlbumGridViewController alloc] initWithMode:MCGridModeNew];
    if ([name isEqualToString:@"Albums"]) return [[MCAlbumGridViewController alloc] initWithMode:MCGridModeAlbums];
    if ([name isEqualToString:@"Radio"]) return [[MCPlaceholderViewController alloc] initWithTitle:@"Radio"];
    if ([name isEqualToString:@"Playlists"]) return [[MCGroupListViewController alloc] initWithGroups:[MCLibrary playlistGroups] title:@"Playlists" circular:NO];
    if ([name isEqualToString:@"Artists"]) return [[MCGroupListViewController alloc] initWithGroups:[MCLibrary artistGroups] title:@"Artists" circular:YES];
    MCTrackListViewController *v = [[MCTrackListViewController alloc] initWithItems:[MCLibrary songs] title:@"Songs"];
    v.showsBigTitle = YES;
    return v;
}

@end
