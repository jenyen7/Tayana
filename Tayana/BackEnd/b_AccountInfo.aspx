<%@ Page Title="" Language="C#" MasterPageFile="~/BackEnd/backLayout.Master" AutoEventWireup="true" CodeBehind="b_AccountInfo.aspx.cs" Inherits="Tayana.WebForm23" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .new-fileUploadBtn {
            position: absolute;
            display: inline-block;
            padding: 8px 11px;
            cursor: pointer;
            border-radius: 3px;
            background-color: #C3CFD4;
            font-size: 16px;
            color: white;
        }

        .button-wrap {
            position: relative;
        }

        .adjust-addbtn {
            background-color: #546D77;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-addbtn:hover {
                background-color: #6A8894;
            }

        .adjust-btn {
            background-color: #87A0AA;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #A5B7BF;
                color: white;
            }

        #picPreview {
            border: 1px solid #808080;
            border-radius: 50%;
            width: 250px;
            height: 250px;
        }
    </style>
    <script type="text/javascript">
        window.onload = function () {
            var org_avatar = document.getElementById("<%=hidAvatar.ClientID %>").value;
            document.getElementById('picPreview').innerHTML = '<img src="../assets/images/' + org_avatar + '" style="width:250px;height:250px;border-radius: 50%;" />';
        }
        function preview(file) {
            var preview_div = document.getElementById('picPreview');
            if (file.files && file.files[0]) {
                var reader = new FileReader();
                reader.onload = function (evt) {
                    preview_div.innerHTML = '<img src="' + evt.target.result + '" style="width:250px;height:250px;border-radius: 50%;" />';
                }
                reader.readAsDataURL(file.files[0]);
            }
            else {
                var org_avatar = document.getElementById("<%=hidAvatar.ClientID %>").value;
                document.getElementById('picPreview').innerHTML = '<img src="../assets/images/' + org_avatar + '" style="width:250px;height:250px;border-radius: 50%;" />';
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-9">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">個人檔案</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToIndexBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="BackToIndexBtn_Click" OnClientClick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料如果尚未儲存將會遺失，確定要離開嗎?')) window.event.returnValue = false;">返回首頁</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    在此修改個人資料，如果有更動，離開前請記得儲存，稱號及頭像重新登入時會更新。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料如果尚未儲存將會遺失，確定要離開嗎?')) window.event.returnValue = false;"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">個人檔案</a>
                    </li>
                </ul>
                <br />
                <asp:Label ID="warning" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
            </div>
        </div>
    </div>
    <div class="col-sm-9">
        <div class="card">
            <div class="card-block">
                <h4 class="sub-title">編輯個人資料</h4>
                <div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">稱號</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="username" runat="server" CssClass="form-control" placeholder="請輸入稱號" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">電子郵件</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="email" runat="server" CssClass="form-control" placeholder="請輸入Email" TextMode="Email" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">頭像</label>
                        <div class="col-sm-6 button-wrap">
                            <label class="new-fileUploadBtn" for="ContentPlaceHolder1_avatar">選擇檔案</label>
                            <asp:FileUpload ID="avatar" runat="server" CssClass="form-control" onchange="preview(this)" />
                            <asp:Label ID="avatarlbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                            <div id="picPreview" style="margin-top: 25px; text-align: center">頭像預覽</div>
                            <asp:HiddenField ID="hidAvatar" runat="server" />
                        </div>
                    </div>
                </div>
                <div class="d-flex justify-content-end">
                    <asp:Button ID="saveBtn" runat="server" Text="儲存" CssClass="btn btn-round adjust-addbtn" OnClick="saveBtn_Click" />
                    <input id="Reset1" type="reset" value="重設" class="btn btn-round adjust-btn" style="margin: 0 10px 0 20px" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>