#import "GroupListViewController.h"
#import "TrackListViewController.h"
#import "Theme.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MCGroupListViewController {
    NSArray *_groups;
    NSString *_name;
    BOOL _circular;
}

- (instancetype)initWithGroups:(NSArray *)groups title:(NSString *)title circular:(BOOL)circular {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _groups = groups ? groups : @[];
        _name = [title copy];
        _circular = circular;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 64;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    self.tableView.tableHeaderView = [MCTheme bigTitleHeader:_name width:self.view.bounds.size.width];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 100)];
    if (_groups.count == 0) {
        UILabel *empty = [[UILabel alloc] init];
        empty.text = [NSString stringWithFormat:@"No %@ found.\nSync music to this iPad with iTunes.", [_name lowercaseString]];
        empty.numberOfLines = 0;
        empty.textAlignment = NSTextAlignmentCenter;
        empty.textColor = [MCTheme secondaryText];
        empty.font = [UIFont systemFontOfSize:17];
        self.tableView.backgroundView = empty;
    }
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return _groups.count; }

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    static NSString *cid = @"group";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
        cell.imageView.layer.masksToBounds = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [MCTheme secondaryText];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *g = _groups[ip.row];
    cell.textLabel.text = g[@"title"];
    cell.detailTextLabel.text = g[@"subtitle"];
    MPMediaItem *rep = g[@"rep"];
    cell.imageView.image = rep ? [MCTheme artworkForItem:rep size:52] : [MCTheme gradientArtForSeed:g[@"title"] size:52];
    cell.imageView.layer.cornerRadius = _circular ? 26 : 6;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    NSDictionary *g = _groups[ip.row];
    MCTrackListViewController *v = [[MCTrackListViewController alloc] initWithItems:g[@"items"] title:g[@"title"]];
    [self.navigationController pushViewController:v animated:YES];
}

@end
