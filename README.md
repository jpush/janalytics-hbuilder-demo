# JAnalytics HBuilder Demo

### iOS 集成

- 将 [JAnalytics_Plugin](./iOS/JAnalytics_Plugin) 文件夹拖到自己的工程里，拖拽的时候选择 create groups【注意：如果已经集成过 JPush 插件需要将 jcore-x.x.x.a 文件删除，不然会出现代码重复错误】。

- 在 [JAnalytics_Plugin/JAnalyticsConfig.plist](./iOS/JAnalytics_Plugin/JAnalyticsConfig.plist) 中配置 APP_KEY、channel、advertisingId、isProduction。

- 将 [janalytics.js](./janalytics.js) 复制到 Pandora/apps/HelloH5/www/js/ 目录中。

- 在需要用到统计的地方导入 janalytics.js 文件。

- 配置 feature.plist ，在 Xcode 中打开 ../PandoraApi.bundle/ 目录下的 feature.plist ，为插件添加新的 item：

  ![屏幕快照 2018-04-25 下午9.51.01](./docs/feature.png)

- 打开 xcode，点击工程目录中顶部的 工程，选择(Target -> Build Phases -> Link Binary With Libraries)，添加以下 framework 依赖：

  - UIKit
  - SystemConfiguration
  - CoreTelephony
  - CoreGraphics
  - Security
  - Foundation
  - CoreLocation
  - CoreFoundation
  - CFNetwork
  - libz.tbd（libz.dylib）
  - libresolv.tbd


### Android

#### Demo 用法

通过 Android Studio 引入项目目录下的 android 目录，再替换 ./android/app/build.gradle 中的「应用的包名」和「应用的 AppKey」。

#### 集成指南

HBuilder 项目集成第三方插件，需先参考 HBuilder 官方的[离线打包](https://ask.dcloud.net.cn/article/924)教程，将您的 HBuilder 项目集成进 Android 工程中。之后再执行以下步骤：
1. 拷贝 `./android/app/src/main/java/io.dcloud.feature.janalytics` 文件夹至你 Android Studio 工程的 `/src/main/java/` 目录下。
2. 拷贝 `./janalytics.js` 到你 Android Studio 工程的 `/assets/apps/HBuilder应用名/js/` 下。
3. 在 `/assets/apps/你的应用名/www/manifest.json` 文件中添加：

    ```json
    "JAnalytics":{
			"description": "统计"
		}
    ```

4. 在 `/assets/data/dcloud_properties.xml` 中添加（如果已存在 Push feature，可以直接修改）：

    ```xml
    <feature name="JAnalytics" value="io.dcloud.feature.janalytics.JAnalyticsService" />
    ```

5. 在 `app/build.gradle` 中添加：

    ```groovy
    android {
        ......
        defaultConfig {
            applicationId "com.xxx.xxx" // 你应用的包名.
            ......

            manifestPlaceholders = [
                JPUSH_APPKEY : "你的appkey", //JPush上注册的包名对应的appkey.
                JPUSH_CHANNEL : "developer-default", //暂时填写默认值即可.
            ]
            ......
        }
        ......
    }

    dependencies {
        ......

        compile 'cn.jiguang.sdk:janalytics:1.1.1' // 此处以JAnalytics 1.1.1 版本为例。
        compile 'cn.jiguang.sdk:jcore:1.1.2' // 此处以JCore 1.1.2 版本为例。
        ......
    }
    ```


  ### API

  iOS、Android 详细 API 文档请参阅 [janalytics.js 的注释](./janalytics.js)。

