<%@ Page Title="" Language="C#" MasterPageFile="~/frontLayaout.Master" AutoEventWireup="true" CodeBehind="fr_News.aspx.cs" Inherits="Tayana.WebForm1" %>

<%@ Register Src="~/myClasses/PagingControl.ascx" TagPrefix="uc1" TagName="PagingControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="./assets/style.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Banner_img" runat="server">
    <div class="banner">
        <ul>
            <li>
                <img src="assets_tayana/images/newbanner.jpg" alt="Tayana Yachts" />
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
            <div class="box2_list">
                <ul>
                    <asp:Repeater ID="Repeater_News" runat="server">
                        <ItemTemplate>
                            <li>
                                <div class="list01">
                                    <ul>
                                        <li>
                                            <div>
                                                <p>
                                                    <img src="/assets_tayana/upload/Images/<%# Eval("newsCoverPic") %>" style="height: 121px; width: 161px; border-width: 0px;" />
                                                </p>
                                            </div>
                                        </li>
                                        <li><span><%# Eval("postDate","{0: yyyy/MM/dd}") %></span><br />
                                            <a href="fr_NewsContent.aspx?id=<%# Eval("id") %>"><%# Eval("newsTitle") %></a>
                                        </li>
                                        <br />
                                        <li><%# Eval("newsSubs") %></li>
                                    </ul>
                                </div>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <div class="pagenumber">
                    <uc1:PagingControl runat="server" ID="PagingControl" />
                </div>
            </div>
            <!--------------------------------內容結束------------------------------------------------------>
        </div>
    </div>
</asp:Content>