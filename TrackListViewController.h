#import <UIKit/UIKit.h>

@interface MCTrackListViewController : UITableViewController <UISearchBarDelegate>
@property (nonatomic) BOOL showsBigTitle;
@property (nonatomic) BOOL searchEnabled;
- (instancetype)initWithItems:(NSArray *)items title:(NSString *)title;
@end
