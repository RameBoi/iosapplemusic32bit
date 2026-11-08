#import <UIKit/UIKit.h>

@interface MCGroupListViewController : UITableViewController
- (instancetype)initWithGroups:(NSArray *)groups title:(NSString *)title circular:(BOOL)circular;
@end
