package com.hwua.ssm.controller;

import com.alibaba.fastjson.JSONObject;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authz.AuthorizationException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@ControllerAdvice
public class ExceptionHandlerController {
    @ExceptionHandler(Exception.class)
    public void handleExc3(Exception np,
                           HttpServletRequest request,
                           HttpServletResponse response)throws Exception{
        String info=request.getHeader("X-Requested-With");
        if(info==null){
            if(np instanceof AuthorizationException){
                request.getRequestDispatcher("/WEB-INF/view/noauth.jsp").forward(request,response);
            }
            if(np instanceof AuthenticationException){
                request.getRequestDispatcher("/login.jsp").forward(request,response);
            }
            request.getRequestDispatcher("/WEB-INF/view/500.jsp").forward(request,response);
        }else{
            JSONObject obj= new JSONObject();
            obj.put("success",false);
            if(np instanceof AuthorizationException || np instanceof AuthenticationException){
                obj.put("info","权限不足，请联系管理员");
            }else{
                obj.put("info",np.getClass().getName()+":"+np.getMessage());
            }
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(obj.toJSONString());
            response.getWriter().close();
        }
    }

}

