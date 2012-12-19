//
//  iphone_socketViewController.h
//  iphone.socket
//
//  Created by wangjun on 10-12-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#define SRV_CONNECTED 0  
#define SRV_CONNECT_SUC 1  
#define SRV_CONNECT_FAIL 2  
#define HOST_IP @"192.168.40.24"
#define HOST_PORT 19998

@interface iphone_socketViewController : UIViewController {	
    UITextField *inputMsg;  
    UILabel *outputMsg;  
    AsyncSocket *client;
    NSMutableString *outputStr;
    IBOutlet UITextView  *outputView;
}  

@property (nonatomic, retain) AsyncSocket *client;  
@property (nonatomic, retain)  UITextField *inputMsg;  
@property (nonatomic, retain)  UILabel *outputMsg;  
@property (nonatomic, retain)  UITextView  *outputView;

- (int) connectServer: (NSString *) hostIP port:(int) hostPort;  
- (void) showMessage:(NSString *) msg;  
- (IBAction) sendMsg;  
- (IBAction) reConnect;  
- (IBAction) textFieldDoneEditing:(id)sender;  
- (IBAction) backgroundTouch:(id)sender;  

@end  
