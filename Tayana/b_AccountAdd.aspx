<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_AccountAdd.aspx.cs" Inherits="Tayana.WebForm22" %>

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
            background-color: #A96EFC;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }

            .adjust-addbtn:hover {
                background-color: #BB8BFD;
            }

        .adjust-btn {
            background-color: #C49AFD;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #D5B8FD;
                color: white;
            }

        .adjust-text {
            font-size: 16px;
            padding-left: 20px;
            font-weight: bold;
            color: #546D77;
        }

        .checkAll, .checkSingle {
            visibility: hidden;
        }

            .checkAll:after, .checkSingle:after {
                content: " ";
                display: inline-block;
                color: #4099FF;
                width: 20px;
                height: 20px;
                border: 1px solid #4099FF;
                padding-bottom: 8px;
                padding-left: 3px;
                border-radius: 3px;
                visibility: visible;
            }

            .checkAll:checked:after, .checkSingle:checked:after {
                content: "✓";
                font-weight: bold;
            }

        #picPreview {
            border: 1px solid #808080;
            border-radius: 50%;
            width: 250px;
            height: 250px;
        }
    </style>
    <script type="text/javascript">
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
        $(document).ready(function () {
            $("#ContentPlaceHolder1_checkedAll").click(function () {
                if (this.checked) {
                    $(".checkSingle").each(function () {
                        this.checked = true;
                    });
                } else {
                    $(".checkSingle").each(function () {
                        this.checked = false;
                    });
                }
            });

            $(".checkSingle").click(function () {
                if ($(this).is(":checked")) {
                    var isAllChecked = 0;

                    $(".checkSingle").each(function () {
                        if (!this.checked)
                            isAllChecked = 1;
                    });
                    if (isAllChecked == 0) {
                        $("#ContentPlaceHolder1_checkedAll").prop("checked", true);
                    }
                }
                else {
                    $("#ContentPlaceHolder1_checkedAll").prop("checked", false);
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-12">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">新增管理者帳號</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToListBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="BackToListBtn_Click" OnClientClick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="ti-back-right"></i>返回帳號列表</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    每個新增的管理者可以有不同的權限，請記得設置權限。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="b_AccountsList.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;">管理帳號列表</a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">新增管理者帳號</a>
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
                <h4 class="sub-title">請輸入帳號基本資料 &nbsp<span style="color: red">*必填</span></h4>
                <div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">帳號*</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="account" runat="server" CssClass="form-control" placeholder="請輸入帳號名稱" required=""></asp:TextBox>
                            <asp:Label ID="accountlbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">密碼*</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="password" runat="server" CssClass="form-control" placeholder="密碼至少要五位數喔" TextMode="Password" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">確認密碼*</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="confirmPassword" runat="server" CssClass="form-control" placeholder="請再次輸入密碼" TextMode="Password" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label"></label>
                        <div class="col-sm-5">
                            <input id="showPwd" type="checkbox" onclick="myFunction()">&nbsp 顯示密碼
                            <asp:Label ID="passwordlbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">稱號*</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="username" runat="server" CssClass="form-control" placeholder="請輸入稱號" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">電子郵件*</label>
                        <div class="col-sm-5">
                            <asp:TextBox ID="email" runat="server" CssClass="form-control" placeholder="請輸入Email" TextMode="Email" required=""></asp:TextBox>
                            <asp:Label ID="emaillbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">頭像</label>
                        <div class="col-sm-5 button-wrap">
                            <label class="new-fileUploadBtn" for="ContentPlaceHolder1_avatar">選擇檔案</label>
                            <asp:FileUpload ID="avatar" runat="server" CssClass="form-control" onchange="preview(this)" />
                            <asp:Label ID="avatarlbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                            <div id="picPreview" style="position: absolute; right: -330px; bottom: 50px; text-align: center">頭像預覽</div>
                        </div>
                    </div>
                    <div class="form-group row" style="position: relative">
                        <label class="col-sm-2 col-form-label fontsize-16">權限設置</label>
                        <div style="position: absolute; left: 90px; top: 10px; display: flex">
                            <asp:CheckBox ID="checkedAll" runat="server" />
                            <div style="color: #4099FF; font-weight: bold; font-size: 16px; margin-left: 15px; margin-top: -2px">全選</div>
                        </div>
                        <div class="col-sm-5" style="margin-top: 5px">
                            <div class="d-flex justify-content-between" style="margin-bottom: 10px">
                                <div>
                                    <asp:CheckBox ID="AuthAccounts" runat="server" />
                                    <span class="adjust-text">管理帳號</span>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between" style="margin-bottom: 10px">
                                <div>
                                    <asp:CheckBox ID="AuthYachts" runat="server" />
                                    <span class="adjust-text">管理遊艇型號</span>
                                </div>
                                <div>
                                    <asp:CheckBox ID="AuthDealers" runat="server" />
                                    <span class="adjust-text">管理代理商列表</span>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between" style="margin-bottom: 10px">
                                <div>
                                    <asp:CheckBox ID="AuthNews" runat="server" />
                                    <span class="adjust-text">管理新聞列表</span>
                                </div>
                                <div>
                                    <asp:CheckBox ID="AuthMessages" runat="server" />
                                    <span class="adjust-text">管理留言區列表</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="d-flex justify-content-end">
                    <asp:Button ID="addAccountBtn" runat="server" Text="新增" CssClass="btn btn-round adjust-addbtn" OnClick="addAccountBtn_Click" />
                    <input id="Reset1" type="reset" value="重設" class="btn btn-round adjust-btn fontsize-18" style="margin: 0 10px 0 20px" />
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function myFunction() {
            var x = document.getElementById("ContentPlaceHolder1_password");
            var y = document.getElementById("ContentPlaceHolder1_confirmPassword");
            if (x.type === "password") {
                x.type = "text";
                y.type = "text";
            } else {
                x.type = "password";
                y.type = "password";
            }
        }
    </script>
</asp:Content>