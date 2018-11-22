package com.hwua.ssm.interceptor;

import com.hwua.ssm.util.UpdateResult;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {

        HttpSession session=request.getSession();
        String username=(String)session.getAttribute("username");

        if("admin".equals(username)){
            return true;
        }else{
            List<String> urls=(List<String>) session.getAttribute("urls");
            String path=request.getServletPath();
            System.out.println("要访问的路径："+path);
            if(urls.contains(path)){
                return true;
            }else{

                String ajax=request.getHeader("X-Requested-With");
                if(ajax==null){
                    request.getRequestDispatcher("/WEB-INF/view/noauth.jsp").forward(request,response);
                }else{
                    UpdateResult ur=new UpdateResult(false,"权限不足，请联系管理员");
                    response.setContentType("text/html;charset=UTF-8");
                    response.getWriter().write(ur.toJSONString());
                    response.getWriter().close();
                }
                return false;
            }
        }


    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
