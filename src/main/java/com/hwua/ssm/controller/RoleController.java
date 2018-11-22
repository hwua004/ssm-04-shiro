package com.hwua.ssm.controller;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.hwua.ssm.entity.Role;
import com.hwua.ssm.service.RoleService;
import com.hwua.ssm.util.UpdateResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/role")
public class RoleController {
    @Autowired
    private RoleService roleService;

    @RequestMapping("/index")
    public String index(){
        return "role/role";
    }

    @RequestMapping(value = "/queryRole",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String queryRole(Role role, int page , int rows){
        //查询之前开始分页
        Page pp=PageHelper.startPage(page,rows);

        List<Map<String,Object>> list=roleService.queryRole(role);
        //查询之后获取总条数
        long total=pp.getTotal();
        JSONObject obj= new JSONObject();
        obj.put("total",total);
        JSONArray array=(JSONArray) JSONArray.toJSON(list);
        obj.put("rows",array);
        return obj.toJSONString();

    }

    @RequestMapping(value = "/saveOrUpdateRole",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String saveOrUpdateRole(Role role){
        int a=roleService.saveOrUpdateRole(role);
        UpdateResult ur=null;
        if(a==1){
            ur=new UpdateResult(true,"操作成功！");
        }else if(a==2){
            ur=new UpdateResult(false,"角色名称重复！");
        }else{
            ur=new UpdateResult(false,"操作失败！");
        }
        return ur.toJSONString();

    }


    @RequestMapping(value = "/queryValidAuth",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String queryValidAuth(int roleid){
        List<Map<String,Object>> result=roleService.queryAuthByRoleId(roleid);
        JSONArray array=(JSONArray) JSONArray.toJSON(result);
        return array.toJSONString();

    }


    @RequestMapping(value = "/saveGrant",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String saveGrant(int roleid, @RequestParam("authids") List<Integer> authids){
        List<Map<String,Object>> params= new ArrayList<Map<String,Object>>();
        Map<String,Object> param=null;
        for(int i=0; i<authids.size(); i++){
            param= new HashMap<String,Object>();
            param.put("roleid",roleid);
            param.put("authid",authids.get(i));
            params.add(param);
        }
        int a=roleService.addRoleAndAuth(roleid,params);
        UpdateResult ur=null;
        if(a>0){
            ur=new UpdateResult(true,"操作成功！");
        }else{
            ur=new UpdateResult(false,"操作失败，请稍后再试！");
        }
        return ur.toJSONString();

    }

    @RequestMapping(value = "/queryRoleByUserId",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String queryRoleByUserId(int userid){
        List<Map<String,Object>> roles=roleService.queryRoleByUserId(userid);
        JSONObject obj= new JSONObject();
        obj.put("total",roles.size());
        JSONArray array=(JSONArray) JSONArray.toJSON(roles);
        obj.put("rows",array);
        return obj.toJSONString();

    }
}
