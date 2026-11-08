#import "RootViewController.h"
#import "MiniPlayerView.h"
#import "NowPlayingViewController.h"

@implementation MCRootViewController {
    UISplitViewController *_split;
    MCMiniPlayerView *_mini;
}

- (instancetype)initWithSplit:(UISplitViewController *)split {
    self = [super init];
    if (self) _split = split;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self addChildViewController:_split];
    _split.view.frame = self.view.bounds;
    _split.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_split.view];
    [_split didMoveToParentViewController:self];

    _mini = [[MCMiniPlayerView alloc] initWithFrame:CGRectMake(0, 0, 400, 60)];
    __weak MCRootViewController *ws = self;
    _mini.onTap = ^{ [ws showNowPlaying]; };
    [self.view addSubview:_mini];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat sidebar = 320.0, margin = 24.0, h = 60.0;
    CGRect b = self.view.bounds;
    _mini.frame = CGRectMake(sidebar + margin, b.size.height - h - 20.0, b.size.width - sidebar - margin * 2, h);
    [self.view bringSubviewToFront:_mini];
}

- (void)showNowPlaying {
    MCNowPlayingViewController *vc = [[MCNowPlayingViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.preferredContentSize = CGSizeMake(540, 660);
    [self presentViewController:vc animated:YES completion:nil];
}

@end
