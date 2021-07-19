<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_YachtsGalleryPage.aspx.cs" Inherits="Tayana.WebForm29" %>

<%@ Register Src="~/myClasses/PagingControl.ascx" TagPrefix="uc1" TagName="PagingControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .switch {
            position: relative;
            display: inline-block;
            width: 38px;
            height: 20px;
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
            border: 2px solid white;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 20px;
                left: -3px;
                bottom: -2px;
                background-color: white;
                -webkit-transition: .5s;
                transition: .5s;
            }

            .slider.round {
                border-radius: 34px;
            }

                .slider.round:before {
                    border-radius: 50%;
                }

        input:checked + .slider {
            background-color: #3A6EFF;
        }

        input:focus + .slider {
            box-shadow: 0 0 1px #2196F3;
        }

        input:checked + .slider:before {
            -webkit-transform: translateX(20px);
            -ms-transform: translateX(20px);
            transform: translateX(20px);
        }

        .adjust-btn {
            margin-left: 10px;
        }

        .adjust-width {
            width: 20% !important;
        }

        .littleheader {
            padding: 15px;
            border-radius: 5px;
            background-image: linear-gradient(to right, #57AAE1, #B4C3FA);
            position: relative;
            margin: 15px 12px 20px 15px;
        }

        .grid-style {
            font-size: 16px;
            border-color: #E1E7E9;
            border-style: none;
            width: 100%;
            margin-top: 20px;
        }

        .table-hover tbody tr:hover td {
            background-color: #FAFAFA;
        }

        .new-button {
            position: absolute;
            display: inline-block;
            padding: 8px 11px;
            cursor: pointer;
            border-radius: 3px;
            background-color: #A5D1EF;
            font-size: 16px;
            font-weight: bold;
            color: #fff;
        }

        .button-wrap {
            position: relative;
        }

        input[type=checkbox] {
            cursor: pointer;
            visibility: hidden;
        }

            input[type=checkbox]:after {
                content: " ";
                display: inline-block;
                margin-left: 10px;
                color: #4099FF;
                width: 20px;
                height: 20px;
                border: 1px solid #4099FF;
                padding-bottom: 8px;
                padding-left: 3px;
                border-radius: 3px;
                visibility: visible;
                /*#00BFF0*/
            }

            input[type=checkbox]:checked:after {
                content: "✓";
                font-weight: bold;
            }

        .scrollToTopStyle {
            position: fixed;
            right: 0;
            bottom: 50px;
            z-index: 1;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script>
        $(document).ready(function () {
            $(".theme-loader").remove();
            $('.scrollToTopStyle').on('click', function (e) {
                e.preventDefault()
                $("html, body").animate({ scrollTop: 0 }, 1000);
            });
        });
    </script>
    <link href="./assets/style.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <a href="#" role="button" class="scrollToTopStyle">
        <img src="assets/top-arrow.jpg" height="50" width="50" alt="top" /></a>

    <div class="page-header card">
        <div class="card-block" style="position: relative">
            <h4 class="mb-10" style="color: #546D77">管理遊艇相簿</h4>
            <div style="position: absolute; right: 30px; top: 30px">
                <asp:LinkButton ID="BackToList" runat="server" CssClass="btn btn-primary btn-round f-16 font-weight-bold" OnClick="BackToList_Click" OnClientClick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料如果尚未儲存將會遺失，確定要離開嗎?')) window.event.returnValue = false;"><i class="ti-back-right"></i>返回遊艇列表</asp:LinkButton>
            </div>
            <p class="text-muted f-16">
                請至少提供兩張照片，作為前台遊艇介紹時上方的照片輪播。
            </p>
            <ul class="breadcrumb-title b-t-default p-t-10">
                <li class="breadcrumb-item">
                    <a href="back_Index.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="fa fa-home"></i></a>
                </li>
                <li class="breadcrumb-item"><a href="b_YachtsList.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;">管理遊艇列表</a>
                </li>
                <li class="breadcrumb-item"><a href="#!">管理遊艇相簿</a>
                </li>
            </ul>
            <asp:Label ID="warning" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
        </div>
    </div>

    <div class="card">
        <div class="card-block tab-icon">
            <div class="row">
                <div class="col-lg-12">
                    <div class="littleheader">
                        <div class="fontsize-18 font-weight-bold text-white" style="margin-bottom: 10px; letter-spacing: 2px">遊艇型號 :</div>
                        <asp:TextBox ID="name" runat="server" CssClass="form-control col-sm-3 fontsize-16" ReadOnly="true" />
                        <div style="position: absolute; top: 65px; right: 30px;">
                            <label class="switch">
                                <asp:CheckBox ID="checkbox" runat="server" onclick="return false;" />
                                <span class="slider round"></span>
                            </label>
                            <span style="color: white; font-size: 18px; padding-left: 10px; font-weight: bold;">標註為最新船型</span>
                        </div>
                    </div>

                    <div class="container">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs md-tabs" id="tab-next-prev" role="tablist">
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16" id="tab1-tab" href="b_YachtEditPage.aspx?id=<%=Convert.ToInt32(Request.QueryString["id"]) %>"><i class="ti-agenda"></i>1.遊艇總覽Overview</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16" id="tab2-tab" href="b_YachtEditPage.aspx?id=<%=Convert.ToInt32(Request.QueryString["id"]) %>&tab=tab2"><i class="ti-ruler-alt-2"></i>2.遊艇結構Layout</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16" id="tab3-tab" href="b_YachtEditPage.aspx?id=<%=Convert.ToInt32(Request.QueryString["id"])%>&tab=tab3"><i class="icofont icofont-ui-settings"></i>3.遊艇規格Specification</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link active f-16" id="tab4-tab" href="#"><i class="ti-gallery"></i>4.上傳照片(照片輪播)</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16" id="tab5-tab" href="b_YachtsFilesPage.aspx?id=<%=Convert.ToInt32(Request.QueryString["id"]) %>"><i class="ti-files"></i>5.上傳PDF檔案</a>
                                <div class="slide adjust-width"></div>
                            </li>
                        </ul>
                        <!-- Tab panes -->
                        <div class="tab-content" id="tab-next-prev-content">
                            <div class="card-block">
                                <h5 class="sub-title fontsize-16">請上傳此遊艇型號的內外觀照片</h5>
                                <div class="row">
                                    <div class="col button-wrap">
                                        <label class="new-button" for="ContentPlaceHolder1_ImageUpload">選擇檔案</label>
                                        <asp:FileUpload ID="ImageUpload" runat="server" CssClass="form-control" required="" />
                                    </div>
                                    <div class="col">
                                        <asp:TextBox ID="ImageAlt" runat="server" CssClass="form-control h-100" placeholder="請輸入照片名稱" required=""></asp:TextBox>
                                    </div>
                                    <div class="col">
                                        <asp:Button ID="AddImageBtn" runat="server" CssClass="btn btn-primary font-weight-bold" Text="新增照片" OnClick="AddImageBtn_Click" />
                                    </div>
                                </div>
                                <asp:Label ID="Imagelbl" runat="server"></asp:Label><br />
                                <asp:GridView ID="ImagesGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="id" GridLines="Horizontal" CssClass="grid-style table table-hover" CellPadding="5" ShowHeaderWhenEmpty="True" HeaderStyle-BackColor="#E1E7E9" HeaderStyle-HorizontalAlign="Center">
                                    <Columns>
                                        <asp:TemplateField HeaderStyle-Width="70px">
                                            <%--   <HeaderTemplate>
                                                    <asp:CheckBox ID="chkAll" runat="server" AutoPostBack="true" OnCheckedChanged="OnCheckedChanged" />
                                                </HeaderTemplate>--%>
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="check" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="編號" HeaderStyle-Width="70px">
                                            <ItemTemplate>
                                                <%#Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="照片" HeaderStyle-Width="200px">
                                            <ItemTemplate>
                                                <img src='assets_tayana/upload/Images/<%# Eval("imageName") %>' alt='<%# Eval("imageAlt") %>' width="140" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="imageName" HeaderText="檔案名稱" HeaderStyle-Width="300px" />
                                        <asp:TemplateField HeaderText="照片名稱" HeaderStyle-Width="350px">
                                            <ItemTemplate>
                                                <%--<asp:Label ID="imageAlt" runat="server" Text='<%# Eval("imageAlt") %>'></asp:Label>--%>
                                                <asp:TextBox ID="imageAltBox" runat="server" Text='<%# Bind("imageAlt") %>' CssClass="form-control form-control-primary fontsize-16"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="照片輪播順序" SortExpression="imageOrder">
                                            <ItemTemplate>
                                                <%--<asp:Label ID="imageOrder" runat="server" Text='<%# Bind("imageOrder") %>'></asp:Label>--%>
                                                <asp:TextBox ID="imageOrderBox" runat="server" Text='<%# Bind("imageOrder") %>' CssClass="form-control form-control-primary fontsize-16"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <%-- <asp:TemplateField HeaderStyle-Width="100px">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="deleteBtn" runat="server" CommandName="Delete" ToolTip="刪除" OnClientClick="javascript:if(!window.confirm('你確定要刪除嗎?')) window.event.returnValue = false;" CssClass="btn"><i class="ti-trash text-blue f-24"></i></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>--%>
                                    </Columns>
                                </asp:GridView>
                                <%--<div class="d-flex justify-content-center">
                                    <uc1:PagingControl runat="server" ID="PagingControl" />
                                </div>--%>
                                <div class="d-flex justify-content-end" style="margin-right: 10px">
                                    <asp:LinkButton ID="deleteBtn" CssClass="btn btn-danger btn-round fontsize-18" runat="server" OnClick="deleteBtn_Click" OnClientClick="javascript:if(!window.confirm('你確定要刪除嗎?')) window.event.returnValue = false;">刪除</asp:LinkButton>
                                    <asp:LinkButton ID="updateBtn" CssClass="btn btn-primary btn-round adjust-btn fontsize-18" runat="server" OnClick="updateBtn_Click">儲存</asp:LinkButton>
                                </div>
                                <span class="f-16 font-weight-bold">備註:</span><br />
                                1. 檔案名稱是圖片本身的檔案名稱。<br />
                                2. 照片名稱是當前台照片抓不到路徑時所顯示的文字。<br />
                                3. 照片輪播順位第一張的照片將會顯示於前台首頁。<br />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>