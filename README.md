# HACRouter

[![CI Status](http://img.shields.io/travis/sicong.qian/HACRouter.svg?style=flat)](https://travis-ci.org/sicong.qian/HACRouter)
[![Version](https://img.shields.io/cocoapods/v/HACRouter.svg?style=flat)](http://cocoapods.org/pods/HACRouter)
[![License](https://img.shields.io/cocoapods/l/HACRouter.svg?style=flat)](http://cocoapods.org/pods/HACRouter)
[![Platform](https://img.shields.io/cocoapods/p/HACRouter.svg?style=flat)](http://cocoapods.org/pods/HACRouter)

## Example
HACRouter_Example provides simple functions.

## Usage
For detail usage, please go to refer comments in source files.
#### register url
- by api
```ruby
[[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"RouteTestXXXX://PaymentModule/iapPage/buy"] withHandler:@"HACTest"];
```
By the way, the parament handler is nullable. If handler is nil, the url will be handled with the nearest handler. Maybe send to default runtime-handler finally.
- by json file
```ruby
[[HACRouterCenter defautRouterCenter] registerUrlWithJsonFile:@"RouteMap" withCompleteBlk:^(BOOL suc) {
        NSLog(@"load file complete: %d", suc);
    }];
```
You can prepare a config file and manage all your urls. The file is like:
```ruby
{
        "Name": "RouteTest",
        "Handler": "",
        "subNodes": [
                     {
                     "Name": "AcountModule",
                     "Handler": "HACAcountHandler",
                     "subNodes": [
                                  {
                                  "Name": "LoginPage",
                                  "Handler": "",
                                  "subNodes":[
                                              {
                                              "Name": "login",
                                              "Handler":"LoginActionHandler"
                                              }
                                              ]
                                  }
                                  ]
                     }
                     ]
        
    }
```
#### handle url
```ruby
BOOL suc = [[HACRouterCenter defautRouterCenter] handleUrl:[NSURL URLWithString:self.textField.text]
                                                  withCallback:^(NSDictionary *dic, NSError *error) {
                                                      NSLog(@"callback: %@", dic);
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          self.showLabel.text = [dic description];
                                                      });
                                                  }
                strict:YES];
```
You can get retuned information in callback block. The parament 'strict' tells router whether to check the url strictly. If strict is NO, a nearest handler will be called if the url is not directly found in route tree.

- default handler
There is a default handler provided in router. Url will be send to defaut handler, if it is not registed and 'strict' is NO. For example: Schemel://Module/Page/Func?key=value
If the url is not found, and the nearest handler is default handler. The last 2 string route paraments will be get out: 'Page' and 'Func'. Then the default handler will try to send a runtime message like this:
```ruby
objc_msgSend(Page, Func)
```
If you have a Class 'Page', and a method 'Func' in it, the method will be executed. If not, the callback will get a error info. 

- custom handler
You can register url with custom handler. The handler should implements HACRouterHandlerProtocol. The url will be send to handler registed. You can do some check in
```ruby
+ (void)handleRouteUrl:(HACRouteURL *)url withCallback:(HACRouterRet)callback ;
```
## Installation

```ruby
pod 'HACRouter', :git => 'https://github.com/Hotacool/HACRouter.git', :tag => '0.1.0'
```

## Author

sicong.qian, shisosen@163.com

## License

HACRouter is available under the MIT license. See the LICENSE file for more info.
