/*
 *
 */
#import "RKFileManager.h"
#import "RKAppDelegate.h"
#import "RKLeyyeDomain.h"
#import "RKLeyyeArticle.h"

@implementation RKFileManager

- (id) init{
    self = [super init];
    if (self) {
        fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (BOOL) createDirectory:(NSString *)dirName{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    docPath = [docPaths objectAtIndex:0];
    NSString * dirPath = [docPath stringByAppendingPathComponent:dirName];
    BOOL isDir = TRUE;
    if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
        NSError * error;
        if([fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error]){
            NSLog(@"%@文件夹创建成功",dirName);
            NSLog(@"文件夹路径:%@",dirPath);
            return YES;
        }
        NSLog(@"error:%@,\tinfo:%@",error,[error userInfo]);
        return NO;
    }
    NSLog(@"%@文件夹已存在",dirName);
    return NO;
}

+ (BOOL) writeToFile:(NSString *)fileName withData:(NSData *)data{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * docPath = [docPaths objectAtIndex:0];
    NSString * filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"pic/%@",fileName]];
    if (![fileManager fileExistsAtPath:filePath]) {
        if ([data writeToFile:filePath atomically:YES]) {
            NSLog(@"%@文件写入成功:%@",fileName,filePath);
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (NSString *) readImageFromFile:(NSString *)url{
    NSString * allName = [url lastPathComponent];
    NSArray * docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * docPath = [docPaths objectAtIndex:0];
    NSString * filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"pic/%@",allName]];
    if (filePath != nil) {
        return filePath;
    }
    return nil;
}

+ (BOOL) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension{
    NSArray * docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * docPath = [docPaths objectAtIndex:0];
    NSString * picDir = [NSString stringWithFormat:@"%@/%@",docPath,@"pic"];
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[picDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        return YES;
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[picDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        return YES;
    } else {
        NSLog(@"文件后缀不认识");
        return NO;
    }
}


- (void) insertLeyyeDomainWith:(id) sender{
    RKLeyyeDomain * managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"RKLeyyeDomain" inManagedObjectContext:managedObjectContext];
    RKLeyyeDomain * domain = (RKLeyyeDomain *)sender;
    managedObject.domainTitle = domain.domainTitle;
    managedObject.domainIcon = domain.domainIcon;
    //    [managedObject setValue:[NSNumber numberWithLong:domain.domainId] forKey:@"domainId"];
    //    [managedObject setValue:domain.domainTitle forKey:@"domainTitle"];
    //    [managedObject setValue:domain.domainIcon forKey:@"domainIcon"];
    //    [managedObject setValue:[NSNumber numberWithInt:domain.userCount] forKey:@"userCount"];
    NSError * error;
    if (![managedObjectContext save:&error]) {
        debugLog(@"保存出错：error:%@,info:%@",error,[error userInfo]);
    }
}

- (NSMutableArray *) queryLeyyeDomain{
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"RKLeyyeDomain" inManagedObjectContext:managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError * error = nil;
    NSMutableArray * result=[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (request != nil) {
//        for (RKLeyyeDomain * domain in result) {
//            debugLog(@"查询结果domain：%@",domain.domainIcon);
//        }
        return result;
    }
    return nil;
}

+ (void) updateLeyyeDomain:(id) sender{
    
}

+ (void) deleteLeyyeDomain:(id) sender{
//    RKLeyyeDomain *domain = (RKLeyyeDomain *) sender;
//    [self.managedObjectContext deleteObject:sender];
//    NSError * error;
//    if (![self.managedObjectContext save:&error]) {
//        debugLog(@"删除实体出错:%@,%@",error,[error userInfo]);
//    }
}

- (void) insertLeyyeArticle:(id) sender{
    RKLeyyeArticle * managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"RKLeyyeDomain" inManagedObjectContext:managedObjectContext];
    RKLeyyeArticle * domain = (RKLeyyeArticle *)sender;
    managedObject.title = domain.title;
    managedObject.content = domain.content;
    //    [managedObject setValue:[NSNumber numberWithLong:domain.domainId] forKey:@"domainId"];
    //    [managedObject setValue:domain.domainTitle forKey:@"domainTitle"];
    //    [managedObject setValue:domain.domainIcon forKey:@"domainIcon"];
    //    [managedObject setValue:[NSNumber numberWithInt:domain.userCount] forKey:@"userCount"];
    NSError * error;
    if (![managedObjectContext save:&error]) {
        debugLog(@"保存出错：error:%@,info:%@",error,[error userInfo]);
    }
}

- (NSMutableArray *) queryLeyyeArticle{
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"RKLeyyeArticle" inManagedObjectContext:managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError * error = nil;
    NSMutableArray * result = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (request != nil) {
        return result;
    }
    return nil;
}

@end