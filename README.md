# DownloadDemo
![img](https://github.com/zziazm/DownloadDemo/blob/master/demog.gif)



####断点续传


断点续传的原理是在HTTP1.1协议（RFC2616）中定义了断点续传相关的HTTP头的Range和Content-Range字段，支持只请求资源的一部分。
Range：可以请求文件资源的一个或者多个子范围。
例如：
　　表示头500个字节：bytes=0-499；
　　表示第二个500字节：bytes=500-999；
　　表示最后500个字节：bytes=-500；
　　表示500字节以后的范围：bytes=500-　；　
　　第一个和最后一个字节：bytes=0-0,-1；
　　同时指定几个范围：bytes=500-600,601-999；

Content-Range：字段说明服务器返回了文件的某个范围及文件的总长度。这时Content-Length字段就不是整个文件的大小了，而是对应文件这个范围的字节数，这一点一定要注意。一般格式，Content-Range: bytes 500-999/1000　　

###NSURlSessionDownloadTask
iOS可以使用NSURlSessionDownloadTask来实现下载的断点续传功能，它提供了resumeData来实现断点续传功能，不需要在httpheader里设置Range了。网上关于NSURlSessionDownloadTask实现断点续传下载的代码有很多，这里总结下自己遇到的问题。

###下载暂停和恢复
NSURlSessionDownloadTask有两种实现暂停的方法：
- ` suspend`：直接调`suspend`方法可以使task暂停下载，恢复下载可以调用resume方法，；
- `cancelByProducingResumeData:`:这个方法会取消task，从block里会得到一个`resumeData`。`resumeData`是用来恢复下载的。由于之前的task已经被取消了，方法`downloadTaskWithResumeData:`可以使用`resumeData`来获取一个新的NSURlSessionDownloadTask来继续下载。

在使用`suspend时`碰到的问题：
 如果一个task正在下载，调用suspend暂停task后，然后com+R重启应用，虽然在session的`getTasksWithCompletionHandler:`的block里能够获取到task，但是重新resume的时候有时候会失败，有时候成功，不知道为什么。所以建议使用cancelByProducingResumeData来实现暂停功能。

把resumeData转成字符串打印看一下：
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSURLSessionDownloadURL</key>
	<string>http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg</string>
	<key>NSURLSessionResumeBytesReceived</key>
	<integer>8297040</integer>
	<key>NSURLSessionResumeCurrentRequest</key>
	<data>
        ...
	</data>
	<key>NSURLSessionResumeInfoTempFileName</key>
	<string>CFNetworkDownload_sFZ0E8.tmp</string>
	<key>NSURLSessionResumeInfoVersion</key>
	<integer>4</integer>
	<key>NSURLSessionResumeOriginalRequest</key>
	<data>
	     ...
	</data>
	<key>NSURLSessionResumeServerDownloadDate</key>
	<string>Thu, 12 May 2016 02:41:27 GMT</string>
</dict>
</plist>
```
可以看出，resumeData实质是一个plist文件，里面包含了一些下载的信息，NSURLSessionResumeBytesReceived对应的是已经下载的字节数，NSURLSessionResumeInfoTempFileName对应的是下载的临时文件的名字。

如果下载出现错误，文档里是这样描述的
>When any task completes, the `NSURLSession` object calls the delegate’s [`URLSession:task:didCompleteWithError:`](https://developer.apple.com/documentation/foundation/nsurlsessiontaskdelegate/1411610-urlsession?language=objc) method with either an error object or `nil` (if the task completed successfully). If the download task can be resumed, the `NSError` object’s `userInfo` dictionary contains a value for the [`NSURLSessionDownloadTaskResumeData`](https://developer.apple.com/documentation/foundation/nsurlsessiondownloadtaskresumedata?language=objc) key. Your app should pass this value to call [`downloadTaskWithResumeData:`](https://developer.apple.com/documentation/foundation/nsurlsession/1409226-downloadtaskwithresumedata?language=objc) or [`downloadTaskWithResumeData:completionHandler:`](https://developer.apple.com/documentation/foundation/nsurlsession/1411598-downloadtaskwithresumedata?language=objc) to create a new download task that continues the existing download. If the task can’t be resumed, your app should create a new download task and restart the transaction from the beginning. In either case, if the transfer failed for any reason other than a server error, go to step 3 (creating and resuming task objects).

出错时会调用`URLSession:task:didCompleteWithError:`获得error对象，如果下载是可以恢复的，可以使用`error.userInfo[NSURLSessionDownloadTaskResumeData]`来获取resumeData恢复下载。有两种情况获取resumeData:
- task调用`cancelByProducingResumeData:`之后会调用`URLSession:task:didCompleteWithError:`来获取resumeData，
- 还有user主动kill应用后系统会取消下载中的task，重新启动时创建session后也可以在`URLSession:task:didCompleteWithError:`里获取到resumeData。




#####NSURLSessionDownloadTask在后台下载
NSURLSessionDownloadTask是支持后台下载的。
[downloading_files_in_the_background](https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background)
[Downloading Content in the Background](https://developer.apple.com/library/archive/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html#//apple_ref/doc/uid/TP40007072-CH5-SW6)
>When downloading files, apps should use an NSURLSession object to start the downloads so that the system can take control of the download process in case the app is suspended or terminated. When you configure an NSURLSession object for background transfers, the system manages those transfers in a separate process and reports status back to your app in the usual way. If your app is terminated while transfers are ongoing, the system continues the transfers in the background and launches your app (as appropriate) when the transfers finish or when one or more tasks need your app’s attention.

>Once configured, your NSURLSession object seamlessly hands off upload and download tasks to the system at appropriate times. If tasks finish while your app is still running (either in the foreground or the background), the session object notifies its delegate in the usual way. If tasks have not yet finished and the system terminates your app, the system automatically continues managing the tasks in the background. If the user terminates your app, the system cancels any pending tasks.

文档里提到了app的几种情况：
- 如果app在后台，但是is still running（比如按home键把app切到后台），会正常调用session的代理方法;
- 如果app被系统terminate了（比如app在后台时间过长可能会被系统强制杀掉），系统会继续在后台管理session的task，当task完成时系统会启动app，此时只要使用相同的id创建session就会回调代理方法了；
- 如果使用户主动kill了app，系统会取消session的task，重新启动时，用相同的id创建session，会调用代理方法`URLSession:task:didCompleteWithError:`，可以获取到resumeData来恢复下载。

#####在后台下载完成时的处理
下载任务在后台完成后：
如果app在后台，但是没有被系统teminate，系统会resume 应用并且调用UIApplicationDelegate的代理方法`application:handleEventsForBackgroundURLSession:completionHandler:`。之后会调用session的代理方法。
如果app在后台时候被系统terminate了，当下载task完成时，系统会在后台重启应用并调用UIApplicationDelegate的代理方法`application:handleEventsForBackgroundURLSession:completionHandler:`。方法里获得的identifier是之前创建session时的identifier。需要用这个idetifier重新创建session，之后会调用session的代理方法。

调用这个方法获得的completionHandler可以让系统知道您的应用程序的用户界面已更新，并且可以拍摄新的快照。一般在session的代理方法`URLSessionDidFinishEventsForBackgroundURLSession:`中调用。

######在下载过程中用户主动kill app
用户主动kill app会导致下载task取消，当应用再次启动时，需要使用之前创建session的identifier重新创建session，之后会调用`URLSession: task:
didCompleteWithError:`方法，从error中可以获取resumeData来恢复下载。

###系统终止了app，重启时获取下载中的task
比如应用退到后台，因为内存问题被系统teminate，这时候下载任务不会取消，系统会继续管理下载task，此时若重新打开应用，可以使用相同的identifier创建session，然后通过
```
[self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
     
   }];
```
这个方法来获取task。如果在模拟器上正在进行下载任务，然后com+R重新运行程序也可以使用这个方法获取之前创建的下载task。

如果task在下载过程中用户主动kill app，task会被取消，再重新启动应用时。上面的这个方法会获取到取消的task，它的state是`NSURLSessionTaskStateCompleted`,不能使用这个task继续请求了，可以从session的代理方法里获取resumeData重新创建task来继续请求。

