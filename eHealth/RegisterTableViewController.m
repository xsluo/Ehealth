//
//  RegisterTableViewController.m
//  eHealth
//
//  Created by nh neusoft on 15-1-4.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "RegisterTableViewController.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"RegisterMember"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface RegisterTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textCaptchar;
@property (weak, nonatomic) IBOutlet UILabel *textPassword;
@property (weak, nonatomic) IBOutlet UILabel *textConfirmpwd;
@property (weak, nonatomic) IBOutlet UITextField *textMember;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellMale;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFamele;
@property (copy,nonatomic) NSString *strGender;

@property(nonatomic,retain)   NSMutableData *responseData;
@property (copy,nonatomic) NSMutableString *resultCode;

- (IBAction)getCAPTCHA:(id)sender;
- (IBAction)registerMember:(id)sender;



@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.cellMale.accessoryType = UITableViewCellAccessoryCheckmark;
    self.cellFamele.accessoryType = UITableViewCellAccessoryNone;
    self.strGender = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//

-(double)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
        return 30;
    else
        return 20.0;
}

 -(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 44.0;
 }



/* - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==3 &&[indexPath row]==0){
        self.cellMale.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellFamele.accessoryType = UITableViewCellAccessoryNone;
        self.strGender = @"0";
    }
    if([indexPath section]==3 &&[indexPath row]==1){
        self.cellMale.accessoryType = UITableViewCellAccessoryNone;
        self.cellFamele.accessoryType = UITableViewCellAccessoryCheckmark;
        self.strGender = @"1";
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    if([_responseData length]==0)
        return;
    
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    if (jsonDictionary == nil) {
        NSLog(@"json parse failed");
        return;
    }
    self.resultCode =[jsonDictionary objectForKey:@"ResultCode"];
    if([self.resultCode isEqualToString:@"0000"]){
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:self.textName.text forKey:kUserName];
//        [userDefaults setObject:self.textPwd.text forKey:kPassWord];
//        [userDefaults synchronize];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"注册成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
}



- (IBAction)getCAPTCHA:(id)sender {
}

- (IBAction)registerMember:(id)sender {
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:4];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:self.textPhone.text  forKey:@"PhoneNumber"];
    [dictionary setObject:self.textPassword.text forKey:@"Password"];
    [dictionary setObject:self.textConfirmpwd.text forKey:@"ConfirmPassword"];
    [dictionary setObject:self.textCaptchar.text forKey:@"CAPTCHA"];
    [dictionary setObject:self.textMember.text forKey:@"MemberName"];
    [dictionary setObject:self.strGender forKey:@"Sex"];
    
 
    NSError *error=nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=%@&jsonBody=%@",Method,jsonString];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    
}
@end
