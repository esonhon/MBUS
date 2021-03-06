<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html><head>
    <meta charset="utf-8">
    <title></title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
	<link rel="stylesheet" href="${ctx}/resources/css/layui.css"/>
    <link rel="stylesheet" href="${ctx}/resources/css/admin.css" media="all">
    <link rel="stylesheet" href="${ctx}/resources/plugins/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <link rel="stylesheet" href="${ctx}/resources/css/addClass.css" media="all"/>
    <style type="text/css">
    .layui-form-label{width:90px;}
    .layui-input-block{ margin-left:120px;}
    </style>
</head>
<body>
<div class="layui-body layui-bg-white">
	<div class="layui-fluid">
			<div class="layui-row  layui-col-space15">
				<fieldset class="layui-elem-field layui-field-title"
					style="margin-top: 12px;">
					<legend>资源信息</legend>
				</fieldset>
				<form class="layui-form"  method="post">
				<input type="hidden" name="id" id="id" value="${authority.id }" />
					<div class="layui-form-item">
						<label class="layui-form-label">权限名称:</label>
						<div class="layui-input-block">
							<input type="text" name="authorityname" id="authorityname" value="${authority.authorityname }"
								lay-verify="authorityname|required" autocomplete="off" placeholder="请输入权限名称"
								class="layui-input" maxlength="20">
						</div>
					</div>
					<div class="layui-form-item layui-form-text">
    					<label class="layui-form-label">备注说明</label>
    					<div class="layui-input-block">
      						<textarea placeholder="请输入内容(最多200字符)" class="layui-textarea" name="descr" id="descr" maxlength="200">${authority.descr }</textarea>
    					</div>
  					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<button class="layui-btn" lay-submit="" lay-filter="demo1" id="demo1">提交</button>
						</div>
					</div>
					
					</form>
			</div>
		</div>
</div>

<script src="${ctx}/resources/js/jquery-1.11.2.min.js"></script>
<script src="${ctx}/resources/plugins/layui/layui.js"></script>
<script src="${ctx}/resources/js/formatTime.js"></script>
<script>
    var id=$("#id").val();
layui.use('element', function(){
    var element = layui.element;
});
layui.use('layer', function(){
    var layer = layui.layer;

});

layui.use(['form', 'layedit', 'laydate'], function(){
	 var form = layui.form
    form.verify({
        authorityname:[/^[a-zA-Z0-9_\u4e00-\u9fa5]{1,12}$/, '权限名称为1到12位   汉字、大小写字母、数字']
    });
    //检查权限名称的唯一性
    function isCheckAuthorityname(data){
        var num;
        $.ajax({
            type : "POST", //提交方式
            url : "${ctx}/authorityMgt/isCheckAuthorityname.action", //路径
            data : data, //数据，这里使用的是Json格式进行传输
            dataType : "json",
            async : false,
            success : function(result) { //返回数据根据结果进行相应的处理
                num = result;
            }
        });
        return num;
    }


    //监听提交
    form.on('submit(demo1)', function (data) {
        var authorityname=$("#authorityname").val();
        var data = $("form").serialize();
        if(id.length !=0){
            if(authorityname != '${authority.authorityname}'){
                var num=isCheckAuthorityname(data);
                if(num != 0 && num != -1) {
                    layer.msg('权限名称已存在,请重新输入！', {
                        icon: 7,
                        time: 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function () {
                        $("#authorityname").focus();
                        $("#demo1").attr('disabled', false);
                    });
                    return false;
                }
            }else{

            }
            $.ajax({
                type: "POST", //提交方式
                url: "${ctx}/authorityMgt/save.action",//路径
                data: data,//数据，这里使用的是Json格式进行传输
                dataType: "json",
                async: false,
                success: function (result) {//返回数据根据结果进行相应的处理
                    layer.msg(result, {
                        icon : 1,
                        time : 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function() {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });

                },
                error: function (result) {
                    layer.msg("操作失败,请选择管理员!", {
                        icon : 5,
                        time : 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function() {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });
                }
            });
            return false;
        }else {
            var num=isCheckAuthorityname(data);
            if(num != 0 && num != -1) {
                layer.msg('权限名称已存在,请重新输入！', {
                    icon: 7,
                    time: 2000 //2秒关闭（如果不配置，默认是3秒）
                }, function () {
                    $("#authorityname").focus();
                    $("#demo1").attr('disabled', false);
                });
                return false;
            }
            $.ajax({
                type: "POST", //提交方式
                url: "${ctx}/authorityMgt/save.action",//路径
                data: data,//数据，这里使用的是Json格式进行传输
                dataType: "json",
                async: false,
                success: function (result) {//返回数据根据结果进行相应的处理
                    layer.msg(result, {
                        icon : 1,
                        time : 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function() {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });

                },
                error: function (result) {
                    layer.msg("操作失败,请选择管理员!", {
                        icon : 5,
                        time : 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function() {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });
                }
            })
            return false;
        }
    });

})
</script>
</body>
</html>