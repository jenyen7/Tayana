<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_AccountsList.aspx.cs" Inherits="Tayana.WebForm33" %>

<%@ Register Src="~/myClasses/PagingControl.ascx" TagPrefix="uc1" TagName="PagingControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .table-hover tbody tr:hover td {
            background-color: #FAFAFA;
        }

        .table > tbody > tr > td {
            vertical-align: middle;
        }

        .movedown {
            margin-bottom: 10px;
        }

        .adjust-btn {
            background-color: #A96EFC;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #BB8BFD;
                color: white;
            }

        .adjust-light-btn {
            background-color: #C49AFD;
        }

            .adjust-light-btn:hover {
                background-color: #D5B8FD;
            }

        .adjust-search-btn {
            background-color: #A5B7BF;
        }

            .adjust-search-btn:hover {
                background-color: #B4C3CA;
            }

        .adjust-littleBtn {
            background-color: #A96EFC;
            color: white;
        }

            .adjust-littleBtn:hover {
                background-color: #BB8BFD;
                color: white;
            }

        .littleBtn2 {
            background-color: #D5B8FD;
            margin-left: 10px;
        }

            .littleBtn2:hover {
                background-color: #DEC7FE;
            }
    </style>
    <link href="./assets/style.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-12">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">管理帳號列表</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToIndexBtn" runat="server" CssClass="btn btn-round adjust-btn adjust-light-btn" OnClick="BackToIndexBtn_Click"><i class="ti-back-right"></i>返回首頁</asp:LinkButton>
                </div>
                <div style="position: absolute; right: 170px; top: 30px">
                    <asp:LinkButton ID="AddAccountBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="AddAccountBtn_Click">新增管理者帳號</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    在此進行編輯或刪除管理者帳號。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">管理帳號列表</a>
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
                <div class="d-flex justify-content-between movedown">
                    <div class="d-flex">
                        <div class="d-flex align-items-center font-weight-bold f-16">
                            依管理者權限搜尋&nbsp&nbsp
                        <div style="width: 300px">
                            <asp:DropDownList ID="permissionDDL" runat="server" CssClass="form-control form-select"></asp:DropDownList>
                        </div>
                        </div>
                        <div class="d-flex" style="margin-left: 25px; height: 38px">
                            <asp:TextBox ID="searchBox" runat="server" CssClass="form-control" TextMode="Search" placeholder="依帳號或稱號搜尋"></asp:TextBox>
                            <asp:LinkButton ID="searchBtn" runat="server" CssClass="input-group-addon adjust-btn adjust-search-btn" OnClick="searchBtn_Click"><i class="icofont icofont-search-alt-2 text-white f-18"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div>
                        <div style="margin-right: 20px">
                            <asp:ImageButton ID="clearSearch" runat="server" Width="35" ImageUrl="./assets/clear-search.png" OnClick="clearSearch_Click" />
                        </div>
                    </div>
                </div>
                <div class="b-t-default"></div>
                <asp:Repeater ID="AccountsRpt" runat="server" OnItemCommand="AccountsRpt_ItemCommand">
                    <HeaderTemplate>
                        <table class="table table-responsive table-hover f-16">
                            <tr style="background-image: linear-gradient(to left, #E1E7E9, #A5B7BF)">
                                <th class="text-center">編號</th>
                                <th class="w-25 text-center">頭像</th>
                                <th style="width: 20%">帳號</th>
                                <th style="width: 20%">稱號</th>
                                <th class="text-center">權限</th>
                                <th style="width: 20%"></th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="text-center align-middle"><%# Eval("rowIndex") %></td>
                            <td class="text-center">
                                <img style="width: 100px; height: 100px; border-radius: 50%" src="/assets/images/<%# Eval("avatar") %>" />
                            </td>
                            <td>
                                <asp:Label ID="account" Text='<%# Eval("account") %>' runat="server" CssClass="pushright" />
                            </td>
                            <td>
                                <asp:Label ID="username" Text='<%# Eval("username") %>' runat="server" />
                            </td>
                            <td class="text-center">
                                <%#(Convert.ToInt16(Eval("permissions"))&1) > 0 ? "<label class='label' style='background-color:#BB8BFD'>帳號管理</label>" : "" %>
                                <%#(Convert.ToInt16(Eval("permissions"))&2) > 0 ? "<label class='label label-primary'>遊艇型號管理</label>" : "" %>
                                <%#(Convert.ToInt16(Eval("permissions"))&4) > 0 ? "<label class='label label-success' >新聞管理</label>" : "" %><br />
                                <%#(Convert.ToInt16(Eval("permissions"))&8) > 0 ? "<label class='label label-warning'>代理商管理</label>" : "" %>
                                <%#(Convert.ToInt16(Eval("permissions"))&16) > 0 ? "<label class='label label-danger'>留言區管理</label>" : "" %>
                            </td>
                            <td class="text-center">
                                <div class="d-flex" role="group">
                                    <asp:LinkButton ID="editBtn" runat="server" CommandName="Edit" ToolTip="編輯" CommandArgument='<%#Eval("id") %>' CssClass="btn btn-round adjust-littleBtn"><i class="ti-pencil-alt"></i>編輯</asp:LinkButton>
                                    <asp:LinkButton ID="deleteBtn" runat="server" CommandName="Delete" ToolTip="刪除" CommandArgument='<%#Eval("id") %>' CssClass="btn btn-round adjust-littleBtn littleBtn2" OnClientClick="javascript:if(!window.confirm('你確定要刪除嗎?')) window.event.returnValue = false;"><i class="ti-trash"></i>刪除</asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <div style="font-size: 16px; font-weight: bold; margin: 70px auto; text-align: center">
                    <asp:Label ID="noSearchingResultlbl" Text="無搜尋結果" runat="server" Visible="false" />
                </div>
                <div class="d-flex justify-content-end">
                    <uc1:PagingControl runat="server" ID="PagingControl" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>