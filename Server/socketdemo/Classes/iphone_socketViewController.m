//
//  iphone_socketViewController.m
//  iphone.socket
//
//  Created by wangjun on 10-12-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "iphone_socketViewController.h"


@implementation iphone_socketViewController
@synthesize client,inputMsg,outputMsg,outputView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self connectServer:HOST_IP port:HOST_PORT]; 
    outputStr = [[NSMutableString alloc] initWithCapacity:0];
}


- (int) connectServer: (NSString *) hostIP port:(int) hostPort{  
    if (client == nil) {  
        client = [[AsyncSocket alloc] initWithDelegate:self];  
        NSError *err = nil;  
        if (![client connectToHost:hostIP onPort:hostPort error:&err]) {  
            NSLog(@"%@ %@", [err code], [err localizedDescription]);  
			
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Connection failed to host "   
																	 stringByAppendingString:hostIP]   
                                                            message:[[[NSString alloc]initWithFormat:@"%@",[err code]] stringByAppendingString:[err localizedDescription]]   
                                                           delegate:self   
                                                  cancelButtonTitle:@"OK"  
                                                  otherButtonTitles:nil];  
            [alert show];  
            [alert release];  
            return SRV_CONNECT_FAIL;  
        } else {  
            NSLog(@"Conectou!");  
            return SRV_CONNECT_SUC;  
        }  
    }  
    else {  
        [client readDataWithTimeout:-1 tag:0];  
        return SRV_CONNECTED;  
    }  
}  

- (IBAction) reConnect{  
    int stat = [self connectServer:HOST_IP port:HOST_PORT];  
    switch (stat) {  
        case SRV_CONNECT_SUC:  
            [self showMessage:@"connect success"];  
            break;  
        case SRV_CONNECTED:  
            [self showMessage:@"It's connected,don't agian"];  
            break;  
        default:  
            break;  
    }  
}  

- (IBAction) sendMsg{  
	
    NSString *inputMsgStr = inputMsg.text;  
    NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];  
    NSLog(@"%a",content);  
    NSData *data = [content dataUsingEncoding:NSISOLatin1StringEncoding];  
    [client writeData:data withTimeout:-1 tag:0];  
	
    //[data release];  
    //[content release];  
    //[inputMsgStr release];  
    //继续监听读取  
    //[client readDataWithTimeout:-1 tag:0];  
}  

- (void) showMessage:(NSString *) msg{  
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert!"  
                                                    message:msg  
                                                   delegate:nil  
                                          cancelButtonTitle:@"OK"  
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release];  
}  


#pragma mark socket delegate  

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{  
    [client readDataWithTimeout:-1 tag:0];  
}  



- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err  
{  
    NSLog(@"Error");  
}  


- (void)onSocketDidDisconnect:(AsyncSocket *)sock  
{  
    NSString *msg = @"Sorry this connect is failure";  
    [self showMessage:msg];  
    [msg release];  
    client = nil;  
}  



- (void)onSocketDidSecure:(AsyncSocket *)sock{  
	
	
}  

- (void)scheduleAlarmForDate:(NSString*)theMsg  
{  
    UIApplication* app = [UIApplication sharedApplication];  
    NSArray* oldNotifications = [app scheduledLocalNotifications];  
    // Clear out the old notification before scheduling a new one.  
    if ([oldNotifications count] > 0)  
        [app cancelAllLocalNotifications];  
    // Create a new notification.  
    UILocalNotification* alarm = [[[UILocalNotification alloc] init] autorelease];  
    if (alarm)  
    {  
        alarm.fireDate = [NSDate new];  
        alarm.timeZone = [NSTimeZone defaultTimeZone];  
        alarm.repeatInterval = 0;  
        alarm.soundName = @"alarmsound.caf";  
        alarm.alertBody = theMsg;  
        [app scheduleLocalNotification:alarm];  
    }  
} 

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{  
	
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    NSLog(@"Hava received datas is :%@",aStr);  
    [outputStr appendFormat:@"\n%@",aStr];
    outputView.text = outputStr;  
    [outputView scrollRangeToVisible:NSMakeRange([outputView.text length] - 1, 1)];
    [client readDataWithTimeout:-1 tag:0]; 
    [self scheduleAlarmForDate:aStr];
    [aStr release]; 
}  





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	client=nil;
}

- (void)dealloc {
	[client release];
    [super dealloc];
}


@end




