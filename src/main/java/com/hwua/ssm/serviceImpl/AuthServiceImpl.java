package com.hwua.ssm.serviceImpl;

import com.hwua.ssm.dao.AuthDao;
import com.hwua.ssm.entity.Auth;
import com.hwua.ssm.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("authService")
public class AuthServiceImpl implements AuthService {
    @Autowired
    private AuthDao authDao;

    @Override
    public List<Map<String, Object>> queryAllAuth() {
        List<Map<String,Object>> auths=authDao.queryAllAuth();
        auths.get(0).remove("_parentId");
        /*for(Map<String,Object> auth:auths){
            if("0".equals(auth.get("_parentId").toString())){
                auth.remove("_parentId");
            }
        }*/
        return auths;
    }

    @Override
    public int saveOrUpdateAuth(Auth auth) {
        int result=0;
        if(auth.getId()==null){
            //插入，还得先判断一下是否权限名字重复
            Auth au=authDao.queryAuthByName(auth.getAuthname());
            if(au==null){
                //名字及不重复.,拿着名字去数据库中找，找不到，说明名字没有被用过，说明可以进行插入
                result=authDao.addAuth(auth);
            }else{
                //名字重复
                result=2;
            }
        }else{
            //更新,更新之前先去验证一下权限名字是否重复
            Auth au=authDao.queryAuthByName(auth.getAuthname());
            if(au==null){
                //名字不重复
                result=authDao.updateAuth(auth);
            }else{
                //名字重复，分为两种情况，第一种是没有修改名字，名字原封不动的回来了
                //这种情况下，au对象其实就是它自己，怎么判断是不是自己，id一样就是自己
                if(au.getId().intValue()==auth.getId().intValue()){
                    result=authDao.updateAuth(auth);
                }else{
                    //第二种情况，就是名字被修改成了一个已经存在的名字
                    result=2;
                }

            }
        }
        return result;
    }
}
