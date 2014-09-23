//
//  ViewController.m
//  DownloadDemo
//
//  Created by Peter Yuen on 6/26/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import "ViewController.h"
#import "DownloadItem.h"
#import "DownloadManager.h"
#import "Utility.h"
#import "DowningCell.h"

@interface ViewController ()
{
    DownloadItem *item;
    NSMutableDictionary *_urllist;
    NSMutableDictionary *_downinglist;
    NSMutableDictionary *_finishedlist;
}
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
- (IBAction)cancelAll:(id)sender;
- (IBAction)startAll:(id)sender;
- (IBAction)pauseAllClick:(id)sender;
- (IBAction)origDataClick:(id)sender;




-(void)updateUIByDownloadItem:(DownloadItem *)downItem;
@end

@implementation ViewController

-(void)updateCell:(DowningCell *)cell withDownItem:(DownloadItem *)downItem
{
    cell.lblTitle.text=[downItem.url description];
    cell.lblPercent.text=[[NSString stringWithFormat:@"%0.2f",downItem.downloadPercent*100] stringByAppendingString:@"%"];
    [cell.btnOperate setTitle:downItem.downloadStateDescription forState:UIControlStateNormal];
}

-(void)updateUIByDownloadItem:(DownloadItem *)downItem
{
    DownloadItem *findItem=[_urllist objectForKey:[downItem.url description]];
    if(findItem==nil)
    {
        return;
    }
    findItem.downloadStateDescription=downItem.downloadStateDescription;
    findItem.downloadPercent=downItem.downloadPercent;
    findItem.downloadState=downItem.downloadState;
    switch (downItem.downloadState) {
        case DownloadFinished:
        {

        }
            break;
        case DownloadFailed:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
    int index=[_urllist.allKeys indexOfObject:[downItem.url description]];
    DowningCell *cell=(DowningCell *)[self.dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self updateCell:cell withDownItem:downItem];
}

-(void)downloadNotification:(NSNotification *)notif
{
    DownloadItem *notifItem=notif.object;
//    NSLog(@"%@,%d,%f",notifItem.url,notifItem.downloadState,notifItem.downloadPercent);
    [self updateUIByDownloadItem:notifItem];
}
- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadNotification:) name:kDownloadManagerNotification object:nil];

