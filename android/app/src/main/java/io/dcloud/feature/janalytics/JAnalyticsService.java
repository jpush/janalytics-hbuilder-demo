package io.dcloud.feature.janalytics;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import cn.jiguang.analytics.android.api.Account;
import cn.jiguang.analytics.android.api.AccountCallback;
import cn.jiguang.analytics.android.api.BrowseEvent;
import cn.jiguang.analytics.android.api.CalculateEvent;
import cn.jiguang.analytics.android.api.CountEvent;
import cn.jiguang.analytics.android.api.Currency;
import cn.jiguang.analytics.android.api.Event;
import cn.jiguang.analytics.android.api.JAnalyticsInterface;
import cn.jiguang.analytics.android.api.LoginEvent;
import cn.jiguang.analytics.android.api.PurchaseEvent;
import cn.jiguang.analytics.android.api.RegisterEvent;
import io.dcloud.common.DHInterface.IWebview;
import io.dcloud.common.DHInterface.StandardFeature;
import io.dcloud.common.util.JSUtil;


public class JAnalyticsService extends StandardFeature {

    public static final String TAG = JAnalyticsService.class.getSimpleName();


    private static IWebview mIWebView;

    // 需要手动调用
    public void init(IWebview webView, JSONArray data) {
        JAnalyticsInterface.init(webView.getContext().getApplicationContext());
        mIWebView = webView;

    }

