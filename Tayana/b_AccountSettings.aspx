<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_AccountSettings.aspx.cs" Inherits="Tayana.WebForm35" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-9">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">帳號設定</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToIndexBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="BackToIndexBtn_Click" OnClientClick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料如果尚未儲存將會遺失，確定要離開嗎?')) window.event.returnValue = false;">返回首頁</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    在此修改密碼，如果有更動，下次登入時請輸入新密碼。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料如果尚未儲存將會遺失，確定要離開嗎?')) window.event.returnValue = false;"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">帳號設定</a>
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
                <h4 class="sub-title">修改密碼</h4>
                <div style="margin-bottom: 150px">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">帳號</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="account" runat="server" CssClass="form-control" placeholder="請輸入帳號名稱" ReadOnly="true"></asp:TextBox>
                            <asp:Label ID="accountlbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">密碼</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="password" runat="server" CssClass="form-control" placeholder="密碼至少要五位數喔" TextMode="Password" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label fontsize-16">確認密碼</label>
                        <div class="col-sm-6">
                            <asp:TextBox ID="confirmPassword" runat="server" CssClass="form-control" placeholder="請再次輸入密碼" TextMode="Password" required=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label"></label>
                        <div class="col-sm-6">
                            <input type="checkbox" onclick="myFunction()">&nbsp 顯示密碼<br />
                            <asp:Label ID="passwordlbl" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
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