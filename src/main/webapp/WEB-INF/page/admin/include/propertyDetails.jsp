<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <script>
        $(function () {
            //刷新下拉框
            $('#select_product_category').selectpicker('refresh');
            if ($("#details_property_id").val() === "") {
                /******
                 * event
                 ******/
                //单击保存按钮时
                $("#btn_property_save").click(function () {
                    const property_name = $.trim($("#input_property_name").val());
                    const category_id = parseInt($("#select_product_category").val());
                    //校验数据合法性
                    let yn = true;
                    if (property_name === "") {
                        styleUtil.basicErrorShow($("#lbl_property_name"));
                        yn = false;
                    }
                    if (category_id === 0) {
                        styleUtil.basicErrorShow($("#lbl_product_category_id"));
                        yn = false;
                    }
                    if (!yn) {
                        return;
                    }

                    const dataList = {
                        "property_name": property_name
                    };
                    doAction(dataList, "admin/property/" + category_id, "POST");
                });
            } else {
                //设置属性编号
                $("#span_property_id").text('${requestScope.property.property_id}');
                //单击保存按钮时
                $("#btn_property_save").click(function () {
                    const property_id = $("#details_property_id").val();
                    const property_name = $.trim($("#input_property_name").val());
                    const category_id = parseInt($("#select_product_category").val());
                    //校验数据合法性
                    let yn = true;
                    if (property_name === "") {
                        styleUtil.basicErrorShow($("#lbl_property_name"));
                        yn = false;
                    }
                    if (category_id === 0) {
                        styleUtil.basicErrorShow($("#lbl_product_category_id"));
                        yn = false;
                    }
                    if (!yn) {
                        return;
                    }

                    const dataList = {
                        "property_name": property_name
                    };
                    doAction(dataList, "admin/property/" + property_id+"/"+category_id, "PUT");
                });
            }

            //单击取消按钮时
            $("#btn_property_cancel").click(function () {
                $(".menu_li[data-toggle=property]").click();
            });
            //获取到输入框焦点时
            $("input:text").focus(function () {
                styleUtil.basicErrorHide($(this).prev("label"));
            });
        });

        //属性操作
        function doAction(dataList, url, type) {
            $.ajax({
                url: url,
                type: type,
                data: dataList,
                traditional: true,
                success: function (data) {
                    $("#btn_property_save").attr("disabled", false).val("保存");
                    if (data.success) {
                        $("#btn-ok,#btn-close").unbind("click").click(function () {
                            $('#modalDiv').modal("hide");
                            setTimeout(function () {
                                //ajax请求页面
                                ajaxUtil.getPage("property",null);
                            }, 170);
                        });
                        $(".modal-body").text("保存成功！");
                        $('#modalDiv').modal();
                    }
                },
                beforeSend: function () {
                    $("#btn_product_save").attr("disabled", true).val("保存中...");
                },
                error: function () {

                }
            });
        }
    </script>
    <style rel="stylesheet">

        .details_property_list > li {
            list-style: none;
            padding: 5px 0;
        }

        div.br {
            height: 20px;
        }
    </style>
</head>
<body>
<div class="details_div_first">
    <input type="hidden" value="${requestScope.property.property_id}" id="details_property_id"/>
    <div class="frm_div">
        <label class="frm_label text_info" id="lbl_property_id">属性编号</label>
        <span class="details_value" id="span_property_id">系统指定</span>
    </div>
    <div class="frm_div">
        <label class="frm_label text_info" id="lbl_property_name" for="input_property_name">属性名称</label>
        <input class="frm_input" id="input_property_name" type="text" maxlength="50"
               value="${requestScope.property.property_name}"/>
    </div>
    <div class="frm_div text_info">
        <label class="frm_label" id="lbl_product_category_id" for="select_product_category">产品类型</label>
        <select class="selectpicker" id="select_product_category" data-size="8">
            <option value="0">全部</option>
            <c:forEach items="${requestScope.categoryList}" var="category">
                <option value="${category.category_id}" <c:if test="${category.category_id == requestScope.property.property_category.category_id}">selected="selected"</c:if>>${category.category_name}</option>
            </c:forEach>
        </select>
    </div>
</div>
<div class="details_tools_div">
    <input class="frm_btn" id="btn_property_save" type="button" value="保存"/>
    <input class="frm_btn frm_clear" id="btn_property_cancel" type="button" value="取消"/>
</div>
<%-- 模态框 --%>
<div class="modal fade" id="modalDiv" tabindex="-1" role="dialog" aria-labelledby="modalDiv" aria-hidden="true"
     data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">提示</h4>
            </div>
            <div class="modal-body">您确定要删除分类图片吗？</div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="btn-ok">确定</button>
                <button type="button" class="btn btn-default" data-dismiss="modal" id="btn-close">关闭</button>
            </div>
        </div>
        <%-- /.modal-content --%>
    </div>
    <%-- /.modal --%>
</div>
<div class="loader"></div>
</body>
</html>
