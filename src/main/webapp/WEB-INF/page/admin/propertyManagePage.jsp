<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <script>
        //检索数据集
        var dataList = {
            "property_name": null,
            "category_id": null
        };
        $(function () {
            //刷新下拉框
            $('#select_product_category').selectpicker('refresh');
            //点击查询按钮时
            $("#btn_property_submit").click(function () {
                const property_name = $.trim($("#input_property_name").val());
                const category_id = parseInt($("#select_product_category").val());
                //封装数据
                dataList.property_name = encodeURI(property_name);
                dataList.category_id = category_id;
                getData($(this), "admin/property/0/10", dataList);
            });
            //点击刷新按钮时
            $("#btn_property_refresh").click(function () {
                //清除数据
                dataList.property_name = null;
                dataList.category_id = null;
                //获取数据
                getData($(this), "admin/property/0/10", null);
            });
            //点击table中的数据时
            $("#table_property_list").find(">tbody>tr").click(function () {
                trDataStyle($(this));
            });
        });
        //获取属性数据
        function getData(object, url, dataObject) {
            const table = $("#table_property_list");
            const tbody = table.children("tbody").first();
            $.ajax({
                url: url,
                type: "get",
                data: dataObject,
                success: function (data) {
                    //清空原有数据
                    tbody.empty();
                    //设置样式
                    $(".loader").css("display","none");
                    object.attr("disabled",false);
                    //显示属性统计数据
                    $("#property_count_data").text(data.propertyCount);
                    if(data.propertyList.length > 0) {
                        for (let i = 0; i < data.propertyList.length; i++) {
                            const property_id = data.propertyList[i].property_id;
                            const property_name = data.propertyList[i].property_name;
                            const category_name = data.propertyList[i].property_category.category_name;
                            const num = i + 1 + (data.pageUtil.index) * 10;
                            //显示属性数据
                            tbody.append("<tr><td><input type='checkbox' class='cbx_select' id='cbx_property_select_" + property_id + "'><label for='cbx_property_select_" + property_id + "'></label></td><td>"+num+"</td><td title='" + property_name + "'>" + property_name + "</td><td title='" + category_name + "'>" + category_name + "</td>"+
                                "<td><span class='td_special' title='查看属性详情'><a href='javascript:void(0)' onclick='getChildPage(this)'>修改</a></span>" +
                                "&nbsp;&nbsp;<span class='td_special' title='删除属性'><a href='javascript:void(0)' onclick='delpropertyChildPage(this)'>删除</a></span>"+
                                "</td><td hidden class='property_id'>" + property_id + "</td></tr>");
                        }
                        //绑定事件
                        tbody.children("tr").click(function () {
                            trDataStyle($(this));
                        });
                        //分页
                        const pageUtil = {
                            index: data.pageUtil.index,
                            count: data.pageUtil.count,
                            total: data.pageUtil.total,
                            totalPage: data.totalPage
                        };
                        createPageDiv($(".loader"), pageUtil);
                    }
                },
                beforeSend: function () {
                    $(".loader").css("display", "block");
                    object.attr("disabled",true);
                },
                error: function () {

                }
            });
        }

        // 获取产品属性子界面
        function getChildPage(obj) {
            let url;
            let title;
            if (obj === null) {
                title = "添加属性";
                url = "property/new";
            } else {
                title = "属性详情";
                url = "property/" + $(obj).parents("tr").find(".property_id").text();
            }

            //设置样式
            $("#div_home_title").children("span").text(title);
            document.title = "Tmall管理后台 - " + title;
            //ajax请求页面
            ajaxUtil.getPage(url, null, true);
        }

        //删除属性
        function delpropertyChildPage(obj) {
            let url = "admin/property/del/" + $(obj).parents("tr").find(".property_id").text();
            $(".modal-body").text("您确定要删除该属性吗？");
            $('#modalDiv').modal();
            $("#btn-ok").unbind("click").click(function () {
                $.ajax({
                    url: url,
                    type: "get",
                    traditional: true,
                    success: function (data) {
                        if (data.success) {
                            $('#modalDiv').modal("hide");
                            //清除数据
                            dataList.property_name = null;
                            dataList.category_id = null;
                            //获取数据
                            getData($(this), "admin/property/0/10", null);
                        } else {
                            $(".modal-body").text("删除失败！");
                        }
                    }
                });
            });
        }

        //获取页码数据
        function getPage(index) {
            getData($(this), "admin/property/" + index + "/10", dataList);
        }
    </script>
