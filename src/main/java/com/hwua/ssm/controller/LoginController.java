package com.hwua.ssm.controller;

import com.alibaba.fastjson.JSONObject;
import com.hwua.ssm.entity.User;
import com.hwua.ssm.service.UserService;
import com.hwua.ssm.util.Md5Util;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class LoginController {

    public LoginController() {
        System.out.println("LoginController初始化了");
    }

    @Autowired
    private UserService userService;

    /*@RequestMapping(value = "/login",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String login(String username,String password,HttpSession session){
        password=Md5Util.getMd5(password);
        User user=userService.queryUserByName(username);
        JSONObject result= new JSONObject();
        if(user==null){
            result.put("success",false);
            result.put("info","用户名不存在");
        }else{
            if(password.equals(user.getPassword())){
                session.setAttribute("username",username);
                session.setAttribute("userid",user.getId());
                List<Map<String,Object>> menus=userService.queryMenuByUserId(user.getId());
                session.setAttribute("menus",menus);
                List<String> urls=userService.queryUrlByUserId(user.getId());
                session.setAttribute("urls",urls);
                List<String> codes=userService.queryCodeByUserId(user.getId());
                session.setAttribute("codes",codes);
                result.put("success",true);
                result.put("info","验证成功！");
            }else{
                result.put("success",false);
                result.put("info","密码错误");
            }
        }
        return result.toJSONString();

    }*/

    @RequestMapping(value = "/login",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String login(String username,String password,HttpSession session){
        User user=userService.queryUserByName(username);
        Subject subject=SecurityUtils.getSubject();
        JSONObject result= new JSONObject();
        UsernamePasswordToken token = new UsernamePasswordToken(username,password);
        try {
            subject.login(token);
            if(subject.isAuthenticated()){
                session.setAttribute("username",username);
                session.setAttribute("userid",user.getId());
                List<Map<String,Object>> menus=userService.queryMenuByUserId(user.getId());
                session.setAttribute("menus",menus);
                List<String> urls=userService.queryUrlByUserId(user.getId());
                session.setAttribute("urls",urls);
                List<String> codes=userService.queryCodeByUserId(user.getId());
                session.setAttribute("codes",codes);
                result.put("success",true);
                result.put("info","验证成功！");
            }
        } catch (AuthenticationException e) {
            e.printStackTrace();
            result.put("success",false);
            result.put("info","用户名或者密码错误");
        }
        return result.toJSONString();

    }



    @RequestMapping("/tomain")
    public String tomain(){
        return "main";
    }

    @RequestMapping("/logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "redirect:/login.jsp";
    }

}
