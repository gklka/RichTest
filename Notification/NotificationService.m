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

    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];

    // Add image attachment
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"banana" withExtension:@"gif"];
    NSError *error;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"banana" URL:fileURL options:nil error:&error];
    self.bestAttemptContent.attachments = @[attachment];
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
