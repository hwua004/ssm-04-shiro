<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="${path}/static/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${path}/static/easyui/themes/icon.css">
<script type="text/javascript" src="${path}/static/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${path}/static/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
    var path="${path}";
    var permissions=[];

    <%
        List<String> codes=(List<String>) session.getAttribute("codes");
        if(codes!=null && codes.size()>0){
            for(String code:codes){
    %>
                permissions.push("<%=code%>");
    <%
            }
        }
    %>
    console.log(permissions);
    function hasPermission(code){
        var flag=false;
        for(var i=0; i<permissions.length; i++){
            if(code==permissions[i]){
                flag=true;
                break;
            }
        }
        if(!flag){
           $.messager.alert("提示","权限不足");
        }
        return flag;
    }

</script>