<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_DealersList.aspx.cs" Inherits="Tayana.WebForm5" %>

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
            background-color: #F8E073;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }

            .adjust-btn:hover {
                background-color: #F9E596;
                color: white;
            }

        .adjust-search-btn {
            background-color: #A5B7BF;
        }

            .adjust-search-btn:hover {
                background-color: #B4C3CA;
            }

        .adjust-deleteBtn {
            background-color: #F8E073;
            color: white;
            margin-left: 10px;
        }

            .adjust-deleteBtn:hover {
                background-color: #F9E596;
                color: white;
            }

        .adjust-infoBtn {
            background-color: #DAC4C1;
            font-weight: bold;
            border-radius: 5px;
            color: white;
        }

            .adjust-infoBtn:hover {
                background-color: #E3D3D0;
                color: white;
            }
    </style>
    <script type="text/javascript">
        function openModal() { $('#myModal').modal('show'); }
    </script>
    <link href="./assets/style.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-12">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">管理代理商列表</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <asp:LinkButton ID="BackToIndexBtn" runat="server" CssClass="btn btn-round adjust-btn" OnClick="BackToIndexBtn_Click"><i class="ti-back-right"></i>返回首頁</asp:LinkButton>
                </div>
                <div style="position: absolute; right: 170px; top: 30px">
                    <asp:Button ID="AddDealerBtn" runat="server" CssClass="btn btn-round btn-warning font-weight-bold" Text="新增代理商" OnClick="AddDealerBtn_Click" />
                </div>
                <div style="position: absolute; right: 300px; top: 30px"><a href="b_CitiesEditing.aspx" class="btn btn-round adjust-btn">管理城市</a></div>
                <p class="text-muted f-16">
                    在此進行編輯或刪除代理商，如果要新增的代理商城市尚未創建，請先新增城市名稱。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">管理代理商列表</a>
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
                        <div class="d-flex align-items-center font-weight-bold fontsize-16">
                            依地區搜尋&nbsp
                        <div style="width: 205px">
                            <asp:DropDownList ID="searchByCountry" runat="server" CssClass="form-control form-select" OnSelectedIndexChanged="searchByCountry_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </div>
                            <div style="width: 205px">
                                <asp:DropDownList ID="searchByCity" runat="server" CssClass="form-control form-select"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="d-flex" style="margin-left: 25px; height: 38px">
                            <asp:TextBox ID="searchBox" runat="server" CssClass="form-control" TextMode="Search" placeholder="依代理商或聯絡人名稱搜尋"></asp:TextBox>
                            <asp:LinkButton ID="searchBtn" runat="server" CssClass="input-group-addon adjust-btn adjust-search-btn" OnClick="searchBtn_Click"><i class="icofont icofont-search-alt-2 text-white f-18"></i></asp:LinkButton>
                        </div>
                    </div>
                    <div style="margin-right: 20px">
                        <asp:ImageButton ID="clearSearch" runat="server" Width="35" ImageUrl="./assets/clear-search.png" OnClick="clearSearch_Click" />
                    </div>
                </div>
                <div class="b-t-default"></div>
                <asp:Repeater ID="Dealers" runat="server" OnItemCommand="Dealers_ItemCommand" OnItemDataBound="Dealers_ItemDataBound">
                    <HeaderTemplate>
                        <table class="table table-responsive table-hover f-16">
                            <tr style="background-image: linear-gradient(to left, #E1E7E9, #A5B7BF)">
                                <th class="text-center">編號</th>
                                <th class="w-25 text-center">封面圖片</th>
                                <th class="w-25">地區</th>
                                <th class="w-25">聯絡人</th>
                                <th class="text-center">聯絡資訊</th>
                                <th style="width: 20%"></th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="text-center align-middle"><%# Eval("rowIndex") %></td>
                            <td class="text-center">
                                <img style="width: 190px; height: 150px; border-radius: 3px" src="/assets_tayana/upload/Images/<%# Eval("dealerPic") %>" />
                            </td>
                            <td>
                                <asp:Label ID="country" Text='<%# Eval("country") %>' runat="server" CssClass="pushright" /><br />
                                <asp:Label ID="city" Text='<%# Eval("city") %>' runat="server" CssClass="pushright" ForeColor="rosybrown" /><br />
                            </td>
                            <td>
                                <asp:Label ID="dealerName" Text='<%# Eval("dealerName") %>' runat="server" /><br />
                                <asp:Label ID="contact" Text='<%# Eval("dealerContact") %>' runat="server" ForeColor="Gray" />
                            </td>
                            <td class="text-center" id="loc">
                                <asp:Button ID="GetInfo" CommandName="GetInfo" CommandArgument='<%#Eval("id") %>' runat="server" Text="詳細資訊" CssClass="btn adjust-infoBtn" data-toggle="modal" data-target="#exampleModal" />
                            </td>
                            <td class="text-center">
                                <div class="">
                                    <asp:LinkButton ID="editBtn" runat="server" CommandName="Edit" ToolTip="編輯" CssClass="btn btn-round btn-warning" CommandArgument='<%#Eval("id") %>'><i class="ti-pencil-alt text-white"></i>編輯</asp:LinkButton>
                                    <asp:LinkButton ID="deleteBtn" runat="server" CommandName="Delete" ToolTip="刪除" CommandArgument='<%#Eval("id") %>' OnClientClick="javascript:if(!window.confirm('你確定要刪除嗎?')) window.event.returnValue = false;" CssClass="btn btn-round adjust-deleteBtn "><i class="ti-trash text-white"></i>刪除</asp:LinkButton>
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
    <%--Modal移出來--%>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top: 250px; border-radius: 5px">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header text-white" style="background-image: linear-gradient(to bottom right, #FFDB91, #DAC4C1);">
                    <h5 class="modal-title" id="exampleModalLabel">詳細資訊</h5>
                </div>
                <div style="text-align: left; padding: 20px; font-size: 16px; word-wrap: break-word;">
                    <img src="./assets/phone.png" alt="phone" width="24" />
                    <asp:Label ID="Tel" runat="server"></asp:Label><br />
                    <img src="./assets/fax.png" alt="fax" width="24" />
                    <asp:Label ID="Fax" runat="server"></asp:Label><br />
                    <span style="background-color: rgb(164,140,107); border-radius: 50%; padding: 3px 5px"><i class="ti-email text-white f-14"></i></span>
                    <asp:Label ID="Email" runat="server"></asp:Label><br />
                    <span style="background-color: rgba(191,129,85,0.9); border-radius: 50%; padding: 3px 5px"><i class="ti-location-pin text-white f-14"></i></span>
                    <asp:Label ID="Address" runat="server"></asp:Label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">關閉</button>
                </div>
            </div>
        </div>
    </div>
    <%--Modal結束--%>
</asp:Content>