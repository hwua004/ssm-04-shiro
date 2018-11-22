<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/view/common.jsp" %>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript">
        $(function(){
            initUserGrid();

            if(hasPermission("user_query")){
                queryUser();
            }
            initUserEditWin();
            initDistributeWin();
        })

        function initUserGrid(){
            $("#userGrid").datagrid({
                fit:true,
                rownumbers:true,
                singleSelect:true,
                autoRowHeight:false,
                pagination:true,
                pageSize:2,
                pageList:[2,10,20,30],
                fitColumns:true,
                toolbar:"#usertoolbar",
                columns:[[
                    {field:'username',title:'用户名',width:100},
                    {field:'realname',title:'真实姓名',width:100},
                    {field:'phone',title:'电话',width:100},
                    {field:'email',title:'邮箱',width:100},
                    {field:'status',title:'状态',width:100,
                        formatter: function(value,row,index){
                            if (value=="1"){
                                return "有效";
                            } else {
                                return "<span style='color: red'>无效</span>";
                            }
                        }},
                    {field:'id',title:'操作',width:100,
                        formatter: function(value,row,index){
                            return "<a href='javascript:void(0)' onclick='showDistributeWin("+value+")'>分配角色</a>"
                        }},
                ]],
                onDblClickRow:function(index, field, value){
                    $("#userGrid").datagrid("selectRow",index);
                    var row=$("#userGrid").datagrid("getSelected");
                    $("#id").val(row.id);
                    $("#username").textbox("setValue",row.username);
                    $("#realname").textbox("setValue",row.realname);
                    $("#phone").textbox("setValue",row.phone);
                    $("#email").textbox("setValue",row.email);
                    $("#status").combobox("setValue",row.status);
                    openUserWditWin();
                }

            })
        }

        function showDistributeWin(userid){
            if(!hasPermission("user_roles")){
                return;
            }
            $('#distributeWin').window("open");
            $("#userid").val(userid);
            initroleDistributeGrid(userid);

        }

        function initroleDistributeGrid(userid){
            $("#roleDistributeGrid").datagrid({
                fit:true,
                rownumbers:true,
                singleSelect:false,
                url:path+"/role/queryRoleByUserId?userid="+userid,
                autoRowHeight:false,
                pagination:false,
                fitColumns:true,
                columns:[[
                    {field:'id',title:'',checkbox:true},
                    {field:'rolename',title:'角色名称',width:100},
                    {field:'rolecode',title:'角色编码',width:100},
                    {field:'checked',title:'是够勾选',width:100}
                ]],
                onLoadSuccess:function(data){
                    console.log(data);
                    var rows=data.rows;
                    for(var i=0; i<rows.length; i++){
                        var row=rows[i];
                        if(row.checked){
                            $("#roleDistributeGrid").datagrid("selectRow",i);
                        }
                    }
                }

            })


        }

        function closeDistributeWin(){
            $('#distributeWin').window("close");
        }

        function initDistributeWin() {
            $('#distributeWin').window({
                title: "角色分配窗口",
                modal: true,
                closed: true,
                iconCls: 'icon-edit',
                width: 350,
                height: 300,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                footer: "#footer2",
                onBeforeClose: function () {
                    $("#userid").val("");

                }
            });
        }

        function queryUser(){
            var username=$("#query_username").textbox("getValue");
            var realname=$("#query_realname").textbox("getValue");
            var phone=$("#query_phone").textbox("getValue");
            var email=$("#query_email").textbox("getValue");
            var status=$("#query_status").combobox("getValue");
            $("#userGrid").datagrid("options").url=path+"/user/queryUser";
            $("#userGrid").datagrid("options").queryParams={
                username:username,
                realname:realname,
                phone:phone,
                email:email,
                status:status
            };
            $("#userGrid").datagrid("load")
        }

        function submitDistribute(){
            if(!hasPermission("user_distribute")){
                return;
            }
            var userid=$("#userid").val();
            var checked=$("#roleDistributeGrid").datagrid("getChecked");
            if(checked.length==0){
                $.messager.alert("提示","请至少选择一个角色");
                return;
            }
            console.log(checked);
            var roleids=[];
            for(var i=0; i<checked.length;i++){
                roleids.push(checked[i].id);
            }
            $.ajax({
                url:path+"/user/distribute",
                type:"post",
                dataType:"json",
                traditional:true,
                data:{
                    roleids:roleids,
                    userid:userid
                },
                success:function(result){
                    if(result.success){
                        $.messager.alert("提示",result.info,"",function(){
                            closeDistributeWin();
                        });
                    }else{
                        $.messager.alert("提示",result.info);
                    }
                }
            });
        }

        function initUserEditWin() {
            $('#userEditWin').window({
                title: "用户编辑窗口",
                modal: true,
                closed: true,
                iconCls: 'icon-edit',
                width: 350,
                height: 300,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                footer: "#footer",
                onBeforeClose: function () {
                    $("#id").val("");
                    $("#username").textbox("setValue","");
                    $("#realname").textbox("setValue","");
                    $("#phone").textbox("setValue","");
                    $("#email").textbox("setValue","");
                    $("#status").combobox("setValue","");
                }
            });
        }

        function  openUserWditWin() {
            //if(hasPermission("user_edit")){
                $('#userEditWin').window("open");
            //

        }

        function closeUserEditWin(){
            $('#userEditWin').window("close");
        }

        function saveOrUpdateUser(){
            var id=$("#id").val();
            var username=$("#username").textbox("getValue");
            var realname=$("#realname").textbox("getValue");
            var phone=$("#phone").textbox("getValue");
            var email=$("#email").textbox("getValue");
            var status=$("#status").combobox("getValue");
            if(username=="" || realname=="" ||phone=="" ||email=="" ){
                $.messager.alert("提示","所有的内容");
                return;
            }
            $.ajax({
                url:path+"/user/saveOrUpdateUser",
                type:"post",
                dataType:"json",
                data:{
                    id:id,
                    username:username,
                    realname:realname,
                    phone:phone,
                    email:email,
                    status:status
                },
                success:function(result){
                    if(result.success){
                        $.messager.alert("提示",result.info,"",function(){
                            closeUserEditWin();
                            queryUser();
                        })
                    }else{
                        $.messager.alert("提示",result.info)
                    }
                }
            })
        }
    </script>
