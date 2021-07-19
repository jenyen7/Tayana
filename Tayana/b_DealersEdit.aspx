<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_DealersEdit.aspx.cs" Inherits="Tayana.WebForm9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .new-button {
            position: absolute;
            display: inline-block;
            padding: 8px 11px;
            cursor: pointer;
            border-radius: 3px;
            background-color: #E3D3D0;
            font-size: 16px;
            font-weight: bold;
            color: #fff;
        }

        .button-wrap {
            position: relative;
        }

        .adjust-btn {
            background-color: #DAC4C1;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #E3D3D0;
                color: white;
            }

        #picPreview {
            border: 1px solid #808080;
            width: 250px;
            height: 200px;
        }
    </style>
    <script type="text/javascript">
        window.onload = function () {
            var imgvalue = document.all('ContentPlaceHolder1_hidDealerPic').value;
            document.getElementById('picPreview').innerHTML = '<img src="./assets_tayana/upload/Images/' + imgvalue + '" style="width:250px;height:200px;" />';
        }
        function preview(file) {
            var preview_div = document.getElementById('picPreview');
            if (file.files && file.files[0]) {
                var reader = new FileReader();
                reader.onload = function (evt) {
                    preview_div.innerHTML = '<img src="' + evt.target.result + '" style="width:250px;height:200px;" />';
                }
                reader.readAsDataURL(file.files[0]);
            }
            else {
                var imgvalue = document.all('ContentPlaceHolder1_hidDealerPic').value;
                preview_div.innerHTML = '<img src="./assets_tayana/upload/Images/' + imgvalue + '" style="width:250px;height:200px;" />';
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-10">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">編輯代理商</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToList" runat="server" CssClass="btn btn-round f-16 adjust-btn font-weight-bold" OnClick="BackToList_Click" OnClientClick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="ti-back-right"></i>返回代理商列表</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    如果有修改資料，離開此頁前請記得儲存。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="b_DealersList.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;">管理代理商列表</a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">編輯代理商</a>
                    </li>
                </ul>
                <br />
                <asp:Label ID="warning" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
            </div>
        </div>
    </div>
    <div class="col-sm-10">
        <div class="card">
            <div class="card-block">
                <h4 class="sub-title">編輯代理商資料</h4>
                <div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">代理商所屬區域</label>
                        <div class="col-sm-4">
                            <asp:DropDownList ID="DDLcountries" runat="server" CssClass="form-control" OnSelectedIndexChanged="DDLcountries_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </div>
                        <div class="col-sm-4">
                            <asp:DropDownList ID="DDLcities" runat="server" CssClass="form-control"></asp:DropDownList>
                            <asp:Label ID="citylbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                            <%--Enabled="False"--%>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">代理商名稱</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="dealersName" runat="server" CssClass="form-control" placeholder="請輸入代理商名稱" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">聯絡人名稱</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="contactName" runat="server" CssClass="form-control" placeholder="請輸入聯絡人名稱" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">代理商地址</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="dealersAddress" runat="server" CssClass="form-control" placeholder="請輸入代理商地址" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">代理商電話</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="dealersTel" runat="server" CssClass="form-control" placeholder="請輸入代理商電話號碼" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">代理商傳真</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="dealersFax" runat="server" CssClass="form-control" placeholder="請輸入代理商傳真號碼"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">代理商Email</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="dealersEmail" runat="server" CssClass="form-control" placeholder="請輸入代理商Email" required="" TextMode="Email"></asp:TextBox>
                            <asp:Label ID="emaillbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">代理商封面圖</label>
                        <div class="col-sm-8 button-wrap">
                            <label class="new-button" for="ContentPlaceHolder1_dealersPic">選擇檔案</label>
                            <asp:FileUpload ID="dealersPic" runat="server" CssClass="form-control" onchange="preview(this)" />
                            <div id="picPreview" style="margin-top: 20px">代理商封面圖預覽</div>
                            <asp:Label ID="lblmessage" runat="server" ForeColor="Red"></asp:Label>
                            <asp:HiddenField ID="hidDealerPic" runat="server" />
                        </div>
                    </div>
                    <div class="d-flex justify-content-end">
                        <asp:Button ID="EditDealerBtn" runat="server" Text="儲存" CssClass="btn btn-round btn-warning font-weight-bold fontsize-18" OnClick="EditDealerBtn_Click" />
                        <input id="Reset1" type="reset" value="重設" class="btn btn-round adjust-btn fontsize-18" style="margin-left: 10px" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>