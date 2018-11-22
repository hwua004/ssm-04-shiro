package com.hwua.ssm.serviceImpl;

import com.hwua.ssm.dao.RoleDao;
import com.hwua.ssm.entity.Role;
import com.hwua.ssm.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service("/roleService")
public class RoleServiceImpl implements RoleService {
    @Autowired
    private RoleDao roleDao;

    @Override
    public List<Map<String, Object>> queryRole(Role role) {

        return roleDao.queryRole(role);
    }

    @Override
    public int saveOrUpdateRole(Role role) {
        int result=0;
        //判断是更新还是插入，按照有无主键来判断
        if(role.getId()==null){
            //插入
            //判断角色名是否重复,判断方式就是拿着名字去数据库里查找，找到了就属于重复
            Role rr=roleDao.queryRoleByName(role.getRolename());
            if(rr==null){
                //名字不重复
                result=roleDao.addRole(role);
            }else{
                result=2;
            }

        }else{
            //更新
            //判断角色名是否重复,判断方式就是拿着名字去数据库里查找，找到了就属于重复
            Role rr=roleDao.queryRoleByName(role.getRolename());
            if(rr==null){
                //名字不重复
                result=roleDao.updateRole(role);
            }else if(rr.getId().intValue()==role.getId().intValue()){
                //是自己，可以更新
                result=roleDao.updateRole(role);
            }else{
                result=2;
            }
        }
        return result;
    }

    @Override
    public List<Map<String, Object>> queryAuthByRoleId(int roleid) {
        //查询所有的有限权限
        List<Map<String,Object>> validAuths=roleDao.queryValidAuth();
        //查询当前角色拥有的权限
        List<Integer> auths=roleDao.queryAuthByRoleId(roleid);

        for(int i=0; i<validAuths.size(); i++){
            int id=Integer.parseInt(validAuths.get(i).get("id").toString());
            //判断当前id是否在角色拥有的权限中
            if(auths.contains(id)){
                validAuths.get(i).put("checked",true);
            }
        }

        //把一个list集合变成一个具有层级结构的集合，方法就是拿着每一个节点去找儿子
        Map<String,Object> father=null;
        Map<String,Object> son=null;
        List<Map<String,Object>> children=null;
        //第一层循环，给每个元素做父亲的机会
        for(int i=0; i<validAuths.size(); i++){
            father=validAuths.get(i);
            children=new ArrayList<Map<String,Object>>();
            //第二层循环，去集合中寻找儿子
            for(int j=0; j<validAuths.size(); j++){
                son=validAuths.get(j);
                if(son.get("pid").toString().equals(father.get("id").toString())){
                    //儿子的pid是父亲的id，就算是对应起来
                    //把儿子们放到集合中
                    children.add(son);
                }
            }
            //在内循环呢完成之后，把收集好的儿子们加入到自己的属性中
            father.put("children",children);
        }
        List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
        result.add(validAuths.get(0));
        return result;
    }

    @Override
    @Transactional
    public int addRoleAndAuth(int roleid, List<Map<String, Object>> params) {
        int a=roleDao.delAuthByRoleId(roleid);
        int b=roleDao.addRoleAndAuth(params);
        return a+b;
    }

    @Override
    public List<Map<String, Object>> queryRoleByUserId(int userid) {
        List<Map<String,Object>> validRoles=roleDao.queryValidRole();
        List<Integer> roles=roleDao.queryRoleByUserId(userid);
        for(Map<String,Object> role:validRoles){
            int id=Integer.parseInt(role.get("id").toString());
            if(roles.contains(id)){
                role.put("checked",true);
            }
        }
        return validRoles;
    }
}
