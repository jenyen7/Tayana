<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_CitiesEditing.aspx.cs" Inherits="Tayana.WebForm7" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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
                <h4 class="mb-10" style="color: #546D77">管理城市列表</h4>
                <div style="position: absolute; right: 30px; top: 30px">
                    <a href="b_DealersList.aspx" class="btn btn-round adjust-btn"><i class="ti-back-right"></i>返回代理商列表</a>
                </div>
                <div style="position: absolute; right: 210px; top: 30px">
                    <a href="b_CountriesEditing.aspx" class="btn btn-round btn-warning font-weight-bold">管理國家</a>
                </div>
                <p class="text-muted f-16">
                    在此進行編輯或刪除城市，如果要新增的城市國家尚未創建，請先新增國家名稱。
                </p>
                <ul class="breadcrumb-title b-t-default p-t-10">
                    <li class="breadcrumb-item">
                        <a href="back_Index.aspx"><i class="fa fa-home"></i></a>
                    </li>
                    <li class="breadcrumb-item"><a href="b_DealersList.aspx">管理代理商列表</a>
                    </li>
                    <li class="breadcrumb-item"><a href="#!">管理城市列表</a>
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
                <div class=" d-flex drawcloser">
                    <div style="width: 230px; height: 39px">
                        <asp:TextBox ID="cityInsertBox" runat="server" CssClass="form-control form-control-lg" placeholder="請填寫要新增的城市名稱" required=""></asp:TextBox>
                    </div>
                    <div style="width: 230px; height: 39px">
                        <asp:DropDownList ID="countriesSelect" runat="server" CssClass="form-control form-control-lg" required=""></asp:DropDownList>
                    </div>
                    <asp:Button ID="insert_btn" runat="server" Text="新增" CssClass="btn adjust-btn adjust-addBtn" OnClick="insert_btn_Click" Height="40" />
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="cities" runat="server" AutoGenerateColumns="False" DataKeyNames="cityID" GridLines="Horizontal" CssClass="grid-style table table-hover" CellPadding="5" ShowHeaderWhenEmpty="True" HeaderStyle-BackColor="#E1E7E9"
                        OnRowEditing="cities_RowEditing" OnRowCancelingEdit="cities_RowCancelingEdit" OnRowUpdating="cities_RowUpdating" OnRowDeleting="cities_RowDeleting" OnRowDataBound="cities_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="編號" HeaderStyle-Width="150px">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="城市" SortExpression="country">
                                <ItemTemplate>
                                    <asp:Label ID="cityLabel" runat="server" Text='<%# Eval("city") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="cityBox" runat="server" Text='<%# Bind("city") %>' CssClass="form-control form-control-primary f-16"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="國家" SortExpression="country">
                                <ItemTemplate>
                                    <asp:Label ID="countryLabel" runat="server" Text='<%# Eval("country") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="countryDrop" runat="server" CssClass="form-control form-control-primary dropdown-toggle">
                                    </asp:DropDownList>
                                </EditItemTemplate>
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
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>