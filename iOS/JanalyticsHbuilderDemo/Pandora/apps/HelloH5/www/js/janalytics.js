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
      console.log('Javascript callback error: ' + errorMsg)
    },
    fireDocumentEvent: function (ename, jsonData) {
      var event = document.createEvent('HTMLEvents')
      event.initEvent(ename, true, true)
      event.eventType = 'message'

      jsonData = JSON.stringify(jsonData)
      var data = JSON.parse(jsonData)
      event.arguments = data
      document.dispatchEvent(event)
    },
    // Common method

       /**
     * 初始化插件
     * 
     * @param {object} params = {
     *  appKey: String       //极光控制台上注册的应用 appKey
     * }
     */
    setup: function (params) {
      this.callNative('setup', [params], null)
      
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
      this.callNative('crashLogON', [params], null)
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
    }
  }

  // JAnalyticsPlugin.init()
  window.plus.JAnalytics = JAnalyticsPlugin
}, true)