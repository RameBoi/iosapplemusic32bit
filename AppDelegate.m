#import "AppDelegate.h"
#import "Theme.h"
#import "RootViewController.h"
#import "SidebarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [MCTheme accent];

    MCSidebarViewController *sidebar = [[MCSidebarViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *sideNav = [[UINavigationController alloc] initWithRootViewController:sidebar];
    sideNav.navigationBarHidden = YES;

    UIViewController *blank = [[UIViewController alloc] init];
    blank.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:blank];

    UISplitViewController *split = [[UISplitViewController alloc] init];
    split.viewControllers = @[sideNav, detailNav];
    split.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    split.minimumPrimaryColumnWidth = 320.0;
    split.maximumPrimaryColumnWidth = 320.0;

    self.window.rootViewController = [[MCRootViewController alloc] initWithSplit:split];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
