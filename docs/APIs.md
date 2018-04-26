##APIs
- [init](#init)
- [startLogPageView](#startlogpageview)
- [stopLogPageView](#stoplogpageview)
- [uploadLocation](#uploadlocation)
- [crashLogON](#crashlogon)
- [setDebug](#setdebug)
- [postEvent](#postevent)
- [identifyAccount](#identifyaccount)
- [detachAccount](#detachaccount)
- [setFrequency](#setfrequency)


### init

初始化插件

example:

```javascript
plus.JAnalytics.init()
```



### startLogPageView

开始记录页面停留

#### 参数：

- pageName (string)： 页面名字

example：

```javascript
plus.JAnalytics.startLogPageView({pageName: "HBuilder page naem"})
```



### stopLogPageView

停止记录页面停留。

#### 参数：

- pageName (string)： 页面名字

example：

```javascript
plus.JAnalytics.stopLogPageView({pageName: "HBuilder page naem"})
```



### uploadLocation

上报位置信息 iOS Only

#### 参数：

- latitude (number)： 纬度
- longitude (number)：  经度

example：

```javascript
plus.JAnalytics.uploadLocation({latitude: 0.4, longitude: 0.5})
```



### crashLogON

开启Crash日志收集，默认是关闭状态.

example：

```javascript
plus.JAnalytics.crashLogON()
```



### setDebug

设置是否打印sdk产生的Debug级log信息, 默认为NO(不打印log)

#### 参数：

- enable (true)

```javascript
plus.JAnalytics.setDebug({enable: true})
```



### postEvent

上报事件

#### 参数：

【event 可以为如下 5 种事件】除了 extra 其他都是必填字段：

- loginEvent：
  - type: 'login',  // 必填
  - extra: Object?,  // 附加键值对，格式 {String: String}
  - method: String，  // 填自己的登录方法
  - success: Boolean
- registerEvent
  - type: 'register',  // 必填
  - extra: Object?,  // 附加键值对，格式 {String: String}
  - method: String，  // 填自己的注册方法
  - success: Boolean
- purchaseEvent
  - type: 'purchase', // 必填
  - extra: Object?,  // 附加键值对，格式 {String: String}
  - goodsType: String, // 商品类型
  - goodsId: String, // 商品 ID
  - goodsName: String, // 商品名字
  - success: Boolen,
  - price: float, // 商品价格
  - currency: String, // CNY, USD
  - count: int // 数量
- browseEvent
  - type: 'browse', 
  - id: String, //内容ID
  - extra: Object?,  // 附加键值对，格式 {String: String}
  - name: String,
  - contentType: String, //内容类型
  - duration: float //内容时长
- countEvent
  - type: 'count',
  - extra: Object?,  // 附加键值对，格式 {String: String}
  - id: String
- calculateEvent
  - type: 'calculate',
  - extra: Object?,  // 附加键值对，格式 {String: String}
  - id: String,
  - value: double


example:

```javascript
var LoginEvent = {
  type: 'login',
  extra: {
    userId: "user1"
  },
  method: "login",
  success: true
};
plus.JAnalytics.postEvent(LoginEvent);


var registerEvent = {
  type: 'register',
  method: 'register',
  success: true
}
plus.JAnalytics.postEvent(registerEvent);
```

### identifyAccount

设置（绑定）用户信息

@param {object} userInfo:

```javascript
accountID: string,   账号ID、必填
creationTime: number?,  //账号创建时间、时间戳
sex: string?,  // 可以为 male/female/unknown
birthdate: string?, // 出生年月，yyyyMMdd格式校验
paid: string?, // 可以为 paid/unpaid/unknown
phone: string?, // 手机号码
email: string?, // 电子邮箱地址
name: string?, // 用户名
wechatID: string?, // 微信 ID
qqID: string?, // QQ id
weiboID: string? // 新浪微博 ID
 
extras: object? // 附加信息，如果以上字段无法满足你，可以使用附加字段来存储二外的信息
```

example:

```javascript
plus.JAnalytics.identifyAccount({
  accountID: 'huminios',
  creationTime: 86400,
  sex: 'female',
  birthdate: 19950116,
  paid: 'unpaid',
  phone: '13612983333',
  email: '13612983333@qq.com',
  name: 'username_huminios',
  wechatID: 'xxwechatID_huminios',
  qqID: 'xxqqID_huminios',
  weiboID: 'xxweboID_huminios',
  extras: {
    key1: 'value1',
    key2: 5
  }
}, function () {
  // success callback
  alert('success')
})
```

### detachAccount

解绑当前的用户信息

example:

```javascript
plus.JAnalytics.detachAccount(function () {
  // success callback
  alert('success')
})
```

### setFrequency

设置周期上报频率，默认为未设置频率，即时上报。

#### 参数

- frequency (number):  周期上报频率单位秒

example:

```javascript
plus.JAnalytics.setFrequency({
    frequency: 0
  })
```

