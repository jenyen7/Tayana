<%@ Page Title="" Language="C#" MasterPageFile="~/BackEnd/backLayout.Master" AutoEventWireup="true" CodeBehind="b_Messages.aspx.cs" Inherits="Tayana.WebForm8" %>

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

        .adjust-search-btn {
            background-color: #F08F85;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-search-btn:hover {
                background-color: #F29F97;
                /*color: white;*/
            }
    </style>
    <link href="../assets/style.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-12">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">訪客留言區</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToIndexBtn" runat="server" CssClass="btn btn-round btn-danger adjust-search-btn" OnClick="BackToIndexBtn_Click"><i class="ti-back-right"></i>返回首頁</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    紀錄訪客詢問的遊艇型號目錄。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">訪客留言區</a>
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
                <div class="d-flex justify-content-between font-weight-bold f-16 movedown" style="padding: 0 10px">
                    <div class="d-flex align-items-center">
                        依遊艇型號篩選&nbsp&nbsp
                        <div style="width: 200px">
                            <asp:DropDownList ID="yachtsDDL" runat="server" CssClass="form-control h-100 form-select" AutoPostBack="true" OnSelectedIndexChanged="yachtsDDL_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                    <div style="margin-right: 10px">
                        <asp:ImageButton ID="clearSearch" runat="server" Width="35" ImageUrl="../assets/clear-search.png" OnClick="clearSearch_Click" />
                    </div>
                </div>
                <div class="b-t-default"></div>
                <asp:Repeater ID="MessagesRpt" runat="server">
                    <HeaderTemplate>
                        <table class="table table-responsive table-hover f-16">
                            <tr style="color: white; background-image: linear-gradient(to right, #B014FF, #FF8124); opacity: 0.5">
                                <th class="text-center">編號</th>
                                <th style="width: 20%">訪客名稱</th>
                                <th>國家</th>
                                <th style="width: 28%">聯繫方式</th>
                                <th style="width: 20%">詢問的目錄</th>
                                <th>通知日期</th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="text-center"><%# Container.ItemIndex+1 %></td>
                            <td><%# Eval("name") %></td>
                            <td><%# Eval("country") %></td>
                            <td>
                                <div>電話: &nbsp<%# Eval("phone") %></div>
                                <div>Email: &nbsp<%# Eval("email") %></div>
                            </td>
                            <td>
                                <div>
                                    <label class='label label-danger' style='font-weight: bold; font-size: 14px'><%# Eval("brochure") %></label>
                                </div>
                                <div><%# Eval("comments") %></div>
                            </td>
                            <td>
                                <%# Eval("sentDate") %>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <div class="d-flex justify-content-end">
                </div>
            </div>
        </div>
    </div>
</asp:Content>