//    NSString *filePath=@"http://s3.amazonaws.com/Trueridge/HTTPScoop_1.4.3.dmg";
//    NSString *desPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"123"];
//    [[DownloadManager sharedInstance]startDownload:filePath withLocalPath:desPath];
    _downinglist=[NSMutableDictionary new];
    _finishedlist=[NSMutableDictionary new];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_urllist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadItem *downItem=[_urllist.allValues objectAtIndex:indexPath.row];
    NSString *url=[downItem.url description];
    
    static NSString *cellIdentity=@"DowningCell";
    DowningCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DowningCell" owner:self options:nil] lastObject];
        cell.DowningCellOperateClick=^(DowningCell *cell){
           
            if([[DownloadManager sharedInstance]isExistInDowningQueue:url])
            {
                [[DownloadManager sharedInstance]pauseDownload:url];
                return;
            }
            NSString *desPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[Utility sharedInstance] md5HexDigest:url]];
            [[DownloadManager sharedInstance]startDownload:url withLocalPath:desPath];
        };
        cell.DowningCellCancelClick=^(DowningCell *cell)
        {
           [[DownloadManager sharedInstance]cancelDownload:url];
        };
    }
    [self updateCell:cell withDownItem:downItem];
    
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)origDataClick:(id)sender {
    
    _urllist=[NSMutableDictionary new];
    
//    NSString *urllistPath=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"Urllist.txt"];
//    NSLog(@"urllistPath=%@",urllistPath);
//    NSString *urlString=[NSString stringWithContentsOfFile:urllistPath encoding:NSUTF8StringEncoding error:nil];
//    NSArray *urllist=[urlString componentsSeparatedByString:@"\n"];
//    _urllist=[NSMutableDictionary new];
//    for(NSString *urlItem in urllist)
//    {
//        if(!urlItem)
//        {
//            continue;
//        }
//        NSArray *itemlist=[urlItem componentsSeparatedByString:@","];
//        NSString *url=[[itemlist lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//        DownloadItem *downItem=[[DownloadItem alloc]init];
//        downItem.url=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        DownloadItem *task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem.url description]];
//        downItem.downloadPercent=task.downloadPercent;
//        if(task)
//        {
//            downItem.downloadState=task.downloadState;
//        }
//        else
//        {
//            downItem.downloadState=DownloadNotStart;
//        }
//
//        [_urllist setObject:downItem forKey:[downItem.url description]];
//    }
    

    
    DownloadItem *downItem=[[DownloadItem alloc]init];
    downItem.url=[NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/3a/12350/QQ5.5.11447.0.1402466158.exe"];
    DownloadItem *task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem.url description]];
    downItem.downloadPercent=task.downloadPercent;
    if(task)
    {
        downItem.downloadState=task.downloadState;
    }
    else
    {
        downItem.downloadState=DownloadNotStart;
    }

    [_urllist setObject:downItem forKey:[downItem.url description]];

    
    
    DownloadItem *downItem2=[[DownloadItem alloc]init];
    downItem2.url=[NSURL URLWithString:@"http://dl2.c9.sendfile.vip.xunlei.com:8000/Dianping-v6.6.5.ipa?key=5a64507ac35b33abb3b449f8fbc0de95&file_url=%2Fgdrive%2Fresource%2FE0%2F9C%2FE04587385689478DEEBBD678BB0A0D6B8E97AD9C&file_type=0&authkey=2E37ED797FABAAF213D3A633112D2322FA18A2A59C27499C4A1D6D13566FE771&exp_time=1405186909&from_uid=181937792&task_id=6018814250602678274&get_uid=1007257009&f=lixian.vip.xunlei.com&reduce_cdn=1&fid=JoUVpB7Y4703v1kthIoFIwAfPb16aCABAAAAAOBFhzhWiUeN7rvWeLsKDWuOl62c&mid=666&threshold=150&tid=B727BE3CB6FA843FA254190F68F37E6F&srcid=7&verno=1"];
    task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem2.url description]];
    downItem2.downloadPercent=task.downloadPercent;
    if(task)
    {
        downItem2.downloadState=task.downloadState;
    }
    else
    {
        downItem2.downloadState=DownloadNotStart;
    }
    [_urllist setObject:downItem2 forKey:[downItem2.url description]];


    DownloadItem *downItem3=[[DownloadItem alloc]init];
    downItem3.url=[NSURL URLWithString:@"http://f.app111.org/2014/02/01/139118788983919/com.lakala.client_4.2.1.ipa"];
    task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem3.url description]];
    downItem3.downloadPercent=task.downloadPercent;
    if(task)
    {
        downItem3.downloadState=task.downloadState;
    }
    else
    {
        downItem3.downloadState=DownloadNotStart;
    }
    [_urllist setObject:downItem3 forKey:[downItem3.url description]];


    DownloadItem *downItem4=[[DownloadItem alloc]init];
    downItem4.url=[NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/c8/25723/Firefox-latest.1402471387.dmg"];
    task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem4.url description]];
    downItem4.downloadPercent=task.downloadPercent;
    if(task)
    {
        downItem4.downloadState=task.downloadState;
    }
    else
    {
        downItem4.downloadState=DownloadNotStart;
    }

    [_urllist setObject:downItem4 forKey:[downItem4.url description]];
    
    
    [self.dataTableView reloadData];

}
- (IBAction)downingClick:(id)sender {
    _urllist=[[DownloadManager sharedInstance]getDownloadingTask];
    [self.dataTableView reloadData];
}

- (IBAction)finishedClick:(id)sender {
    _urllist=[[DownloadManager sharedInstance]getFinishedTask];
    [self.dataTableView reloadData];
}

- (IBAction)cancelAll:(id)sender {
    
    [[DownloadManager sharedInstance]cancelAllDownloadTask];
}

- (IBAction)startAll:(id)sender {
    
    for(NSString *url in _urllist)
    {
        NSString *desPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[Utility sharedInstance] md5HexDigest:url]];
        [[DownloadManager sharedInstance]startDownload:url withLocalPath:desPath];
    }
    
}

- (IBAction)pauseAllClick:(id)sender {
    [[DownloadManager sharedInstance] pauseAllDownloadTask];
}

@end
