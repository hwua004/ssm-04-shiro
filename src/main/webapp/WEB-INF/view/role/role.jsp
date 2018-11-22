<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/view/common.jsp"%>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript">

        $(function(){
            initRoleGrid();
            queryRole();
            initRoleEditWin();
            initGrantWin();
        })

        function initRoleGrid(){
            $("#roleGrid").datagrid({
                fit:true,
                rownumbers:true,
                singleSelect:true,
                autoRowHeight:false,
                pagination:true,
                pageSize:2,
                pageList:[2,10,20,30,40],
                //pageSize和pageList必须结合时候用，pageList的默认值是[10,20,30,40,50]
                //并且pageSize的默认值就是10 。如果修改了pageSize的值，那么这个值必须在pageList中出现
                fitColumns:true,
                toolbar:"#roletb",
                columns:[[
                    {field:'rolename',title:'角色名称',width:100},
                    {field:'rolecode',title:'角色编码',width:100},
                    {field:'status',title:'状态',width:100,
                        formatter: function(value,row,index){
                            if (value=="1"){
                                return "有效";
                            } else {
                                return "<span style='color: red'>无效</span>";
                            }
                        }
                    },
                    {field:'orders',title:'排序',width:100},
                    {field:'id',title:'操作',width:100,
                        formatter: function(value,row,index){
                            return "<a href='javascript:void(0)' onclick='showGrantWin("+value+")'>授权</a>"
                        }}
                ]],
                onDblClickRow:function(index, row){
                    console.log(row);
                    $('#roleEditWin').window("open");
                    $("#id").val(row.id);
                    $("#rolename").textbox("setValue", row.rolename);
                    $("#rolecode").textbox("setValue", row.rolecode);
                    $("#status").combobox("setValue",row.status);
                    $("#orders").numberbox("setValue", row.orders);

                }
            })
        }

        function showGrantWin(roleid){
            $('#grantWin').window("open");
            $("#roleid").val(roleid);
            $("#grantAuthTree").tree({
                url:path+'/role/queryValidAuth?roleid='+roleid,
                method:'get',
                animate:true,
                cascadeCheck:false,
                checkbox:true
            });
        }

        function closeGrantWin(){
            $('#grantWin').window("close");
        }

        function submitGrant(){
            var roleid=$("#roleid").val();
            var checked=$('#grantAuthTree').tree("getChecked");
            console.log(checked);
            if(checked.length==0){
                $.messager.alert("提示","至少要勾选一个根节点");
                return;
            }
            var authids=[];
            for(var i=0; i<checked.length; i++){
                authids.push(checked[i].id);
            }
            $.ajax({
                url:path+"/role/saveGrant",
                type:"post",
                dataType:"json",
                traditional:true,
                data:{
                    roleid:roleid,
                    authids:authids
                },
                success:function(result){
                    if(result.success){
                        $.messager.alert("提示",result.info,"",function(){
                            closeGrantWin();
                        });
                    }else{
                        $.messager.alert("提示",result.info);
                    }
                }
            })


        }


        function initGrantWin() {
            $('#grantWin').window({
                title: "角色授权窗口",
                modal: true,
                closed: true,
                iconCls: 'icon-edit',
                width: 300,
                height: 380,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                resizable: false,
                footer: "#footer2",
                onBeforeClose: function () {
                    $("#roleid").val("");

                }
            });
        }



        function queryRole(){
            var rolename=$("#query_rolename").textbox("getValue");
            var rolecode=$("#query_rolecode").textbox("getValue");
            var status=$("#query_status").combobox("getValue");
            console.log(rolename);
            console.log(rolecode);
            console.log(status);
            console.log($("#roleGrid").datagrid("options"));
            //设置参数
            $("#roleGrid").datagrid("options").queryParams={
                rolename:rolename,
                rolecode:rolecode,
                status:status
            }
            //指定请求数据的路径
            $("#roleGrid").datagrid("options").url=path+"/role/queryRole";
            //返送请求，获取数据
            $("#roleGrid").datagrid("load");

        }

        function initRoleEditWin() {
            $('#roleEditWin').window({
                title: "角色编辑窗口",
                modal: true,
                closed: true,
                iconCls: 'icon-edit',
                width: 300,
                height: 270,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                resizable: false,
                footer: "#footer",
                onBeforeClose: function () {
                    $("#id").val("");
                    $("#rolename").textbox("setValue", "");
                    $("#rolecode").textbox("setValue", "");
                    $("#status").combobox("setValue","1");
                    $("#orders").numberbox("setValue", "");
                }
            });
        }
        function openRoleAddWin(){
            $('#roleEditWin').window("open");
        }
        function closeRoleEditWin(){
            $('#roleEditWin').window("close");
        }
        function submitRole(){
            var id=$("#id").val();
            var rolename=$("#rolename").textbox("getValue");
            var rolecode=$("#rolecode").textbox("getValue");
            var status=$("#status").combobox("getValue");
            var orders=$("#orders").numberbox("getValue");
            if(rolename=="" || rolecode=="" ||orders=="" ){
                $.messager.alert("提示","所有内容均为必填项");
                return;
            }
            $.ajax({
                url:path+"/role/saveOrUpdateRole",
                type:"post",
                dataType:"json",
                data:{
                    id:id,
                    rolename:rolename,
                    rolecode:rolecode,
                    status:status,
                    orders:orders
                },
                success:function(result){
                    if(result.success){
                        $.messager.alert("提示",result.info,"",function(){
                            closeRoleEditWin();
                            queryRole();
                        });
                    }else{
                        $.messager.alert("提示",result.info);
                    }
                }
            })
        }

    </script>

