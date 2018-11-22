package com.hwua.ssm.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.hwua.ssm.entity.User;
import com.hwua.ssm.service.UserService;
import com.hwua.ssm.util.Md5Util;
import com.hwua.ssm.util.UpdateResult;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping(value = "/pwdChage",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String pwdChage(String oldpwd,String newpwd,HttpSession session){
        String username=(String) session.getAttribute("username");
        int a=userService.updatePwd(username,oldpwd,newpwd);
        UpdateResult result=null;
        if(a==0){
            result=new UpdateResult(false,"操作失败，请稍后再试!");
        }else if(a==1){
            result=new UpdateResult(true,"操作成功!");
        }else{
            result=new UpdateResult(false,"原始密码错误!");
        }
        return result.toJSONString();
    }

    @RequestMapping("/index")
    @RequiresPermissions("user")
    public String index(){
        //WEB-INF/view/user/user.jsp
        return "user/user";
    }

    @RequestMapping("/personal")
    public String personal(){
        //WEB-INF/view/user/user.jsp
        return "personal";
    }

    @RequestMapping(value = "/queryUser",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String queryUser(User user, int page, int rows){
        Page pp=PageHelper.startPage(page,rows);
        List<Map<String,Object>> list=userService.queryUser(user);
        long total=pp.getTotal();
        JSONArray array=(JSONArray)JSONArray.toJSON(list);
        JSONObject obj= new JSONObject();
        obj.put("total",total);
        obj.put("rows",array);
        return obj.toJSONString();

    }

    @RequestMapping(value = "/saveOrUpdateUser",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String saveOrUpdateUser(User user){
        user.setPassword(Md5Util.getMd5("123456"));
        int a=userService.saveOrUpdateUser(user);
        UpdateResult rr=null;
        if(a==1){
            rr=new UpdateResult(true,"操作成功！");
        }else if(a==2){
            rr=new UpdateResult(false,"用户名称重复！");
        }else{
            rr=new UpdateResult(false,"操作失败，请稍后再试！");
        }
        return rr.toJSONString();
    }

    @RequestMapping(value = "/distribute",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String distribute(int userid, @RequestParam("roleids") List<Integer> roleids){
        List<Map<String,Object>> params= new ArrayList<Map<String,Object>>();
        Map<String,Object> param=null;
        for(int i=0; i<roleids.size(); i++){
            param= new HashMap<String,Object>();
            param.put("userid",userid);
            param.put("roleid",roleids.get(i));
            params.add(param);
        }
        int a=userService.saveUserAndRole(userid,params);
        UpdateResult ur=null;
        if(a>0){
            ur=new UpdateResult(true,"操作成功！");
        }else{
            ur=new UpdateResult(false,"操作失败，请稍后再试！");
        }
        return ur.toJSONString();

    }


    @RequestMapping(value = "/initMenu",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String initMenu(HttpSession session){
        List<Map<String,Object>> menus=(List)session.getAttribute("menus");
        JSONArray array= (JSONArray)JSONArray.toJSON(menus);
        return array.toJSONString();

    }

}
