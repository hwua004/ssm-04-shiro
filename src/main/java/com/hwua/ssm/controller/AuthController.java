package com.hwua.ssm.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hwua.ssm.entity.Auth;
import com.hwua.ssm.service.AuthService;
import com.hwua.ssm.util.UpdateResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/auth")
public class AuthController {
    @Autowired
    private AuthService authService;

    @RequestMapping("/index")
    public String index(){
        return "auth/auth";
    }

    @RequestMapping(value = "/queryAllAuth",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String queryAllAuth(){
        List<Map<String,Object>> auths=authService.queryAllAuth();
        JSONArray array=(JSONArray)JSONArray.toJSON(auths);
        JSONObject result= new JSONObject();
        result.put("total",auths.size());
        result.put("rows",array);
        return result.toJSONString();
    }

    @RequestMapping(value = "/saveOrUpdateAuth",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String saveOrUpdateAuth(Auth auth){
        int a=authService.saveOrUpdateAuth(auth);
        UpdateResult ur=null;
        if(a==1){
            ur=new UpdateResult(true,"操作成功！");
        }else if(a==2){
            ur=new UpdateResult(false,"权限名称重复！");
        }else{
            ur=new UpdateResult(false,"操作失败！");
        }

        return ur.toJSONString();
    }

}