</head>
<body>
<div class="frm_div text_info">
    <div class="frm_group">
        <label class="frm_label" id="lbl_property_name" for="input_property_name">属性名称</label>
        <input class="frm_input" id="input_property_name" type="text" maxlength="50"/>
        <label class="frm_label" id="lbl_product_category_id" for="select_product_category">产品类型</label>
        <select class="selectpicker" id="select_product_category" data-size="8">
            <option value="0">全部</option>
            <c:forEach items="${requestScope.categoryList}" var="category">
                <option value="${category.category_id}">${category.category_name}</option>
            </c:forEach>
        </select>
        <input class="frm_btn" id="btn_property_submit" type="button" value="查询"/>
        <input class="frm_btn frm_clear" id="btn_clear" type="button" value="重置"/>
    </div>
    <div class="frm_group_last">
      <input class="frm_btn frm_add" id="btn_property_add" type="button" value="添加一个属性" onclick="getChildPage(null)"/>
      <input class="frm_btn frm_refresh" id="btn_property_refresh" type="button" value="刷新属性列表"/>
    </div>
</div>
<div class="data_count_div text_info">
    <svg class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2522" width="16"
         height="16">
        <path d="M401.976676 735.74897c-88.721671 0-172.124196-34.635845-234.843656-97.526197-62.724577-62.86784-97.271394-146.453537-97.271394-235.358379s34.546817-172.490539 97.276511-235.361449c62.715367-62.887282 146.117892-97.522104 234.838539-97.522104 88.719624 0 172.135452 34.633798 234.881518 97.522104 62.704111 62.875003 97.235578 146.4607 97.235578 235.361449 0 88.901773-34.530444 172.487469-97.231485 235.358379C574.112128 701.116195 490.6963 735.74897 401.976676 735.74897zM401.976676 121.204479c-75.012438 0-145.533584 29.290093-198.572568 82.474386-109.585861 109.834524-109.585861 288.539602-0.004093 398.36901 53.043077 53.188386 123.564223 82.47848 198.577684 82.47848 75.015507 0 145.553027-29.291117 198.620663-82.47848C710.126918 492.220514 710.126918 313.511343 600.593246 203.678866 547.530726 150.496619 476.992183 121.204479 401.976676 121.204479z"
              p-id="2523" fill="#FF7874">
        </path>
        <path d="M932.538427 958.228017c-6.565533 0-13.129019-2.508123-18.132986-7.52437L606.670661 642.206504c-9.989515-10.014074-9.969049-26.231431 0.045025-36.220946s26.230408-9.969049 36.220946 0.045025l307.73478 308.497143c9.989515 10.014074 9.969049 26.231431-0.045025 36.220946C945.627537 955.735244 939.081447 958.228017 932.538427 958.228017z"
              p-id="2524" fill="#FF7874">
        </path>
    </svg>
    <span class="data_count_title">查看合计</span>
    <span>属性总数:</span>
    <span class="data_count_value" id="property_count_data">${requestScope.propertyCount}</span>
    <span class="data_count_unit">种</span>
</div>
<div class="table_normal_div">
    <table class="table_normal" id="table_property_list">
        <thead class="text_info">
        <tr>
            <th><input type="checkbox" class="cbx_select" id="cbx_select_all"><label for="cbx_select_all"></label></th>
            <th>编号</th>
            <th>属性名称</th>
            <th>产品类型</th>
            <th>操作</th>
            <th hidden class="property_id">属性ID</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${requestScope.propertyList}" var="property" varStatus="index">
            <tr>
                <td><input type="checkbox" class="cbx_select" id="cbx_property_select_${property.property_id}"><label for="cbx_property_select_${property.property_id}"></label></td>
                <td title="编号">${index.index + 1}</td>
                <td title="${property.property_name}">${property.property_name}</td>
                <td title="${property.property_category.category_name}">${property.property_category.category_name}</td>
                <td><span class="td_special" title="查看属性详情"><a href="javascript:void(0)"
                                                               onclick="getChildPage(this)">修改</a></span>
                    &nbsp;&nbsp;<span class="td_special" title="删除属性"><a href="javascript:void(0)"
                                                               onclick="delpropertyChildPage(this)">删除</a></span>
                </td>
                <td hidden><span class="property_id">${property.property_id}</span></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <%@ include file="include/page.jsp" %>
    <div class="loader"></div>
</div>

<%-- 模态框 --%>
<div class="modal fade" id="modalDiv" tabindex="-1" role="dialog" aria-labelledby="modalDiv" aria-hidden="true"
     data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">提示</h4>
            </div>
            <div class="modal-body">您确定要删除吗？</div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="btn-ok">确定</button>
                <button type="button" class="btn btn-default" data-dismiss="modal" id="btn-close">关闭</button>
            </div>
        </div>
        <%-- /.modal-content %--%>
    </div>
    <%-- /.modal %--%>
</div>
</body>
</html>
