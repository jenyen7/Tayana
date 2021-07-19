<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="back_Index.aspx.cs" Inherits="Tayana.WebForm31" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .blink_me {
            animation: blinker 2s linear infinite;
        }

        @keyframes blinker {
            50% {
                opacity: 0;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-6 col-xl-3">
            <div class="card bg-c-blue order-card">
                <div class="card-block">
                    <h6 class="m-b-20">目前遊艇型號共有</h6>
                    <h2 class="text-right"><i class="ti-anchor f-left"></i>
                        <asp:Literal ID="yachtsTotal" runat="server"></asp:Literal><span class="fontsize-18">&nbsp 個</span></h2>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="card bg-c-green order-card">
                <div class="card-block">
                    <h6 class="m-b-20">目前新聞共有</h6>
                    <h2 class="text-right"><i class="ti-write f-left"></i>
                        <asp:Literal ID="newsTotal" runat="server"></asp:Literal><span class="fontsize-18">&nbsp 則</span></h2>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="card bg-c-yellow order-card">
                <div class="card-block">
                    <h6 class="m-b-20">目前代理商共有</h6>
                    <h2 class="text-right"><i class="ti-map-alt f-left"></i>
                        <asp:Literal ID="dealersTotal" runat="server"></asp:Literal><span class="fontsize-18">&nbsp 個</span></h2>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="card bg-c-pink order-card">
                <div class="card-block">
                    <h6 class="m-b-20">目前訪客留言共有</h6>
                    <h2 class="text-right"><i class="ti-comment-alt f-left"></i>
                        <asp:Literal ID="commentsTotal" runat="server"></asp:Literal><span class="fontsize-18">&nbsp 則</span></h2>
                </div>
            </div>
        </div>
    </div>
    <!-- tabs card start -->
    <div>
        <div class="card tabs-card">
            <div class="card-block p-0">
                <!-- Nav tabs -->
                <ul class="nav nav-tabs md-tabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#home3" role="tab"><i class="ti-anchor"></i>遊艇型號</a>
                        <div class="slide"></div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#profile3" role="tab"><i class="ti-write"></i>新聞大綱</a>
                        <div class="slide"></div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#messages3" role="tab"><i class="ti-map-alt"></i>代理商</a>
                        <div class="slide"></div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#settings3" role="tab"><i class="ti-comment-alt"></i>最近留言</a>
                        <div class="slide"></div>
                    </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content card-block">
                    <div class="tab-pane active" id="home3" role="tabpanel">
                        <div class="table-responsive">
                            <asp:Repeater ID="yachts_rpt" runat="server">
                                <HeaderTemplate>
                                    <table class="table">
                                        <tr>
                                            <th style="width: 7%"></th>
                                            <th class="w-50 text-center">遊艇名稱</th>
                                            <th class="w-25">其他標註</th>
                                            <th class="w-25">新增日期</th>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="text-right"><i class="ti-flag"></i></td>
                                        <td style="padding-left: 150px"><%# Eval("yachtName") %></td>
                                        <td><%#Eval("newest").ToString() == "1" ? "<label class='label label-primary blink_me' style='font-weight:bold;font-size:14px'>最新</label>" : "" %></td>
                                        <td><%# Eval("publishedDate","{0: yyyy/MM/dd hh:mm}") %></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div class="tab-pane w-100" id="profile3" role="tabpanel">
                        <div class="table-responsive">
                            <asp:Repeater ID="news_rpt" runat="server">
                                <HeaderTemplate>
                                    <table class="table">
                                        <tr>
                                            <th style="width: 7%"></th>
                                            <th class="w-50 text-center">新聞標題</th>
                                            <th class="w-25">是否置頂</th>
                                            <th class="w-25">發佈日期</th>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="text-right"><i class="ti-notepad"></i></td>
                                        <td style="padding-left: 150px"><%# Eval("newsTitle") %></td>
                                        <td><%#Eval("pinned").ToString() == "1" ? "<label class='label label-success blink_me' style='font-weight:bold;font-size:14px'>置頂</label>" : "" %></td>
                                        <td><%# Eval("postDate") %></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div class="tab-pane" id="messages3" role="tabpanel">
                        <div class="table-responsive">
                            <asp:Repeater ID="dealers_rpt" runat="server">
                                <HeaderTemplate>
                                    <table class="table">
                                        <tr>
                                            <th style="width: 7%"></th>
                                            <th class="w-50 text-center">代理商</th>
                                            <th class="w-25">所在地區</th>
                                            <th class="w-25">聯絡電話</th>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="text-right"><i class="ti-location-pin"></i></td>
                                        <td style="padding-left: 150px"><%# Eval("dealerName") %>&nbsp<%# Eval("dealerContact") %></td>
                                        <td>
                                            <label class='label label-warning' style='font-weight: bold; font-size: 14px'><%# Eval("city") %>&nbsp<%# Eval("country") %></label></td>
                                        <td><%# Eval("dealerTel") %></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div class="tab-pane" id="settings3" role="tabpanel">
                        <div class="table-responsive">
                            <asp:Repeater ID="comments_rpt" runat="server">
                                <HeaderTemplate>
                                    <table class="table">
                                        <tr>
                                            <th style="width: 7%"></th>
                                            <th class="w-50 text-center">訪客名稱</th>
                                            <th class="w-25">申請的遊艇目錄</th>
                                            <th class="w-25">通知日期</th>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="text-right"><i class="ti-layout"></i></td>
                                        <td style="padding-left: 150px"><%# Eval("name") %>&nbsp from&nbsp<%# Eval("country") %></td>
                                        <td>
                                            <label class='label label-danger' style='font-weight: bold; font-size: 14px'><%# Eval("brochure") %></label></td>
                                        <td><%# Eval("sentDate") %></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- tabs card end -->
    <!-- users visite and profile start -->
    <div class="row">
        <div class="col-md-4">
            <div class="card user-card">
                <div class="card-header">
                    <h5>個人簡介</h5>
                </div>
                <div class="card-block">
                    <div>
                        <asp:Image ID="ImageProfile" runat="server" CssClass="img-radius" AlternateText="User-Profile-Image" Height="100" Width="100" />
                    </div>
                    <h6 class="f-w-600 m-t-25 m-b-10">
                        <asp:Literal ID="profilename" runat="server"></asp:Literal></h6>
                    <p class="text-muted">
                        <asp:Literal ID="profileemail" runat="server"></asp:Literal>
                    </p>
                    <hr />
                    <div class="bg-c-blue counter-block m-t-10 p-20">
                        <div class="text-center">
                            <i class="ti-calendar"></i>&nbsp
                            <asp:Literal ID="joindate" runat="server"></asp:Literal>&nbsp 加入管理員行列
                        </div>
                    </div>
                    <p class="m-t-15 text-muted"><a href="b_AccountInfo.aspx?useraccount=<%=HttpContext.Current.User.Identity.Name.ToString() %>">編輯個人資料</a></p>
                    <hr />
                    <div class="row justify-content-center user-social-link">
                        <div class="col-auto"><a href="#!"><i class="fa fa-facebook text-facebook"></i></a></div>
                        <div class="col-auto"><a href="#!"><i class="fa fa-twitter text-twitter"></i></a></div>
                        <div class="col-auto"><a href="#!"><i class="fa fa-instagram text-instagram"></i></a></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5>管理員活動紀錄</h5>
                    <div class="card-header-right">
                        <ul class="list-unstyled card-option">
                            <li><i class="fa fa-chevron-left"></i></li>
                            <li><i class="fa fa-window-maximize full-card"></i></li>
                            <li><i class="fa fa-minus minimize-card"></i></li>
                            <li><i class="fa fa-refresh reload-card"></i></li>
                            <li><i class="fa fa-times close-card"></i></li>
                        </ul>
                    </div>
                </div>
                <div class="card-block">
                    <ul class="feed-blog">
                        <asp:Literal ID="activitiesLit" runat="server"></asp:Literal>
                        <%--<li class="active-feed">
                            <div class="feed-user-img">
                                <img src="assets/images/avatar-3.jpg" class="img-radius " alt="User-Profile-Image">
                            </div>
                            <h6><span class="label label-danger">留言</span> John 新增: <small class="text-muted">2 小時之前</small></h6>
                            <p class="m-b-15 m-t-15">Hi <b>@所有人</b> 你們覺得這些照片放到網站上如何?</p>
                            <div class="row">
                                <div class="col-auto text-center">
                                    <img src="assets/images/blog/blog-r-1.jpg" alt="img" class="img-fluid img-100">
                                    <h6 class="m-t-15 m-b-0">新聞封面1</h6>
                                    <p class="text-muted m-b-0 text-c-blue"><small>PNG-100KB</small></p>
                                </div>
                                <div class="col-auto text-center">
                                    <img src="assets/images/blog/blog-r-2.jpg" alt="img" class="img-fluid img-100">
                                    <h6 class="m-t-15 m-b-0">新聞封面2</h6>
                                    <p class="text-muted m-b-0"><small>PNG-150KB</small></p>
                                </div>
                                <div class="col-auto text-center">
                                    <img src="assets/images/blog/blog-r-3.jpg" alt="img" class="img-fluid img-100">
                                    <h6 class="m-t-15 m-b-0">新聞封面3</h6>
                                    <p class="text-muted m-b-0"><small>PNG-150KB</small></p>
                                </div>
                            </div>
                        </li>
                        <li class="diactive-feed">
                            <div class="feed-user-img">
                                <img src="assets/images/avatar-4.jpg" class="img-radius " alt="User-Profile-Image">
                            </div>
                            <h6><span class="label label-success">新聞</span>Dubois 編輯: <span class="text-c-green">聖誕節的新聞</span><small class="text-muted"> 2 小時之前</small></h6>
                        </li>
                        <li class="diactive-feed">
                            <div class="feed-user-img">
                                <img src="assets/images/avatar-2.jpg" class="img-radius " alt="User-Profile-Image">
                            </div>
                            <h6><span class="label label-primary">遊艇</span> Marc 刪除:  <span class="text-c-green">3張Tayana 37 的照片</span>  <small class="text-muted">6 小時之前</small></h6>
                            <p class="m-b-15 m-t-15"><b>@Sara</b>我需要新的照片</p>
                        </li>
                        <li class="active-feed">
                            <div class="feed-user-img">
                                <img src="assets/images/avatar-3.jpg" class="img-radius " alt="User-Profile-Image">
                            </div>
                            <h6><span class="label label-warning">代理</span>John 新增 : <span class="text-c-green">一個台灣的代理商</span><small class="text-muted"> 10 小時之前</small></h6>
                        </li>--%>
                    </ul>
                </div>
            </div>
        </div>
        <!-- users visite and profile end -->
    </div>
</asp:Content>