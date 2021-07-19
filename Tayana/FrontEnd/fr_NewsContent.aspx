<%@ Page Title="" Language="C#" MasterPageFile="~/FrontEnd/frontLayaout.Master" AutoEventWireup="true" CodeBehind="fr_NewsContent.aspx.cs" Inherits="Tayana.WebForm11" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Banner_img" runat="server">
    <div class="banner">
        <ul>
            <li>
                <img src="../assets_tayana/images/newbanner.jpg" alt="Tayana Yachts" />
            </li>
        </ul>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Left_NavBar" runat="server">
    <p>
        <span>NEWS</span>
    </p>
    <ul>
        <li><a href="#">News & Events</a></li>
    </ul>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="Content" runat="server">
    <div id="crumb"><a href="fIndex.aspx">Home</a> >> <a href="#">News </a>>> <a href="#"><span class="on1">News & Events</span></a></div>
    <div class="right">
        <div class="right1">
            <div class="title">
                <span>News & Events</span>
            </div>
            <!--------------------------------內容開始---------------------------------------------------->
            <div class="box3">
                <asp:Repeater ID="Repeater_NewsContent" runat="server">
                    <ItemTemplate>
                        <h4><%# Eval("newsTitle") %></h4>
                        <div><%# Eval("newsContent") %></div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="buttom001">
                <a href="javascript:window.history.back();">
                    <asp:ImageButton ID="BackToNewsBtn" runat="server" ImageUrl="/../assets_tayana/images/back.gif" Width="55px" Height="28px" PostBackUrl="~/fr_News.aspx" />
            </div>
            <!--------------------------------內容結束------------------------------------------------------>
        </div>
    </div>
</asp:Content>