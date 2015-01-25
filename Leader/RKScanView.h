//
//  ScanViewController.h
//  oschina
//
//  Created by Roderick on 14-3-23.
//  Copyright (c) 2014年 OSChina.NET All rights reserved.
//

#import "ZBarReaderViewController.h"
//#import "JSONKit.h"
//#import "Scan.h"

@interface RKScanView : ZBarReaderViewController<ZBarReaderDelegate>



- (id) init;

- (void) setOverLayPickerView;

@end
