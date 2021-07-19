<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_YachtsList.aspx.cs" Inherits="Tayana.WebForm20" %>

<%@ Register Src="~/myClasses/PagingControl.ascx" TagPrefix="uc1" TagName="PagingControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .table-hover tbody tr:hover td {
            background-color: #FAFAFA;
        }

        .table > tbody > tr > td {
            vertical-align: middle;
        }

        .table > tbody > tr > th {
            text-align: center;
        }

        .movedown {
            margin-bottom: 10px;
        }

        .adjust-btn {
            background-color: #7CCCFC;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #9AD7FD;
                color: white;
            }

        .adjust-deleteBtn {
            background-color: #9AD7FD;
            color: white;
            margin-left: 10px;
        }

            .adjust-deleteBtn:hover {
                background-color: #B8E3FD;
                color: white;
            }

        input[type="date"]::-webkit-inner-spin-button {
            opacity: 0
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            background: url(./assets/calendar-icon-blue.jpg) center/150% no-repeat;
            /*color: rgba(0, 0, 0, 0);*/
            opacity: 0.6
        }

            input[type="date"]::-webkit-calendar-picker-indicator:hover {
                opacity: 1.0
            }
    </style>
    <link href="./assets/style.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-12">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">管理遊艇列表</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToIndexBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="BackToIndexBtn_Click"><i class="ti-back-right"></i>返回首頁</asp:LinkButton>
                </div>
                <div style="position: absolute; right: 170px; top: 30px">
                    <asp:Button ID="AddNewYachtBtn" runat="server" CssClass="btn btn-round btn-primary font-weight-bold" Text="新增遊艇型號" OnClick="AddNewYachtBtn_Click1" />
                </div>
                <p class="text-muted f-16">
                    在此進行編輯或刪除遊艇型號。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">管理遊艇列表</a>
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
                        <div class="d-flex f-16 font-weight-bold align-items-center">
                            依日期搜尋&nbsp
                        <div style="width: 200px">
                            <asp:TextBox ID="searchDateStart" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                            &nbsp 到&nbsp
                        <div style="width: 200px">
                            <asp:TextBox ID="searchDateEnd" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                        </div>
                        <div class="d-flex" style="margin-left: 25px; height: 39px">
                            <asp:TextBox ID="searchBox" runat="server" CssClass="form-control" placeholder="依遊艇型號搜尋"></asp:TextBox>
                            <asp:LinkButton ID="searchBtn" runat="server" CssClass="input-group-addon" OnClick="searchBtn_Click"><i class="icofont icofont-search-alt-2 text-white f-18"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div style="margin-right: 20px">
                        <asp:ImageButton ID="ImageButton1" runat="server" Width="35" ImageUrl="./assets/clear-search.png" OnClick="clearSearch_Click" />
                    </div>
                </div>
                <div class="b-t-default"></div>
                <asp:Repeater ID="Yachts" runat="server" OnItemCommand="Yachts_ItemCommand">
                    <HeaderTemplate>
                        <table class="table table-responsive table-hover f-16 w-100">
                            <tr style="background-image: linear-gradient(to left, #E1E7E9, #A5B7BF)">
                                <th>編號</th>
                                <th class="w-50">遊艇型號</th>
                                <th class="w-50">新增日期</th>
                                <th></th>
                                <th style="width: 20%"></th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="text-center"><%# Eval("rowIndex") %></td>
                            <td style="padding-left: 100px">
                                <%# Eval("yachtName") %>
                                <%#Eval("newest").ToString() == "1" ? "<label class='label label-primary' style='font-weight:bold;font-size:14px'>最新</label>" : "" %>
                            </td>
                            <td class="text-center">
                                <%# Eval("publishedDate","{0: yyyy/MM/dd hh:mm}") %>
                            </td>
                            <td class="text-center">
                                <asp:LinkButton ID="editLink" runat="server" CommandName="Edit" CommandArgument='<%#Eval("id") %>' CssClass="btn btn-round btn-primary"><i class="ti-pencil-alt text-white"></i>編輯</asp:LinkButton>
                                <asp:LinkButton ID="deleteBtn" runat="server" CommandName="Delete" CommandArgument='<%#Eval("id") %>' CssClass="btn btn-round adjust-deleteBtn" OnClientClick="javascript:if(!window.confirm('你確定要刪除嗎?')) window.event.returnValue = false;"><i class="ti-trash text-white"></i>刪除</asp:LinkButton>
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