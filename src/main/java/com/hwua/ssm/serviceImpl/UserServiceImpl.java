package com.hwua.ssm.serviceImpl;

import com.hwua.ssm.dao.UserDao;
import com.hwua.ssm.entity.User;
import com.hwua.ssm.service.UserService;
import com.hwua.ssm.util.Md5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Override
    //@Cacheable(value="my",key = "'user'+#name")
    public User queryUserByName(String name) {
        return userDao.queryUserByName(name);
    }

    @Override
    public int updatePwd(String username, String oldpwd, String newpwd) {
        oldpwd=Md5Util.getMd5(oldpwd);
        newpwd=Md5Util.getMd5(newpwd);
        User user=userDao.queryUserByNameAndPwd(username,oldpwd);
        if(user==null){
            //原始密码错误
            return 2;
        }else{
            int a=userDao.updatePwd(username,newpwd);
            return a;
        }
    }

    @Override
    public List<Map<String, Object>> queryUser(User user) {
        return userDao.queryUser(user);
    }

    @Override
    public int saveOrUpdateUser(User user) {
        int result=0;
        if(user.getId()==null){
            User uu=userDao.queryUserByName(user.getUsername());
            if(uu==null){
                result=userDao.addUser(user);
            }else{
                result=2;
            }
        }else{
            User uu=userDao.queryUserByName(user.getUsername());
            if(uu==null){
                result=userDao.updateUser(user);
            }else if(uu.getId().intValue()==user.getId().intValue()){
                result=userDao.updateUser(user);
            }else{
                result=2;
            }
        }
        return result;
    }

    @Override
    public int saveUserAndRole(int userid,List<Map<String, Object>> params) {
        int a=userDao.deleteRoleByUserId(userid);
        int b=userDao.saveUserAndRole(params);
        return a+b;
    }

    @Override
    public List<Map<String, Object>> queryMenuByUserId(int userid) {
        List<Map<String,Object>> menus=userDao.queryMenuByUserId(userid);
        Map<String,Object> father=null;
        Map<String,Object> son=null;
        List<Map<String,Object>> children=null;
        for(int i=0; i<menus.size(); i++){
            father=menus.get(i);
            children=new ArrayList<Map<String,Object>>();
            for(int j=0; j<menus.size(); j++){
                son=menus.get(j);
                if(son.get("pid").toString().equals(father.get("id").toString())){
                    children.add(son);
                }
            }
            father.put("children",children);
        }
        List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
        result.add(menus.get(0));
        return result;
    }

    @Override
    public List<String> queryUrlByUserId(int userid) {
        return userDao.queryUrlByUserId(userid);
    }

    @Override
    public List<String> queryCodeByUserId(int userid) {
        return userDao.queryCodeByUserId(userid);
    }
}
