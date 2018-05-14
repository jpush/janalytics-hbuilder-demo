document.addEventListener('plusready', function () {
  var _BARCODE = 'JAnalytics' // 插件名称
  var B = window.plus.bridge

  var JAnalyticsPlugin = {

    callNative: function (fname, args, successCallback) {
      var callbackId = this.getCallbackId(successCallback, this.errorCallback)
      if (args != null) {
        args.unshift(callbackId)
      } else {
        var args = [callbackId]
      }
      return B.exec(_BARCODE, fname, args)
    },
    getCallbackId: function (successCallback) {
      var success = typeof successCallback !== 'function' ? null : function (args) {
        successCallback(args)
      }
      return B.callbackId(success, this.errorCallback)
    },
    errorCallback: function (errorMsg) {
      alert('Javascript callback error: ' + JSON.stringify(errorMsg))
      console.warn('Javascript callback error: ' + JSON.stringify(errorMsg))
    },

    // Common method

   /**
     * 初始化插件
     */
    init: function () {
      if (plus.os.name == 'Android') {
        this.callNative('init', null, null)  
      }
      // iOS 不需要调用 setup 方法。
    },
    
    /**
     * 开始记录页面停留
     * 
     * @param {object} params = {
     *  pageName: Stirng   // 页面名称，用于标识页面
     * }
     * 
     */
    startLogPageView: function(params) {
      this.callNative('startLogPageView', [params], null)
    },

    /**
     * 停止记录页面停留
     * 
     * @param {object} params = {
     *  pageName: Stirng   // 页面名称，用于标识页面
     * }
     */
    stopLogPageView: function(params) {
      this.callNative('stopLogPageView', [params], null)
    },

    /**
     * 上报位置信息 iOS Only
     * 
     * @param {object} params = {
     *  latitude: float   // 经度
     *  longitude: float  // 纬度
     * }
     */
    uploadLocation: function(params) {
      this.callNative('uploadLocation', [params], null)
    },

    /**
     * 开启Crash日志收集，默认是关闭状态.
     */
    crashLogON: function() {
      this.callNative('crashLogON', null, null)
    },

    /**
     * 设置是否打印sdk产生的Debug级log信息, 默认为NO(不打印log)
     * 
     * @param {object} params = {
     *  enable: Boolean //
     * }
     */
    setDebug: function(params) {
      this.callNative('setDebug', [params], null)
    },

    /**
     * 上报事件
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
     */
    postEvent: function(event) {
      this.callNative('postEvent', [event], null)
    },

    /**
     * 设置（绑定）用户信息
     * @param userInfo = {
     *  accountID: string,   账号ID、必填
     *  creationTime: number?,  //账号创建时间、时间戳
     *  sex: string?,  // 可以为 male/female/unknown
     *  birthdate: string?, // 出生年月，yyyyMMdd格式校验
     *  paid: string?, // 可以为 paid/unpaid/unknown
     *  phone: string?, // 手机号码
     *  email: string?, // 电子邮箱地址
     *  name: string?, // 用户名
     *  wechatID: string?, // 微信 ID
     *  qqID: string?, // QQ id
     *  weiboID: string? // 新浪微博 ID
     * 
     *  extras: object? // 附加信息，如果以上字段无法满足你，可以使用附加字段来存储二外的信息
     * }
     */
    identifyAccount: function(userInfo, success) {
      this.callNative('identifyAccount', [userInfo], success)
    },
    
    /**
     * 解绑当前的用户信息
     */
    detachAccount: function(success) {
      this.callNative('detachAccount', null, success)
    },
    
    /**
     * 设置周期上报频率
     * 默认为未设置频率，即时上报
     * @param param = {
     *  frequency: number
     * }
     * 周期上报频率单位秒
     * 频率区间：0 或者 10 < frequency < 24*60*60
     * 可以设置为0，即表示取消周期上报频率，改为即时上报
     */
    setFrequency: function(param) {
      this.callNative('setFrequency', [param], null)
    }

  }

  window.plus.JAnalytics = JAnalyticsPlugin
}, true)