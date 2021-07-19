<%@ Page Title="" Language="C#" MasterPageFile="~/BackEnd/backLayout.Master" AutoEventWireup="true" CodeBehind="b_NewsAdd.aspx.cs" Inherits="Tayana.WebForm2" ValidateRequest="False" %>

<%--<%@ Register Assembly="CKFinder" Namespace="CKFinder" TagPrefix="CKFinder" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .switch {
            position: relative;
            display: inline-block;
            width: 37px;
            height: 17px;
        }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #B4C3CA;
            -webkit-transition: .5s;
            transition: .5s;
            border-radius: 34px;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 15px;
                width: 15px;
                left: 1px;
                bottom: 1px;
                background-color: white;
                -webkit-transition: .5s;
                transition: .5s;
                border-radius: 50%;
            }

        input:checked + .slider {
            background-color: #2ED8B6;
        }

        input:focus + .slider {
            box-shadow: 0 0 1px #2196F3;
        }

        input:checked + .slider:before {
            -webkit-transform: translateX(20px);
            -ms-transform: translateX(20px);
            transform: translateX(20px);
        }

        .new-button {
            position: absolute;
            display: inline-block;
            padding: 8px 11px;
            cursor: pointer;
            border-radius: 3px;
            background-color: #81EED8;
            font-size: 16px;
            font-weight: bold;
            color: #fff;
        }

        .button-wrap {
            position: relative;
        }

        .adjust-btn {
            background-color: #74ECD4;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #81EED8;
                color: white;
            }

        #picPreview {
            border: 1px solid #808080;
            width: 240px;
            height: 200px;
        }
    </style>
    <script type="text/javascript">
        function preview(file) {
            var preview_div = document.getElementById('picPreview');
            if (file.files && file.files[0]) {
                var reader = new FileReader();
                reader.onload = function (evt) {
                    preview_div.innerHTML = '<img src="' + evt.target.result + '" style="width:240px;height:200px;" />';
                }
                reader.readAsDataURL(file.files[0]);
            }
            else {
                preview_div.innerHTML = '<div class="preview" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src=\'' + file.value + '\'"></div>';
            }
        }
    </script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script>
        $(document).on("submit", "form", function (event) {
            window.onbeforeunload = null;
        });
        window.onbeforeunload = confirmExit;
        function confirmExit() {
            return "您確定要離開此頁嗎?";
        }
    </script>
    <script src="Scripts/ckeditor/ckeditor.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-12">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">新聞發佈</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToListBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="BackToList_Click" OnClientClick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="ti-back-right"></i>返回新聞列表</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    新聞可選擇是否要置頂。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="b_NewsList.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;">管理新聞列表</a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">新聞發佈</a>
                    </li>
                </ul>
                <br />
                <asp:Label ID="warning" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
            </div>
        </div>
    </div>
    <div class="col-sm-12">
        <div class="card">
            <div class="card-block">
                <h4 class="sub-title">請輸入新聞封面簡介</h4>
                <div style="position: absolute; top: 20px; left: 213px">
                    <label class="switch">
                        <asp:CheckBox ID="pin" runat="server" />
                        <span class="slider"></span>
                    </label>
                    <span style="font-size: 16px; padding-left: 10px; font-weight: bold;" class="text-success">置頂</span>
                </div>
                <div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">發佈日期</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="postDate" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">新聞標題*</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="newsTitle" runat="server" CssClass="form-control" placeholder="請輸入新聞標題" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">新聞副標題*</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="newsSubs" runat="server" CssClass="form-control" placeholder="請輸入新聞副標題" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">新聞封面圖*</label>
                        <div class="col-sm-5 button-wrap">
                            <label class="new-button" for="ContentPlaceHolder1_newsCoverPic">選擇檔案</label>
                            <asp:FileUpload ID="newsCoverPic" runat="server" CssClass="form-control" onchange="preview(this)" required="" />
                            <asp:Label ID="lblmessage" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                            <div id="picPreview" style="position: absolute; right: -330px; bottom: 0;">新聞封面圖預覽</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-block">
                <h4 class="sub-title">請輸入新聞內部文章*&nbsp<span style="color: darkcyan">( 上傳圖片建議的寬度為710以內 )</span><asp:Label ID="check_newsContent" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label></h4>
                <asp:TextBox ID="newsContent" runat="server" TextMode="MultiLine"></asp:TextBox><br />
                <div class="d-flex justify-content-end">
                    <asp:Button ID="PostNews" runat="server" Text="送出" CssClass="btn btn-round btn-success font-weight-bold fontsize-18" OnClick="PostNews_Click" />
                </div>
            </div>
        </div>
    </div>
    <script>
        CKEDITOR.replace('ContentPlaceHolder1_newsContent',
            {
                filebrowserBrowseUrl: '../Scripts/ckfinder/ckfinder.html',
                filebrowserImageBrowseUrl: '../Scripts/ckfinder/ckfinder.html?type=Images',
                filebrowserFlashBrowseUrl: '../Scripts/ckfinder/ckfinder.html?type=Flash',
                filebrowserUploadUrl: '../Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Files',
                filebrowserImageUploadUrl: '../Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Images',
                filebrowserFlashUploadUrl: '../Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Flash',
                height: '500',
                uiColor: '#9FE9BF'
            });
    </script>
</asp:Content>