</head>
<body>
<table id="userGrid" ></table>
<div id="usertoolbar" style="padding:2px 5px;">
    用户账号: <input id="query_username" class="easyui-textbox" style="width:110px">
    真实姓名: <input id="query_realname" class="easyui-textbox" style="width:110px">
    电话: <input id="query_phone" class="easyui-textbox" style="width:110px">
    邮箱: <input id="query_email" class="easyui-textbox" style="width:110px">
    状态:
    <select id="query_status" class="easyui-combobox" panelHeight="auto" style="width:100px">
        <option value="">全部</option>
        <option value="1">有效</option>
        <option value="2">无效</option>
    </select>
    <a href="#" class="easyui-linkbutton" onclick="queryUser()" iconCls="icon-search">搜 索</a>
    <shiro:hasPermission name="user_edit">
        <a href="#" class="easyui-linkbutton" onclick="openUserWditWin()" iconCls="icon-add">增加</a>
    </shiro:hasPermission>
</div>

<div id="userEditWin" style="padding: 10px 10px" align="center">
    <input type="hidden" id="id">
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="username" label="用户账号:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="realname" label="真实姓名:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="phone" label="手机号码:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="email" label="邮箱地址:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <select class="easyui-combobox" id="status" data-options="editable:false,panelHeight:90" label="状态:"
                labelPosition="left" style="width:90%;">
            <option value="1">有效</option>
            <option value="2">无效</option>
        </select>
    </div>
</div>
<div id="footer" align="center">
    <a href="#" class="easyui-linkbutton" onclick="saveOrUpdateUser()" data-options="iconCls:'icon-ok'">提 交</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" class="easyui-linkbutton" onclick="closeUserEditWin()" data-options="iconCls:'icon-cancel'">取 消</a>
</div>

<div id="distributeWin"  >
    <input type="hidden" id="userid">
    <table id="roleDistributeGrid" ></table>
</div>
<div id="footer2" align="center">
    <a href="#" class="easyui-linkbutton" onclick="submitDistribute()" data-options="iconCls:'icon-ok'">提 交</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" class="easyui-linkbutton" onclick="closeDistributeWin()" data-options="iconCls:'icon-cancel'">取 消</a>
</div>

</body>
</html>

