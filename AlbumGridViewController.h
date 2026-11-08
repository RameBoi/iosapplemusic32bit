#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MCGridMode) { MCGridModeHome, MCGridModeNew, MCGridModeAlbums };

@interface MCAlbumGridViewController : UICollectionViewController
- (instancetype)initWithMode:(MCGridMode)mode;
@end
