<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/view/common.jsp"%>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript">

        $(function(){
            initAuthTree();
            initAuthEditWin();
        })

        function initAuthTree(){
            $("#authTree").treegrid({
                fit:true,
                iconCls: 'icon-ok',
                rownumbers: true,
                animate: true,
                collapsible: true,
                fitColumns: true,
                url:path+"/auth/queryAllAuth",
                method: 'get',
                idField: 'id',
                treeField: 'authname',
                onContextMenu: onContextMenu,
                columns:[[
                    {field:'authname',title:'权限名称',width:60},
                    {field:'authcode',title:'权限编码',width:60},
                    {field:'type',title:'类型',width:60,
                        formatter: function(value,row,index){
                            if (value=="1"){
                                return "模块";
                            } else {
                                return "资源";
                            }
                        }
                    },
                    {field:'url',title:'URL',width:60},
                    {field:'status',title:'状态',width:60,
                        formatter: function(value,row,index){
                            if (value=="1"){
                                return "有效";
                            } else {
                                return "无效";
                            }
                        }},
                    {field:'orders',title:'排序',width:60}
                ]]
            })
        }

        function onContextMenu(e,row){
            if (row){
                e.preventDefault();
                $(this).treegrid('select', row.id);
                $('#mm').menu('show',{
                    left: e.pageX,
                    top: e.pageY
                });
            }
        }

        function reloadAuthTree(){
            $("#authTree").treegrid("reload");
        }

        function initAuthEditWin() {
            $('#authEditWin').window({
                title: "权限编辑窗口",
                modal: true,
                closed: true,
                iconCls: 'icon-edit',
                width: 300,
                height: 400,
                collapsible: false,
                minimizable: false,
                maximizable: false,
                resizable: false,
                footer: "#footer",
                onBeforeClose: function () {
                    $("#id").val("");
                    $("#pid").val("");
                    $("#pname").textbox("setValue", "");
                    $("#authname").textbox("setValue", "");
                    $("#authcode").textbox("setValue", "");
                    $("#type").combobox("setValue","1");
                    $("#url").textbox("setValue", "");
                    $("#status").combobox("setValue","1");
                    $("#orders").numberbox("setValue", "");
                }
            });
        }

        function showAuthAddWin(){
            $('#authEditWin').window("open");
            var node=$("#authTree").treegrid("getSelected");
            $("#pname").textbox("setValue",node.authname);
            $("#pid").val(node.id);
        }

        function closeAuthEditWin(){
            $('#authEditWin').window("close");
        }

        function submitAuth(){
            var id=$("#id").val();
            var pid=$("#pid").val();
            var authname=$("#authname").textbox("getValue");
            var authcode=$("#authcode").textbox("getValue");
            var type=$("#type").combobox("getValue");
            var url=$("#url").textbox("getValue");
            var status=$("#status").combobox("getValue");
            var orders=$("#orders").numberbox("getValue");
            if(authname=="" || authcode=="" || url=="" || orders==""){
                $.messager.alert("提示","都是必填项");
                return;
            }
            $.ajax({
                url:path+"/auth/saveOrUpdateAuth",
                type:"post",
                dataType:"json",
                data:{
                    id:id,
                    pid:pid,
                    authname:authname,
                    authcode:authcode,
                    type:type,
                    url:url,
                    status:status,
                    orders:orders
                },
                success:function(result){
                    if(result.success){
                        $.messager.alert("提示",result.info,"",function(){
                            closeAuthEditWin();
                            reloadAuthTree();
                        });
                    }else{
                        $.messager.alert("提示",result.info);
                    }
                }
            })
        }

        function showAuthEditWin(){
            $('#authEditWin').window("open");
            var node=$("#authTree").treegrid("getSelected");
            var parent=$("#authTree").treegrid("getParent",node.id);
            $("#id").val(node.id);
            $("#pid").val(node.pid);
            $("#pname").textbox("setValue", parent.authname);
            $("#authname").textbox("setValue", node.authname);
            $("#authcode").textbox("setValue", node.authcode);
            $("#type").combobox("setValue",node.type);
            $("#url").textbox("setValue", node.url);
            $("#status").combobox("setValue",node.status);
            $("#orders").numberbox("setValue", node.orders);

        }

    </script>
</head>
<body>
<table id="authTree">
</table>
<div id="mm" class="easyui-menu" style="width:120px;">
    <div onclick="showAuthAddWin()" data-options="iconCls:'icon-add'">增加子节点</div>
    <div onclick="showAuthEditWin()" data-options="iconCls:'icon-edit'">编辑本节点</div>
    <div onclick="reloadAuthTree()" data-options="iconCls:'icon-reload'">刷新</div>
</div>

<div id="authEditWin" style="padding:10px 10px;" align="center">
    <input type="hidden" id="id">
    <input type="hidden" id="pid">
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="pname" label="上级节点:" data-options="disabled:true" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="authname" label="权限名称:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="authcode" label="权限编码:" labelPosition="left" style="width:90%;">
    </div>
    <div style="margin-bottom:10px">
        <select class="easyui-combobox" id="type" label="类型:" data-options="panelHeight:'auto',editable:false" labelPosition="left" style="width:90%;">
            <option value="1">模块</option>
            <option value="2">资源</option>
        </select>
    </div>
    <div style="margin-bottom:10px">
        <input class="easyui-textbox" id="url" label="URL:" labelPosition="left" style="width:90%;">
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
    <a href="#" class="easyui-linkbutton" onclick="submitAuth()" data-options="iconCls:'icon-ok'">提 交</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" class="easyui-linkbutton" onclick="closeAuthEditWin()" data-options="iconCls:'icon-cancel'">取 消</a>
</div>
</body>
</html>
