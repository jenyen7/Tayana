<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="back-Login.aspx.cs" Inherits="Tayana.ba_Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>管理者登入</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
    <!-- Favicon icon -->
    <link rel="shortcut icon" href="favicon.ico" />
    <%--<link rel="icon" href="assets/images/favicon.ico" type="image/x-icon">--%>
    <!-- Required Fremwork -->
    <link rel="stylesheet" type="text/css" href="assets/css/bootstrap/css/bootstrap.min.css">
    <!-- themify-icons line icon -->
    <link rel="stylesheet" type="text/css" href="assets/icon/themify-icons/themify-icons.css">
    <!-- ico font -->
    <link rel="stylesheet" type="text/css" href="assets/icon/icofont/css/icofont.css">
    <!-- Style.css -->
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
</head>
<body>
    <form id="form1" runat="server">
        <div class="fix-menu">
            <!-- Pre-loader start -->
            <div class="theme-loader">
                <div class="loader-track">
                    <div class="loader-bar"></div>
                </div>
            </div>
            <!-- Pre-loader end -->
            <section class="login p-fixed d-flex text-center bg-primary common-img-bg" style="background-image: linear-gradient(to bottom right, #090979, #00d4ff);">
                <!-- Container-fluid starts -->
                <div class="container">
                    <div class="row">
                        <div class="col-sm-12">
                            <!-- Authentication card start -->
                            <div class="login-card card-block auth-body mr-auto ml-auto" style="margin-top: -70px">
                                <div class="md-float-material">
                                    <div class="auth-box">
                                        <div class="row m-b-20">
                                            <div class="col-md-12">
                                                <h3 class="text-left txt-primary">管理者登入</h3>
                                            </div>
                                        </div>
                                        <hr />
                                        <div class="input-group">
                                            <asp:TextBox ID="accountID" runat="server" placeholder="請輸入帳號" CssClass="form-control"></asp:TextBox>
                                            <span class="md-line"></span>
                                        </div>
                                        <div class="input-group">
                                            <asp:TextBox ID="password" runat="server" placeholder="請輸入密碼" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                            <span class="md-line"></span>
                                        </div>
                                        <div class="row m-t-25 text-left">
                                            <div class="col-sm-7 col-xs-12">
                                                <div class="checkbox-fade fade-in-primary">
                                                    <label>
                                                        <asp:CheckBox ID="rememberMe" runat="server" />
                                                        <span class="cr"><i class="cr-icon icofont icofont-ui-check txt-primary"></i></span>
                                                        <span class="text-inverse">記住我</span>
                                                    </label>
                                                </div>
                                            </div>
                                            <%--<div class="col-sm-5 col-xs-12 forgot-phone text-right">
                                                <a href="back_ForgotPassword.aspx" class="text-right f-w-600">忘記密碼?</a>
                                            </div>--%>
                                        </div>
                                        <div class="row m-t-30">
                                            <div class="col-md-12">
                                                <asp:Button ID="loginBtn" runat="server" Text="登入" OnClick="loginBtn_Click" CssClass="btn btn-grd-primary btn-md btn-block waves-effect text-center m-b-20 font-weight-bold" />
                                            </div>
                                        </div>
                                        <asp:Label ID="messagelbl" runat="server" ForeColor="Red"></asp:Label>
                                        <hr />
                                        <div class="row">
                                            <div class="col-md-10">
                                                <p class="text-inverse text-left m-b-0">謝謝使用本站。</p>
                                                <p class="text-inverse text-left"><b>Jen</b></p>
                                            </div>
                                            <div class="col-md-2">
                                                <%--<img src="assets/images/auth/Logo-small-bottom.png" alt="small-logo.png">--%>
                                                <img src="assets_tayana/images/icon008.gif" alt="small-logo.png" width="30" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- end of form -->
                            </div>
                            <!-- Authentication card end -->
                        </div>
                        <!-- end of col-sm-12 -->
                    </div>
                    <!-- end of row -->
                </div>
                <!-- end of container-fluid -->
            </section>

            <!-- Required Jquery -->
            <script type="text/javascript" src="assets/js/jquery/jquery.min.js"></script>
            <script type="text/javascript" src="assets/js/jquery-ui/jquery-ui.min.js"></script>
            <script type="text/javascript" src="assets/js/popper.js/popper.min.js"></script>
            <script type="text/javascript" src="assets/js/bootstrap/js/bootstrap.min.js"></script>
            <!-- jquery slimscroll js -->
            <script type="text/javascript" src="assets/js/jquery-slimscroll/jquery.slimscroll.js"></script>
            <!-- modernizr js -->
            <script type="text/javascript" src="assets/js/modernizr/modernizr.js"></script>
            <script type="text/javascript" src="assets/js/modernizr/css-scrollbars.js"></script>
            <script type="text/javascript" src="assets/js/common-pages.js"></script>
        </div>
    </form>
</body>
</html>