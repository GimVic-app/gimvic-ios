//
//  VDDUrnikSource.h
//  GimVic
//
//  Created by Vid Drobnič on 11/08/14.
//  Copyright (c) 2014 Vid Drobnič. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDDUrnikSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithIndex:(int)index data:(NSArray *)urnikData;
- (void)reloadData:(NSArray *)newData;

@end