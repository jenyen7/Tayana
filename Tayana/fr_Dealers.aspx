<%@ Page Title="" Language="C#" MasterPageFile="~/frontLayaout.Master" AutoEventWireup="true" CodeBehind="fr_Dealers.aspx.cs" Inherits="Tayana.WebForm14" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Banner_img" runat="server">
    <div class="banner">
        <ul>
            <li>
                <img src="assets_tayana/images/DEALERS.jpg" alt="Tayana Yachts" />
            </li>
        </ul>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Left_NavBar" runat="server">
    <p><span>DEALERS</span></p>
    <ul>
        <asp:Repeater ID="Repeater_LinkCountries" runat="server">
            <ItemTemplate>
                <li><a href='fr_Dealers.aspx?id=<%#Eval("countryID") %>'><%#Eval("country") %></a></li>
            </ItemTemplate>
        </asp:Repeater>
    </ul>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="Content" runat="server">
    <div id="crumb">
        <a href="fIndex.aspx">Home</a> >> <a href="#">Dealers </a>>> <a href="#">
            <asp:Label ID="country" runat="server" CssClass="on1" Text='<%#Eval("country") %>'></asp:Label>
        </a>
    </div>
    <div class="right">
        <div class="right1">
            <div class="title">
                <asp:Label ID="title" runat="server" Text='<%#Eval("country") %>'></asp:Label>
            </div>
            <!--------------------------------內容開始---------------------------------------------------->
            <div class="box2_list">
                <asp:Label ID="msg" runat="server" Font-Size="16px" Text="此區尚未有代理商。" Visible="false"></asp:Label>
                <ul>
                    <asp:Repeater ID="Repeater_DealersInfo" runat="server">
                        <ItemTemplate>
                            <li>
                                <div class="list02">
                                    <ul>
                                        <li class="list02li">
                                            <div>
                                                <p>
                                                    <img src="/assets_tayana/upload/Images/<%#Eval("dealerPic") %>" style="width: 209px; height: 157px; border-width: 0px;" />
                                                </p>
                                            </div>
                                        </li>
                                        <li class="list02li02"><span><%#Eval("city") %></span><br />
                                            <%#Eval("dealerName") %><br />
                                            Contact：<%#Eval("dealerContact") %><br />
                                            Address：<%#Eval("dealerAddress") %><br />
                                            TEL：<%#Eval("dealerTel") %><br />
                                            <%#Eval("dealerFax").ToString() != "" ? "FAX："+ Eval("dealerFax") + "<br />": "" %>E-Mail: <%#Eval("dealerEmail") %><br />
                                        </li>
                                    </ul>
                                </div>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <div class="pagenumber"></div>
            </div>
            <!--------------------------------內容結束------------------------------------------------------>
        </div>
    </div>
</asp:Content>