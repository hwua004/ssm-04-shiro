package com.hwua.ssm.realm;

import com.hwua.ssm.entity.User;
import com.hwua.ssm.service.UserService;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;


public class CustomerRealm2 extends AuthorizingRealm {
    @Autowired
    private UserService userService;

    @Override
    public void setName(String name) {
        super.setName("customerRealm");
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        String username=(String)principalCollection.getPrimaryPrincipal();
        User user=userService.queryUserByName(username);
        List<String> permissions=userService.queryCodeByUserId(user.getId());
        SimpleAuthorizationInfo info= new SimpleAuthorizationInfo();
        if(permissions!=null && permissions.size()>0){
            for(String permission:permissions){
                info.addStringPermission(permission);
            }
        }
        return info;
    }



    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        String username=(String) authenticationToken.getPrincipal();
        User user=userService.queryUserByName(username);
        if(user==null){
            return null;
        }else{

            SimpleAuthenticationInfo info=
                    new SimpleAuthenticationInfo(
                            user.getUsername(),
                            user.getPassword(),
                            //开始给输入的密码加盐
                            ByteSource.Util.bytes("qwerty"),
                            this.getName());
            return info;
        }
    }
}
