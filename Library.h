#import <Foundation/Foundation.h>

// Albums: dicts with title, artist, items (NSArray<MPMediaItem>), rep (MPMediaItem; absent for demo data)
// Groups: dicts with title, subtitle, items, rep (optional)
@interface MCLibrary : NSObject
+ (NSArray *)songs;
+ (NSArray *)albums;
+ (NSArray *)recentAlbums;
+ (NSArray *)demoAlbums;
+ (NSArray *)artistGroups;
+ (NSArray *)playlistGroups;
@end