</head>
<body>

<table id="roleGrid" ></table>
<div id="roletb" style="padding:2px 5px;">
    角色名称: <input id="query_rolename" class="easyui-textbox" style="width:110px">
    角色编码: <input id="query_rolecode" class="easyui-textbox" style="width:110px">
    状态:
    <select id="query_status" class="easyui-combobox" data-options="editable:false" panelHeight="auto" style="width:100px">
        <option value="">全部</option>
        <option value="1">有效</option>
        <option value="2">无效</option>
    </select>
    <a href="#" class="easyui-linkbutton" onclick="queryRole()" iconCls="icon-search">搜 索</a>
    <a href="#" class="easyui-linkbutton" onclick="openRoleAddWin()" iconCls="icon-add">增 加</a>

</div>

<div id="roleEditWin" style="padding:10px 10px;" align="center">
    <input type="hidden" id="id">
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="rolename" label="角色名称:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="rolecode" label="角色编码:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <select class="easyui-combobox" id="status" label="状态:" data-options="panelHeight:'auto',editable:false" labelPosition="left" style="width:90%;">
            <option value="1">有效</option>
            <option value="2">无效</option>
        </select>
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-numberbox" id="orders" label="排序:" labelPosition="left" style="width:90%;">
    </div>
</div>
<div id="footer" style="padding:5px;" align="center">
    <a href="#" class="easyui-linkbutton" onclick="submitRole()" data-options="iconCls:'icon-ok'">提 交</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" class="easyui-linkbutton" onclick="closeRoleEditWin()" data-options="iconCls:'icon-cancel'">取 消</a>
</div>

<div id="grantWin" style="padding:10px 10px;" >
    <input type="hidden" id="roleid">
    <ul id="grantAuthTree" ></ul>
</div>
<div id="footer2" style="padding:5px;" align="center">
    <a href="#" class="easyui-linkbutton" onclick="submitGrant()" data-options="iconCls:'icon-ok'">提 交</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" class="easyui-linkbutton" onclick="closeGrantWin()" data-options="iconCls:'icon-cancel'">取 消</a>
</div>
</body>
</html>
