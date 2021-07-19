<%@ Page Title="" Language="C#" MasterPageFile="~/BackEnd/backLayout.Master" AutoEventWireup="true" CodeBehind="b_CountriesEditing.aspx.cs" Inherits="Tayana.WebForm6" %>

<%@ Register Src="~/myClasses/PagingControl.ascx" TagPrefix="uc1" TagName="PagingControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .grid-style {
            font-size: 16px;
            border-color: #E1E7E9;
            border-style: none;
            width: 100%;
            margin-top: 20px;
            /*border-color: #F1F1F1;*/
        }

        .table-hover tbody tr:hover td {
            background-color: #FAFAFA;
        }

        .drawcloser {
            margin-bottom: -5px;
        }

        .drawcloser2 {
            position: absolute;
            right: 30px;
            top: 30px;
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

        .adjust-addBtn {
            background-color: #DAC4C1;
        }

            .adjust-addBtn:hover {
                background-color: #E3D3D0;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-sm-10">
        <div class="page-header card">
            <div class="card-block" style="position: relative">
                <h4 class="mb-10" style="color: #546D77">管理國家列表</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <a href="b_CitiesEditing.aspx" class="btn btn-round adjust-btn"><i class="ti-back-right"></i>返回城市列表</a>
                </div>
                <p class="text-muted f-16">
                    在此進行編輯或刪除國家名稱。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="b_DealersList.aspx">管理代理商列表</a>
                    </li>
                    <li class="breadcrumb-item"><a href="b_CitiesEditing.aspx">管理城市列表</a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">管理國家列表</a>
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
                <div class="drawcloser2 f-18">
                    <asp:Label runat="server" ID="SuccessMsg" ForeColor="Green"></asp:Label>
                    <asp:Label runat="server" ID="ErrorMsg" ForeColor="Red" />
                </div>
                <div class="input-group col-sm-5 drawcloser">
                    <asp:TextBox ID="countryInsertBox" runat="server" CssClass="form-control form-control-lg" placeholder="請填寫要新增的國家名稱" required=""></asp:TextBox>
                    <asp:Button ID="insert_btn" runat="server" Text="新增" CssClass="btn adjust-btn adjust-addBtn" OnClick="insert_btn_Click" />
                </div>
                <div class="table-responsive">
                    <asp:GridView ID="countries" runat="server" AutoGenerateColumns="False" DataKeyNames="countryID" GridLines="Horizontal" CssClass="grid-style table table-hover" CellPadding="5" ShowHeaderWhenEmpty="True" HeaderStyle-BackColor="#E1E7E9"
                        OnRowEditing="countries_RowEditing" OnRowCancelingEdit="countries_RowCancelingEdit" OnRowUpdating="countries_RowUpdating" OnRowDeleting="countries_RowDeleting">
                        <Columns>
                            <asp:TemplateField HeaderText="編號" HeaderStyle-Width="150px">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="國家" SortExpression="country">
                                <ItemTemplate>
                                    <asp:Label ID="countryLabel" runat="server" Text='<%# Bind("country") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="countryBox" runat="server" Text='<%# Bind("country") %>' CssClass="form-control form-control-primary"></asp:TextBox>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="countryFooterBox" runat="server" CssClass="form-control"></asp:TextBox>
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="editBtn" runat="server" CommandName="Edit" ToolTip="編輯" CssClass="btn"><i class="ti-pencil-alt text-blue f-24 font-weight-bold"></i></asp:LinkButton>
                                    <asp:LinkButton ID="deleteBtn" runat="server" CommandName="Delete" ToolTip="刪除" OnClientClick="javascript:if(!window.confirm('你確定要刪除嗎?')) window.event.returnValue = false;" CssClass="btn"><i class="ti-trash text-blue f-24"></i></asp:LinkButton>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="updateBtn" runat="server" CommandName="Update" ToolTip="儲存" CssClass="btn"><i class="ti-save-alt text-blue f-24"></i></asp:LinkButton>
                                    <asp:LinkButton ID="cancelBtn" runat="server" CommandName="Cancel" ToolTip="取消編輯" CssClass="btn"><i class="ti-close text-blue f-24"></i></asp:LinkButton>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:LinkButton ID="insertBtn" runat="server" CommandName="Insert" ToolTip="新增國家名稱" CssClass="btn"><i class="ti-plus text-blue f-24"></i></asp:LinkButton>
                                </FooterTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <br />
                </div>
            </div>
        </div>
    </div>
</asp:Content>