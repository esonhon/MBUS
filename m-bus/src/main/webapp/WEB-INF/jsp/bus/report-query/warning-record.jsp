<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>设备管理-报警记录</title>
    <link rel="stylesheet" href="${ctx}/resources/css/layui.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/resources/css/common.css"/>
    <link rel="stylesheet" href="${ctx}/resources/plugins/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <link rel="stylesheet" href="${ctx}/resources/layui_ext/dtree/dtree.css "/>
    <link rel="stylesheet" href="${ctx}/resources/layui_ext/dtree/font/iconfont.css"/>
</head>
<body class="inner-body" style="background:#f2f2f2;position: relative;">
<!-----------树菜单--------------->
<div id="treeBox" style="width: 200px;background: #FFFFFF;float: left;height: 100%;">
    <div class="treename">
        <span>公寓房间列表</span>
    </div>
    <div class="layui-form1" id="tree"  style="height:600px;overflow:auto">
        <ul id="demoTree1" class="dtree" data-id="0"></ul>
    </div>
</div>
<!-------默认表格开始----------->

<div class="tableHtml" style="margin-left: 210px;height: 100%;background: #FFFFFF;">
    <div class="top-btn">
        <div class="layui-btn-group">
          <%--  <shiro:hasPermission name="报警记录导出">--%>
            <button class="layui-btn" id="exportBtn"> &nbsp;导 &nbsp;出&nbsp; </button>
           <%-- </shiro:hasPermission>--%>
        </div>
        <div class="search-btn-group">
            <input type="text" name="startTime" id="startTime" lay-verify="date" placeholder="请选择开始时间" autocomplete="off" class="layui-input layui-input_">
            <input type="text" name="endTime"  id="endTime" lay-verify="date"  placeholder="请选择结束时间" autocomplete="off" class="layui-input layui-input_">
            <button class="layui-btn layui-btns" id="simple">查询</button>
            <button class="layui-btn layui-btns layui-bg-orange" id="superBtn">高级查询</button>
        </div>
    </div>
    <div class="tableDiv">
        <table id="layui-table" lay-filter="tableBox" class="layui-table"></table>
    </div>
</div>
<!-----------------默认表格结束------------>
<!--高级查询-->
<form class="layui-form" action="" id="formHtml" lay-filter="updForm">
    <input type="hidden" id="level"/>
    <input type="hidden" id="parentId"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" title="报警类型">报警类型</label>
            <div class="layui-input-inline">
                <select name="" id="type">
                    <option value="">全部</option>
                    <option value="0">电池电量报警</option>
                    <option value="1">低水量报警</option>
                    <option value="2">磁攻击报警</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button type="button" class="layui-btn" lay-submit="" lay-filter="confirmBtn" id="gj">查询</button>
            <button type="button" class="layui-btn layui-btn-primary" id="closeBtn">收起</button>
        </div>
    </div>
</form>
</body>
<script type="text/html" id="handle">
    <%--<shiro:hasPermission name="查看报警记录">--%>
    <a title="查看" lay-event="detail" style="cursor:pointer; margin-right:5px;">
        <i class="layui-icon">&#xe63c;</i>
    </a>
    <%--</shiro:hasPermission>--%>
