package com.hwua.ssm.dao;

import com.hwua.ssm.entity.Role;

import java.util.List;
import java.util.Map;

public interface RoleDao {

    public List<Map<String,Object>> queryRole(Role role);

    public int addRole(Role role);

    public int updateRole(Role role);

    public Role queryRoleByName(String rolename);

    public List<Map<String,Object>> queryValidAuth();
    //获取当前角色拥有的权限的ID
    public List<Integer> queryAuthByRoleId(int roleid);

    //删除当前角色所有的权限
    public int delAuthByRoleId(int id);
    //批量插入角色和权限的对应关系
    public int addRoleAndAuth(List<Map<String, Object>> parmas);

    //查询所有有效角色
    public List<Map<String,Object>> queryValidRole();

    public List<Integer> queryRoleByUserId(int userid);


 }
