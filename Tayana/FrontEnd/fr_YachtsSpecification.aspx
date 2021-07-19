<%@ Page Title="" Language="C#" MasterPageFile="~/FrontEnd/frontLayaout.Master" AutoEventWireup="true" CodeBehind="fr_YachtsSpecification.aspx.cs" Inherits="Tayana.WebForm18" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="../assets_tayana/css/jquery.ad-gallery.css" />
    <style type="text/css">
        img,
        div,
        input {
            behavior: url("");
        }

        .ad-info, .ad-slideshow-start, .ad-slideshow-stop, .ad-slideshow-countdown {
            opacity: 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Banner_img" runat="server">
    <div class="banner1">
        <asp:Literal ID="Gallerylit" runat="server"></asp:Literal>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Left_NavBar" runat="server">
    <p><span>YACHTS</span></p>
    <ul>
        <asp:Repeater ID="YachtsList_rpt" runat="server">
            <ItemTemplate>
                <li><a href='fr_YachtsSpecification.aspx?id=<%#Eval("id") %>'><%#Eval("yachtName") %>
                    <%# Eval("newest").ToString() == "1" ? "(New Building)": ""%>
                </a></li>
            </ItemTemplate>
        </asp:Repeater>
    </ul>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="Content" runat="server">
    <div id="crumb1">
        <a href="fIndex.aspx">Home</a> >> <a href="#">Yachts</a> >> <a href="#"><span class="on1">
            <asp:Literal ID="crumb_name" runat="server"></asp:Literal></span></a>
    </div>
    <div class="right">
        <div class="right1">
            <div class="title">
                <span>
                    <asp:Literal ID="title_name" runat="server"></asp:Literal></span>
            </div>
            <!--------------------------------內容開始---------------------------------------------------->
            <!--次選單-->
            <div class="menu_y">
                <ul>
                    <li class="menu_y00">YACHTS</li>
                    <li><a class="menu_yli01"
                        href="fr_Yachts.aspx?id=<%=Convert.ToInt32(Request.QueryString["id"]) %>">Interior</a>
                    </li>
                    <li><a class="menu_yli02"
                        href="fr_YachtsLayout.aspx?id=<%=Convert.ToInt32(Request.QueryString["id"]) %>">Layout & deck plan</a></li>
                    <li><a class="menu_yli03"
                        href="fr_YachtsSpecification.aspx?id=<%=Convert.ToInt32(Request.QueryString["id"]) %>">Specification</a>
                    </li>
                    <li></li>
                </ul>
            </div>
            <!--次選單-->
            <div class="box5">
                <h4>DETAIL SPECIFICATION</h4>
                <asp:Literal ID="specification" runat="server"></asp:Literal>
            </div>
            <p class="topbuttom">
                <img src="../assets_tayana/images/top.gif" alt="top" />
            </p>
            <!--------------------------------內容結束------------------------------------------------------>
        </div>
    </div>
</asp:Content>