</script>
<script src="${ctx}/resources/js/layui.all.js"></script>
<script type="text/javascript" src="${ctx}/resources/js/common.js" ></script>
<script type="text/javascript" src="${ctx}/resources/plugins/zTree_v3/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript">

    layui.use([ 'laydate'], function(){
        var $ = layui.$;
        var laydate = layui.laydate;
        var nowTime = new Date().valueOf();
        var max = null;

        var start = laydate.render({
            elem: '#startTime',
            type: 'date',
            format:'yyyy-MM-dd',
            max: nowTime,
            btns: ['clear', 'confirm'],
            done: function(value, date){
                endMax = end.config.max;
                end.config.min = date; //最大时间为结束时间的开始值
                end.config.min.month = date.month -1;
            }
        });

        var end = laydate.render({
            elem: '#endTime',
            type: 'date',
            max:  nowTime,
            format:'yyyy-MM-dd',
            done: function(value, date){
                if($.trim(value) == ''){
                    var curDate = new Date();
                    date = {'date': curDate.getDate(), 'month': curDate.getMonth()+1, 'year': curDate.getFullYear()};
                }
                start.config.max = date;//最小时间为开始时间的最大值
                start.config.max.month = date.month -1;
            }
        })
    });

    //主动加载jquery模块
    layui.use(['jquery', 'layer'], function(){
        var $ = layui.jquery //重点处
            ,layer = layui.layer;
        table = layui.table;//表格，注意此处table必须是全局变量
        var arr = [[
            {type:'checkbox'}
            ,{field: 'areaName', title: '区域'}
            ,{field: 'apartmentName', title: '公寓'}
            ,{field: 'buildName', title: '楼栋'}
            ,{field: 'floorName', title: '楼层'}
            ,{field: 'roomNum', title: '房间号'}
            ,{field: 'waterNum', title: '水表号'}
            ,{field: 'ipAddress', title: '集中器IP'}
            ,{field: 'warningTime', title: '报警时间'}
            ,{field: 'typeName', title: '报警类型'}
            ,{title: '操作',toolbar:'#handle'}
        ]];
        var limitArr =[10,20,30];
        var urls = '${ctx}/warning/warningData.action';
        com.tableRender('#layui-table','tableId','full-50',limitArr,urls,arr);//加载表格,注意tableId是自定义的，在表格重载需要！！

        //查看
        table.on('tool(tableBox)', function(obj){
            var data = obj.data;
            if(obj.event === 'detail'){
                com.pageOpen("查看报警记录","${ctx}/warning/findWarningById.action?id="+data.id,['800px', '550px']);
            }
        });


        $(function(){
            //简单查询重载表格
            $("#simple,#gj").on("click",function(){
                var endDate=$("#endTime").val();
                var startDate=$("#startTime").val();
                endDate.length==0&&startDate.length!=0||endDate.length!=0&&startDate.length==0 ? layer.msg("请选择开始时间和结束时间!",{
                    icon:7,
                    time:2000
                }) : com.reloadTable({
                    startTime:$("#startTime").val().trim(),
                    endTime:$("#endTime").val().trim(),
                    type:$("#type").val().trim()
                });
            });
        });

        //表格数据导出
        $(function(){
            $("#exportBtn").on("click",function(){
                var str="区域,公寓,楼栋,楼层,房间号,水表号,集中器IP,报警时间,报警类型";
                var name="报警记录";
                var url="${ctx}/warning/export.action?str="+str+"&name="+name+
                    "&startTime="+$("#date2").val()+"&endTime="+$("#date1").val()+
                    "&type="+$("#type").val()+
                    "&level="+$("#level").val()+"&id="+$("#parentId").val();
                window.location.href=url;
            });
        });

        //tree
        layui.config({
            base: '${ctx}/resources/layui_ext/dtree/' //配置 layui 第三方扩展组件存放的基础目录
        }).extend({
            dtree: 'dtree' //定义该组件模块名
        }).use(['element','layer', 'dtree'], function(){
            var layer = layui.layer,
                dtree = layui.dtree,
                $ = layui.$;
            dtree.render({
                elem: "#demoTree1",  //绑定元素
                url: "${ctx}/region/treeData.action", //异步接口
                initLevel: 1,  // 指定初始展开节点级别
                cache: false,  // 当取消节点缓存时，则每次加载子节点都会往服务器发送请求
                async: false,
            });

            //单击节点 监听事件
            dtree.on("node('demoTree1')" ,function(param){
                $("#level").val(param.level);
                $("#parentId").val(param.parentId);
                /*查询条件*/
                var tableWhere={
                    type:'',
                    endTime: ''
                    ,startTime:''
                    ,room_num:''
                    ,room_type_id:''
                    ,apartment_name:''
                    ,floor_name:''
                    ,level:param.level
                    ,id:param.parentId
                };
                com.reloadTable(tableWhere);
            });
        });
    })
</script>
</html>