    public void setDebug(IWebview webView, JSONArray data) {
        try {
            JSONObject params = data.getJSONObject(1);
            boolean isOpenDebugMode = params.getBoolean("enable");
            Log.i(TAG,"setDebug:"+isOpenDebugMode);
            JAnalyticsInterface.setDebugMode(isOpenDebugMode);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void crashLogON(IWebview webView, JSONArray data) {
        JAnalyticsInterface.initCrashHandler(webView.getContext().getApplicationContext());
    }

    public void crashLogOFF(IWebview webView, JSONArray data) {
        JAnalyticsInterface.stopCrashHandler(webView.getContext().getApplicationContext());
    }

    public void startLogPageView(IWebview webView, JSONArray data){
        try {
            JSONObject params = data.getJSONObject(1);
            String pageName = params.getString("pageName");
            Log.i(TAG,"startLogPageView:"+pageName);
            JAnalyticsInterface.onPageStart(webView.getContext().getApplicationContext(), pageName);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void stopLogPageView(IWebview webView, JSONArray data) {
        try {
            JSONObject params = data.getJSONObject(1);
            String pageName = params.getString("pageName");
            Log.i(TAG,"stopLogPageView:"+pageName);
            JAnalyticsInterface.onPageEnd(webView.getContext().getApplicationContext(), pageName);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void identifyAccount(final IWebview webView, JSONArray data) {

        try {
            final String callbackId = data.getString(0);
            JSONObject params = data.getJSONObject(1);
            String accountID = params.getString("accountID");
            String sex = params.getString("sex");
            long creationTime=params.getLong("creationTime");
            String birthdate = params.getString("birthdate");
            String paid = params.getString("paid");
            String phone = params.getString("phone");
            String email = params.getString("email");
            String name = params.getString("name");
            String wechatID = params.getString("wechatID");
            String qqID = params.getString("qqID");
            String weiboID = params.getString("weiboID");
            JSONObject extras = params.has("extras") ? params.getJSONObject("extras") : null;

            Account account = new Account(accountID);    //account001为账号id
            account.setCreationTime(creationTime);        //账户创建的时间戳
            account.setName(name);
            account.setSex(getSexID(sex));
            account.setPaid(getPaidID(paid));
            account.setBirthdate(birthdate);       //"19880920"是yyyyMMdd格式的字符串
            account.setPhone(phone);
            account.setEmail(email);
            account.setWechatId(wechatID);
            account.setQqId(qqID);
            account.setWeiboId(weiboID);
            if (extras != null) {
                Iterator iterator = extras.keys();
                while (iterator.hasNext()) {
                    String key = (String) iterator.next();
                    String value = extras.getString(key);
                    account.setExtraAttr(key,value);  //key如果为空，或者以极光内部namespace(符号$)开头，会设置失败并打印日志
                }
            }

            Log.i(TAG,"account:"+account);
            JAnalyticsInterface.identifyAccount(webView.getContext().getApplicationContext(), account, new AccountCallback() {
                @Override
                public void callback(int code, String msg) {
                    Log.d(TAG, "code = " + code  + " msg =" + msg);
                    JSUtil.execCallback(webView, callbackId, getMsgObject(code,msg), JSUtil.OK, false);
                }
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void detachAccount(final IWebview webView, JSONArray data){
        try {
        final String callbackId = data.getString(0);
        JAnalyticsInterface.detachAccount(webView.getContext().getApplicationContext(), new AccountCallback() {
            @Override
            public void callback(int code, String msg) {
                Log.d(TAG, "code = " + code  + " msg =" + msg);
                JSUtil.execCallback(webView, callbackId, getMsgObject(code,msg), JSUtil.OK, false);
            }
        });
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    public void setFrequency(IWebview webView, JSONArray data){
        try {
            JSONObject params = data.getJSONObject(1);
            int frequency = params.getInt("frequency");
            Log.i(TAG,"setFrequency:"+frequency);
            JAnalyticsInterface.setAnalyticsReportPeriod(webView.getContext().getApplicationContext(), frequency);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }



    public void postEvent(IWebview webView, JSONArray data){
        try {
        JSONObject params = data.getJSONObject(1);
        String type = params.getString("type");
        Log.i(TAG,"postEvent type:"+type);
        switch (type) {
            case "login":
                String method = params.getString("method");
                boolean success = params.getBoolean("success");
                LoginEvent loginEvent = new LoginEvent(method, success);
                sendEvent(webView.getContext().getApplicationContext(),loginEvent, params);
                break;
            case "register":
                method = params.getString("method");
                success = params.getBoolean("success");
                RegisterEvent registerEvent = new RegisterEvent(method, success);
                sendEvent(webView.getContext().getApplicationContext(),registerEvent, params);
                break;
            case "purchase":
                String goodsId = params.getString("goodsId");
                String goodsType = params.getString("goodsType");
                String goodsName = params.getString("goodsName");
                double price = params.getDouble("price");
                success = params.getBoolean("success");
                String currency = params.getString("currency");
                int count = params.getInt("count");
                PurchaseEvent purchaseEvent;
                if (currency.equals(Currency.CNY.name())) {
                    purchaseEvent = new PurchaseEvent(goodsId, goodsName, price, success, Currency.CNY, goodsType, count);
                } else {
                    purchaseEvent = new PurchaseEvent(goodsId, goodsName, price, success, Currency.USD, goodsType, count);
                }
                sendEvent(webView.getContext().getApplicationContext(),purchaseEvent, params);
                break;
            case "browse":
                String id = params.getString("id");
                String name = params.getString("name");
                String contentType = params.getString("contentType");
                float duration = (float) params.getDouble("duration");
                BrowseEvent browseEvent = new BrowseEvent(id, name, contentType, duration);
                sendEvent(webView.getContext().getApplicationContext(),browseEvent, params);
                break;
            case "count":
                id = params.getString("id");
                CountEvent countEvent = new CountEvent(id);
                sendEvent(webView.getContext().getApplicationContext(),countEvent, params);
                break;
            default:
                id = params.getString("id");
                double value = params.getDouble("value");
                CalculateEvent calculateEvent = new CalculateEvent(id, value);
                sendEvent(webView.getContext().getApplicationContext(),calculateEvent, params);
        }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void sendEvent(Context context, Event event, JSONObject params) {
        try {
        JSONObject extras = params.has("extras") ? params.getJSONObject("extras") : null;
        if (extras != null) {
            event.addExtMap(toMap(extras));
        }
        Log.d(TAG, "sending event: " + event);
        JAnalyticsInterface.onEvent(context, event);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private Map<String, String> toMap(JSONObject json) throws JSONException {
        Map<String, String> map = new HashMap<String, String>();
        Iterator iterator = json.keys();
        while (iterator.hasNext()) {
            String key = (String) iterator.next();
            String value = json.getString(key);
            map.put(key, value);
        }
        return map;
    }


    private static JSONObject getMsgObject(int code, String msg) {
        JSONObject data = new JSONObject();
        try {
            data.put("code", code);
            data.put("msg", msg);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return data;
    }

    private int getSexID(String sex){
        if(TextUtils.isEmpty(sex)){
            return 0;
        }
        int sexID = 0;
        switch (sex){
            case "male":
                sexID = 2;
                break;
            case "female":
                sexID = 1;
                break;
            default:
                sexID = 0;
        }
        return sexID;
    }

    private int getPaidID(String paid){
        if(TextUtils.isEmpty(paid)){
            return 0;
        }
        int paidId = 0;
        switch (paid){
            case "paid":
                paidId = 1;
                break;
            case "unpaid":
                paidId = 2;
                break;
            default:
                paidId = 0;
        }
        return paidId;
    }


}
