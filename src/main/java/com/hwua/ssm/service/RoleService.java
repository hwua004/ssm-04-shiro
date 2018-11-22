package com.hwua.ssm.service;

import com.hwua.ssm.entity.Role;

import java.util.List;
import java.util.Map;

public interface RoleService {

    public List<Map<String,Object>> queryRole(Role role);

    public int saveOrUpdateRole(Role role);

    public List<Map<String,Object>> queryAuthByRoleId(int roleid);

    public int addRoleAndAuth(int roleid, List<Map<String, Object>> params);

    public List<Map<String,Object>> queryRoleByUserId(int userid);


}
