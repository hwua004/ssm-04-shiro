package com.hwua.ssm.util;

import com.alibaba.fastjson.JSONObject;

public class UpdateResult {
    private Boolean success;
    private String info;



    public UpdateResult(Boolean success, String info) {
        this.success = success;
        this.info = info;
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String toJSONString(){
        JSONObject obj=new JSONObject();
        obj.put("success",success);
        obj.put("info",info);
        return obj.toJSONString();
    }

    public static void main(String[] args) {
        String str=Md5Util.getMd5("123456");
        System.out.println(str);
    }
}
