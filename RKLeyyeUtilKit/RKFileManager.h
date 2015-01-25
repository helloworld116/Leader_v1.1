#import <UIKit/UIKit.h>
@class RKAppDelegate;

@interface RKFileManager : NSObject{
    NSFileManager * fileManager;
    NSArray * docPaths;
    NSString * docPath;
    RKAppDelegate * appDelegate;
    NSManagedObjectContext * managedObjectContext;
    NSManagedObjectModel * managedObjectModel;
    NSPersistentStoreCoordinator * persistentStoreCoordinator;

}

- (BOOL) createDirectory:(NSString *)dirName;
+ (BOOL) writeToFile:(NSString *)fileName withData:(NSData *)data;
+ (NSString *) readImageFromFile:(NSString *)url;

+ (BOOL) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension;

- (void) insertLeyyeDomainWith:(id)sender;

- (NSMutableArray *) queryLeyyeDomain;

+ (void) updateLeyyeDomain:(id) sender;

+ (void) deleteLeyyeDomain:(id) sender;

- (void) insertLeyyeArticle:(id) sender;
- (NSMutableArray *) queryLeyyeArticle;
@end