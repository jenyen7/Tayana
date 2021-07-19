<%@ Page Title="" Language="C#" MasterPageFile="~/BackEnd/backLayout.Master" AutoEventWireup="true" CodeBehind="b_NewsList.aspx.cs" Inherits="Tayana.WebForm3" %>

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
            background-color: #74ECD4;
            /*background-color: #7EE2AB;*/
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #81EED8;
                /*background-color: #8FE6B4;*/
                color: white;
            }

        .adjust-search-btn {
            background-color: #A5B7BF;
        }

            .adjust-search-btn:hover {
                background-color: #B4C3CA;
            }

        .adjust-deleteBtn {
            background-color: #74ECD4;
            color: white;
            margin-left: 10px;
        }

            .adjust-deleteBtn:hover {
                background-color: #81EED8;
                color: white;
            }

        .pushright {
            margin-left: 30px;
        }

        input[type="date"]::-webkit-inner-spin-button {
            opacity: 0
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            background: url(../assets/calendar-icon-blue.jpg) center/150% no-repeat;
            opacity: 0.6
        }

            input[type="date"]::-webkit-calendar-picker-indicator:hover {
                opacity: 1.0
            }
    </style>
    <link href="../assets/style.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-12">
        <div class="page-header card">
            <div class="card-block">
                <h4 class="mb-10" style="color: #546D77">管理新聞列表</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToIndexBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="BackToIndexBtn_Click"><i class="ti-back-right"></i>返回首頁</asp:LinkButton>
                </div>
                <div style="position: absolute; right: 170px; top: 30px">
                    <asp:LinkButton ID="AddNewstBtn" runat="server" CssClass="btn btn-round btn-success font-weight-bold" OnClick="AddNewstBtn_Click">新增發佈</asp:LinkButton>
                </div>
                <p class="text-muted f-16">
                    在此進行編輯或刪除新聞。<span style="color: darkcyan; font-weight: bold">&nbsp&nbsp **新聞置頂上限為3個，將顯示於首頁下方</span>
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">管理新聞列表</a>
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
                            <asp:TextBox ID="searchBox" runat="server" CssClass="form-control" TextMode="Search" placeholder="依新聞標題搜尋"></asp:TextBox>
                            <asp:LinkButton ID="searchBtn" runat="server" CssClass="input-group-addon adjust-btn adjust-search-btn" OnClick="searchBtn_Click"><i class="icofont icofont-search-alt-2 text-white f-18"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div style="margin-right: 20px">
                        <asp:ImageButton ID="clearSearch" runat="server" Width="35" ImageUrl="./../assets/clear-search.png" OnClick="clearSearch_Click" />
                    </div>
                </div>
                <div class="b-t-default"></div>
                <asp:Repeater ID="News" runat="server" OnItemCommand="News_ItemCommand" OnItemDataBound="News_ItemDataBound">
                    <HeaderTemplate>
                        <table class="table table-responsive table-hover f-16">
                            <tr style="background-image: linear-gradient(to left, #E1E7E9, #A5B7BF)">
                                <th>編號</th>
                                <th class="w-25">封面圖片</th>
                                <th style="width: 35%">新聞標題</th>
                                <th>發佈日期</th>
                                <th style="width: 20%"></th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="text-center align-middle"><%# Eval("rowIndex") %></td>
                            <td class="text-center" style="position: relative">
                                <img style="width: 190px; height: 150px; border-radius: 3px" src="/assets_tayana/upload/Images/<%# Eval("newsCoverPic") %>" />
                                <%#Eval("pinned").ToString() == "1" ? "<img src='/../assets/pin.png' style='position:absolute; bottom:10px; right:20px; width:30px;'><br />" : "" %>
                            </td>
                            <td>
                                <div class="pushright">
                                    <asp:Label ID="newsTitle" Text='<%# Eval("newsTitle") %>' runat="server" CssClass="pushright" /><br />
                                    <asp:Label ID="newsSubs" Text='<%# Eval("newsSubs") %>' runat="server" CssClass="pushright" ForeColor="darkcyan" />
                                </div>
                            </td>
                            <td class="text-center"><%# Eval("postDate") %>
                            </td>
                            <td class="text-center">
                                <div role="group">
                                    <asp:LinkButton ID="editBtn" runat="server" CommandName="Edit" ToolTip="編輯" CssClass="btn btn-round btn-success" CommandArgument='<%#Eval("id") %>'><i class="ti-pencil-alt"></i>編輯</asp:LinkButton>
                                    <asp:LinkButton ID="deleteBtn" runat="server" CommandName="Delete" ToolTip="刪除" CommandArgument='<%#Eval("id") %>' OnClientClick="javascript:if(!window.confirm('你確定要刪除嗎?')) window.event.returnValue = false;" CssClass="btn btn-round adjust-deleteBtn"><i class="ti-trash"></i>刪除</asp:LinkButton>
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