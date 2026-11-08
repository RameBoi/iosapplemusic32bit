#import "PlaceholderViewController.h"
#import "Theme.h"

@implementation MCPlaceholderViewController {
    NSString *_name;
    UILabel *_big;
    UIImageView *_hero;
    UILabel *_note;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) _name = [title copy];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _big = [[UILabel alloc] init];
    _big.font = [UIFont boldSystemFontOfSize:34];
    _big.text = _name;
    [self.view addSubview:_big];

    _hero = [[UIImageView alloc] initWithImage:[MCTheme gradientArtForSeed:_name size:400]];
    _hero.contentMode = UIViewContentModeScaleAspectFill;
    _hero.layer.cornerRadius = 14;
    _hero.layer.masksToBounds = YES;
    [self.view addSubview:_hero];

    _note = [[UILabel alloc] init];
    _note.text = [NSString stringWithFormat:@"%@ isn't available in this build.", _name];
    _note.textColor = [UIColor whiteColor];
    _note.font = [UIFont boldSystemFontOfSize:22];
    _note.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_note];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat w = self.view.bounds.size.width;
    _big.frame = CGRectMake(28, 76, w - 56, 44);
    _hero.frame = CGRectMake(28, 136, w - 56, 280);
    _note.frame = CGRectMake(48, 136 + 120, w - 96, 40);
}

@end
