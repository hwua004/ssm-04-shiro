package com.hwua.ssm.dao;

import com.hwua.ssm.entity.User;

import java.util.List;
import java.util.Map;

public interface UserDao {

    public User queryUserByName(String name);

    public User queryUserByNameAndPwd(String username, String password);

    public int updatePwd(String username, String newpwd);

    public List<Map<String,Object>> queryUser(User user);

    public int addUser(User user);

    public int updateUser(User user);

    public int deleteRoleByUserId(int userid);

    public int saveUserAndRole(List<Map<String, Object>> params);

    public List<Map<String,Object>> queryMenuByUserId(int userid);

    public List<String> queryUrlByUserId(int userid);

    public List<String> queryCodeByUserId(int userid);

}
