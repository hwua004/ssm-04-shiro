package com.hwua.ssm.util;

import org.apache.commons.codec.digest.DigestUtils;

public class Md5Util {

    public static String getMd5(String str){
        String newpwd=DigestUtils.md5Hex(str);
        for(int i=0; i<63; i++){
            newpwd=DigestUtils.md5Hex(newpwd);
        }
        return newpwd;
    }

}
