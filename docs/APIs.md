##APIs
- [init](#init)
- [startLogPageView](#startlogpageview)
- [stopLogPageView](#stoplogpageview)
- [uploadLocation](#uploadlocation)
- [crashLogON](#crashlogon)
- [setDebug](#setdebug)
- [postEvent](#postevent)


### init

初始化插件

example:

```
plus.JAnalytics.init()
```



### startLogPageView

开始记录页面停留

参数：

- pageName： string

example：

```
plus.JAnalytics.startLogPageView({pageName: "HBuilder page naem"})
```



### stopLogPageView

停止记录页面停留。

参数：

- pageName： string

example：

```
plus.JAnalytics.stopLogPageView({pageName: "HBuilder page naem"})
```



### uploadLocation

上报位置信息 iOS Only

参数：

- latitude：number
- longitude： number

example：

```
plus.JAnalytics.uploadLocation({latitude: 0.4, longitude: 0.5})
```



### crashLogON

开启Crash日志收集，默认是关闭状态.

example：

```
plus.JAnalytics.crashLogON()
```



### setDebug

设置是否打印sdk产生的Debug级log信息, 默认为NO(不打印log)

```
plus.JAnalytics.setDebug({enable: true})
```



### postEvent

上报事件

参数：

     * 除了 extra 其他都是必填
     * @param {object} event 可以为如下 5 种事件
     * 
     * loginEvent = {
     *  type: 'login',  // 必填
     *  extra: Object,  // 附加键值对，格式 {String: String}
     *  method: String，  // 填自己的登录方法
     *  success: Boolean
     * }
     * 
     * registerEvent = {
     *  type: 'register',  // 必填
     *  extra: Object,  // 附加键值对，格式 {String: String}
     *  method: String，  // 填自己的登录方法
     *  success: Boolean
     * }
     *
     * purchaseEvent = {
     *  type: 'purchase', // 必填
     *  extra: Object,  // 附加键值对，格式 {String: String}
     *  goodsType: String,
     *  goodsId: String,
     *  goodsName: String,
     *  success: Boolen,
     *  price: float,
     *  currency: String, // CNY, USD
     *  count: int
     * }
     * 
     * browseEvent = {
     *  type: 'browse',
     *  id: String,
     *  extra: Object,  // 附加键值对，格式 {String: String}
     *  name: String,
     *  contentType: String,
     *  duration: float
     * }
     * 
     * countEvent = {
     *  type: 'count',
     *  extra: Object,  // 附加键值对，格式 {String: String}
     *  id: String
     * }
     * 
     * calculateEvent = {
     *  type: 'calculate',
     *  extra: Object,  // 附加键值对，格式 {String: String}
     *  id: String,
     *  value: double
     * }

example:

```
var LoginEvent = {
  type: 'login',
  extra: {
    userId: "user1"
  },
  method: "login",
  success: true
};
plus.JAnalytics.postEvent(LoginEvent);
```

