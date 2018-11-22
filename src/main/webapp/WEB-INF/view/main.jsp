<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/view/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>工作界面</title>
    <script type="text/javascript">

        $(function () {
            //窗体初始化防范，让他能够在页面记载完成之后，完成初始化工作，并隐藏
            initPwdChangeWin();
            //chu初始化模块树
            initModuleTree();
            //初始化首页
            initIndex();
        });

        function logout() {

            $.messager.confirm('提示', '确定要退出系统吗？', function (r) {
                if (r) {
                    window.location.replace(path + "/user/logout");
                }
            });
        }

        function openPwdChangeWin() {
            $('#pwdChangeWin').window('open')
        }

        function initPwdChangeWin() {
            $('#pwdChangeWin').window({
                title: "密码修改窗口",
                modal: true,
                closed: true,
                iconCls: 'icon-edit',
                width: 400,
                height: 225,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                resizable: false,
                footer: "#footer",
                onBeforeClose: function () {
                    $("#oldpwd").passwordbox("setValue", "");
                    $("#newpwd").passwordbox("setValue", "");
                    $("#repwd").passwordbox("setValue", "");
                }
            });
        }

        function closePwdChangeWin() {

            $('#pwdChangeWin').window('close');
        }

        function submitPwdChange() {
            var oldpwd = $("#oldpwd").passwordbox("getValue");
            var newpwd = $("#newpwd").passwordbox("getValue");
            var repwd = $("#repwd").passwordbox("getValue");
            if (oldpwd == "" || newpwd == "" || repwd == "") {
                $.messager.alert("提示", "所有的内容都为必填项");
                return;
            }
            if (repwd != newpwd) {
                $.messager.alert("提示", "两次密码输入不一致");
                return;
            }
            $.ajax({
                url: path + "/user/pwdChage",
                type: "post",
                dataType: "json",
                data: {
                    oldpwd: oldpwd,
                    newpwd: newpwd
                },
                success: function (result) {
                    if(result.success){
                        $.messager.alert("提示", "修改成功！请立即重新登录","",function(){
                            window.location.replace(path + "/user/logout");
                        });

                    }else{
                        $.messager.alert("提示", result.info);
                    }
                }
            })
        }

        function initModuleTree(){
            $("#moduleTree").tree({
                /*url:path+'/static/test/tree_data1.json',*/
                url:path+"/user/initMenu",
                method:'get',
                animate:true,
                onClick:function(node){
                    console.log(node);
                    addPanel(node);
                }
            })
        }

        function initIndex(){
            $('#mainTab').tabs('add',{
                title: "首页",
                content: "<iframe src='"+path+"/user/personal' style='width:100%;height:100%' frameborder='0' scrolling='auto'></iframe>",
                closable: false,
                fit:true
            });
        }

        function addPanel(node){
            var flag=$('#mainTab').tabs("exists",node.text);
            if(!flag){
                if(node.url=="" || node.url==undefined ){

                }else{
                    $('#mainTab').tabs('add',{
                        title: node.text,
                        content: "<iframe src='"+path+node.url+"' style='width:100%;height:100%' frameborder='0' scrolling='auto'></iframe>",
                        closable: true,
                        fit:true
                    });
                }

            }else{
                $('#mainTab').tabs("select",node.text);
            }

        }

    </script>
</head>
<body class="easyui-layout">
<div data-options="region:'north',border:false"
     style="height:50px;background:#00b4ef;padding:5px">
    <div style="float:left;font-size: 25px;color: #FFFFFF"><strong>权限管理系统</strong></div>
    <div style="float:right;color: #FFFFFF;padding-top: 10px">
        <strong>
            <a style="color: #FFF;text-decoration: none" href="javascript:void(0)" onclick="openPwdChangeWin()">
                欢迎您${sessionScope.username}
            </a>&nbsp;&nbsp;&nbsp;&nbsp;
            <a style="color: #FFF;text-decoration: none" href="javascript:void(0)" onclick="logout()">退出登录</a>
        </strong>
    </div>
</div>
<div data-options="region:'west',split:true,title:'功能模块'" style="width:200px;padding:10px;">
    <ul id="moduleTree"  ></ul>
</div>
<div data-options="region:'center'">
    <div id="mainTab" class="easyui-tabs" data-options="fit:true" >
</div>
<div id="pwdChangeWin" style="padding:10px 10px;" align="center">
    <div style="margin-bottom:10px">
        <input class="easyui-passwordbox" id="oldpwd" label="原始密码:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-passwordbox" id="newpwd" label="新密码:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-passwordbox" id="repwd" label="确认密码:" labelPosition="left" style="width:90%;">
    </div>
</div>
<div id="footer" style="padding:5px;" align="center">
    <a href="#" class="easyui-linkbutton" onclick="submitPwdChange()" data-options="iconCls:'icon-ok'">提 交</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" class="easyui-linkbutton" onclick="closePwdChangeWin()" data-options="iconCls:'icon-cancel'">取 消</a>
</div>
</body>
</html>
<%--<html>
<head>
    <title>Title</title>
    <script type="text/javascript">
        function logout(){
            window.location.replace("${path}/user/logout");
        }
    </script>
</head>
<body>
<h1>主工作界面，欢迎您${sessionScope.username}</h1>

<h3><a href="javascript:void(0)" onclick="logout()">退出登录</a></h3>
</body>
</html>--%>
