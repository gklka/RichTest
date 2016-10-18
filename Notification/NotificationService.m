//
//  NotificationService.m
//  Notification
//
//  Created by GK on 2016.10.03..
//  Copyright © 2016. GKSoftware. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSLog(@"didReceive");

    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];

    NSString *urlString = request.content.userInfo[@"aps"][@"data"][@"attachment-url"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (urlString) {
        NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (location) {
                NSString *tempDirectory = NSTemporaryDirectory();
                NSString *tempFile = [NSString stringWithFormat:@"file://%@%@", tempDirectory, [url lastPathComponent]];
                NSURL *tempURL = [NSURL URLWithString:tempFile];
                
                NSError *error;
                [[NSFileManager defaultManager] moveItemAtURL:url toURL:tempURL error:&error];
                if (error) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                    return;
                }

                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"banana" URL:tempURL options:nil error:&error];
                self.bestAttemptContent.attachments = @[attachment];
            }
            self.contentHandler(self.bestAttemptContent);
        }];
        
        [task resume];
    } else {
        self.contentHandler(self.bestAttemptContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    NSLog(@"expire");
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
