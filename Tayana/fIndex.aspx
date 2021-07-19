<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="fIndex.aspx.cs" Inherits="Tayana.mainPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Tayana | Tayana Yachts Official Website</title>

    <script type="text/javascript" src="assets_tayana/Scripts/jquery.min.js"></script>
    <script type="text/javascript" src="assets_tayana/Scripts/jquery.cycle.all.2.74.js"></script>
    <script type="text/javascript">
        $(function () {
            // 先取得 #abgne-block-20110111 , 必要參數及輪播間隔
            var $block = $('#abgne-block-20110111'),
                timrt, speed = 4000;
            // 幫 #abgne-block-20110111 .title ul li 加上 hover() 事件
            var $li = $('.title ul li', $block).hover(function () {
                // 當滑鼠移上時加上 .over 樣式
                $(this).addClass('over').siblings('.over').removeClass('over');
            }, function () {
                // 當滑鼠移出時移除 .over 樣式
                $(this).removeClass('over');
            }).click(function () {
                // 當滑鼠點擊時, 顯示相對應的 div.info
                // 並加上 .on 樣式
                $(this).addClass('on').siblings('.on').removeClass('on');
                var thisLi = $('#abgne-block-20110111 .bd .banner ul:eq(0)').children().eq($(this).index());
                $('#abgne-block-20110111 .bd .banner ul:eq(0)').children().hide().eq($(this).index()).fadeIn(1000);
                if (thisLi.children('input[type=hidden]').val() == 1) {
                    thisLi.children('.new').show();
                }
            });
            // 幫 $block 加上 hover() 事件
            $block.hover(function () {
                // 當滑鼠移上時停止計時器
                clearTimeout(timer);
            }, function () {
                // 當滑鼠移出時啟動計時器
                timer = setTimeout(move, speed);
            });
            // 控制輪播
            function move() {
                var _index = $('.title ul li.on', $block).index();
                _index = (_index + 1) % $li.length;
                $li.eq(_index).click();
                timer = setTimeout(move, speed);
            }
            // 啟動計時器
            timer = setTimeout(move, speed);
            //相簿輪撥初始值設定
            $('.title ul li:eq(0)').addClass('on');
            var thisLi = $('#abgne-block-20110111 .bd .banner ul:eq(0) li:eq(0)');
            thisLi.addClass('on');
            if (thisLi.children('input[type=hidden]').val() == 1) {
                thisLi.children('.new').show();
            }
            //最新消息TOP
            $('.newstop').each(function () {
                if ($(this).nextAll('input[type=hidden]').val() == 1) {
                    $(this).show();
                }
            });
        });
    </script>
    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-30943877-1']);
        _gaq.push(['_trackPageview']);
        (function () {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
    </script>
    <link rel="shortcut icon" href="favicon.ico" />
    <link href="assets_tayana/css/style.css" rel="stylesheet" type="text/css" />
    <link href="assets_tayana/css/reset.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="contain">
            <div class="sub">
                <p>
                    <a href="fIndex.aspx">Home</a>
                </p>
            </div>
            <!--------------------------------選單開始---------------------------------------------------->
            <div id="logol">
                <a href="fIndex.aspx">
                    <img src="assets_tayana/images/logo001.gif" alt="Tayana" /></a>
            </div>
            <div class="menu">
                <ul>
                    <li class="menuli01"><a href="fr_Yachts.aspx?id=1">Yachts</a></li>
                    <li class="menuli02"><a href="fr_News.aspx">NEWS</a></li>
                    <li class="menuli03"><a href="fr_Company.aspx">COMPANY</a></li>
                    <li class="menuli04"><a href="fr_Dealers.aspx?id=1">DEALERS</a></li>
                    <li class="menuli05"><a href="fr_Contact.aspx">CONTACT</a></li>
                </ul>
            </div>
            <!--------------------------------選單開始結束---------------------------------------------------->
            <!--遮罩-->
            <div class="bannermasks">
                <img src="assets_tayana/images/banner00_masks.png" alt="&quot;&quot;" />
            </div>
            <!--遮罩結束-->
            <div name="form1" method="post" action="index.html" id="form">
                <div>
                    <input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE"
                        value="/wEPDwULLTE2ODUyNzM1NTIPZBYCAgMPZBYGAgEPFgIeC18hSXRlbUNvdW50AgUWCgIBD2QWAmYPFQcABl9ibGFuayB1cGxvYWQvSW1hZ2VzLzIwMTIwNDAyMTA1OTQ5LmpwZwZUQVlBTkECMzcTU1BFQ0lGSUNBVElPTiBTSEVFVAEwZAICD2QWAmYPFQcABl9ibGFuayB1cGxvYWQvSW1hZ2VzLzIwMTIwNDAyMTA1OTA5LmpwZwZUQVlBTkECNTQTU1BFQ0lGSUNBVElPTiBTSEVFVAExZAIDD2QWAmYPFQcABl9ibGFuayB1cGxvYWQvSW1hZ2VzLzIwMTIwNDAyMTA1NTA2LmpwZwZUQVlBTkECNDgTU1BFQ0lGSUNBVElPTiBTSEVFVAEwZAIED2QWAmYPFQcABl9ibGFuayB1cGxvYWQvSW1hZ2VzLzIwMTIwNDAyMTEwMzU2LmpwZwZUQVlBTkECNTgTU1BFQ0lGSUNBVElPTiBTSEVFVAEwZAIFD2QWAmYPFQcABl9ibGFuayB1cGxvYWQvSW1hZ2VzLzIwMTIwNDAyMTEwMzI5LmpwZwZUQVlBTkECNjQTU1BFQ0lGSUNBVElPTiBTSEVFVAEwZAIDDxYCHwACBRYKAgEPZBYCZg8VAiF1cGxvYWQvSW1hZ2VzL3MyMDEyMDQwMjEwNTk0OS5qcGcbVEFZQU5BMzdTUEVDSUZJQ0FUSU9OIFNIRUVUZAICD2QWAmYPFQIhdXBsb2FkL0ltYWdlcy9zMjAxMjA0MDIxMDU5MDkuanBnG1RBWUFOQTU0U1BFQ0lGSUNBVElPTiBTSEVFVGQCAw9kFgJmDxUCIXVwbG9hZC9JbWFnZXMvczIwMTIwNDAyMTA1NTA2LmpwZxtUQVlBTkE0OFNQRUNJRklDQVRJT04gU0hFRVRkAgQPZBYCZg8VAiF1cGxvYWQvSW1hZ2VzL3MyMDEyMDQwMjExMDM1Ni5qcGcbVEFZQU5BNThTUEVDSUZJQ0FUSU9OIFNIRUVUZAIFD2QWAmYPFQIhdXBsb2FkL0ltYWdlcy9zMjAxMjA0MDIxMTAzMjkuanBnG1RBWUFOQTY0U1BFQ0lGSUNBVElPTiBTSEVFVGQCBQ8WAh8AAgMWBgIBD2QWBAIBDw8WAh4ISW1hZ2VVcmwFIXVwbG9hZC9JbWFnZXMvczIwMTkxMTE4MDk1ODM3LmpwZ2RkAgIPFQQKMjAxOS8xMS8xOCQ2NzI1MWNiOC0yMDQ4LTQ2YzAtOWVhYy01ZDg2N2FkOWNjMzg0VGF5YW5hIDU0IFN0b2NrIEJvYXQgZm9yIHNhbGUgd2l0aCAgYSBzcGVjaWFsIHByaWNlIAEwZAICD2QWBAIBDw8WAh8BBSF1cGxvYWQvSW1hZ2VzL3MyMDE5MDIxMzA0MjQxMC5qcGdkZAICDxUECTIwMTkvNi8xOCQwMjk3MDdiMy0wZDUyLTRlYmYtYTI1MS0zNDI1ODMxNDQzY2QzTmV3IFRBWUFOQSA1NGZ0ICB1bmRlciBjb25zdHJ1Y3Rpb24gKGtlZXAgdXBkYXRpbmcpATBkAgMPZBYEAgEPDxYCHwEFIXVwbG9hZC9JbWFnZXMvczIwMTgxMjIyMDg0OTE1LmpwZ2RkAgIPFQQKMjAxOC8xMi8yMiQxMmY4YzNlMi1mMmZhLTQwNTQtOGQ3Mi1kOGUxZDI2NzRkYzkPTWVycnkgQ2hyaXN0bWFzATBkZCdKx/FCxbk9iOIMg1yA5eR4Hgt+" />
                </div>
                <div>
                    <input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="90059987" />
                </div>
                <!--------------------------------換圖開始---------------------------------------------------->
                <div id="abgne-block-20110111">
                    <div class="bd">
                        <div class="banner">
                            <ul>
                                <asp:Repeater ID="Repeater_banner" runat="server">
                                    <ItemTemplate>
                                        <li class="info"><a href='' target='_blank'>
                                            <img src='assets_tayana/upload/Images/<%#Eval("imageName") %>' alt="<%#Eval("imageAlt") %>" height="424" width="966" /></a>
                                            <!--文字開始-->
                                            <div class="wordtitle">
                                                <%#Eval("yachtName").ToString().Split(' ').First() %>&nbsp<span><%#Eval("yachtName").ToString().Split(' ').Last() %></span><br />
                                                <p>
                                                    SPECIFICATION SHEET
                                                </p>
                                            </div>
                                            <!--文字結束-->
                                            <!--新船型開始  54型才出現其於隱藏 -->
                                            <%#Convert.ToInt16(Eval("newest"))==1 ? "<div class='new'><img src='assets_tayana/images/new01.png' alt='new' /></div>":"<div class='new' style='display: none'><img src='assets_tayana/images/new01.png' alt='new' /></div>"%>
                                            <!--新船型結束-->
                                            <input type="hidden" value='0' />
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                            <!--小圖開始-->
                            <div class="bannerimg title" style="display: none">
                                <ul>
                                    <asp:Literal ID="banner_img" runat="server"></asp:Literal>
                                </ul>
                            </div>
                            <!--小圖結束-->
                        </div>
                    </div>
                </div>
                <!--------------------------------換圖結束---------------------------------------------------->
                <!--------------------------------最新消息---------------------------------------------------->
                <div class="news">
                    <div class="newstitle">
                        <p class="newstitlep1">
                            <img src="assets_tayana/images/news.gif" alt="news" />
                        </p>
                        <p class="newstitlep2">
                            <a href="fr_News.aspx">More>></a>
                        </p>
                    </div>
                    <ul>
                        <!--TOP第一則最新消息-->
                        <asp:Repeater ID="Repeater_TopNews" runat="server">
                            <ItemTemplate>
                                <li>
                                    <div class="news01">
                                        <!--TOP標籤-->
                                        <div class="newstop" style="display: none">
                                            <img src="assets_tayana/images/new_top01.png" alt="&quot;&quot;" />
                                        </div>
                                        <!--TOP標籤結束-->
                                        <div class="news02p1">
                                            <p class="news02p1img">
                                                <img src="assets_tayana/upload/Images/<%#Eval("newsCoverPic")%>" style="border-width: 0px;" />
                                            </p>
                                        </div>
                                        <p class="news02p2">
                                            <span>
                                                <font color="#02a5b8"><%#Eval("postDate","{0: yyyy/MM/dd}")%></font>
                                            </span>
                                            <span><a href="fr_NewsContent.aspx?id=<%#Eval("id")%>"><%#Eval("newsTitle")%></a></span>
                                        </p>
                                        <input type="hidden" value='0' />
                                    </div>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
                <!--------------------------------最新消息結束---------------------------------------------------->
            </div>
            <!--------------------------------落款開始---------------------------------------------------->
            <div class="footer">
                <div class="footerp00">
                    <a href="http://www.tognews.com/" target="_blank">
                        <p>
                            <img src="assets_tayana/images/tog.jpg" alt="TOG" />
                        </p>
                    </a>
                    <span>Visitor：
                    <div style="padding-top: 1px; float: right">
                        <img src='http://comp.hihosting.hinet.net/scripts/Count.exe?display=counter&df=89940168_1.dat&dd=A002&st=1&ft=0' height="13px">
                    </div>
                    </span>
                    <p class="footerp001">© 1973-2012 Tayana Yachts, Inc. All Rights Reserved</p>
                </div>
                <div class="footer01">
                    <span>No. 60, Hai Chien Road, Chung Men Li, Lin Yuan District, Kaohsiung City, Taiwan, R.O.C.</span><br />
                    <span>TEL：+886(7)641-2721</span> <span>FAX：+886(7)642-3193</span>
                </div>
            </div>

            <!--------------------------------落款結束---------------------------------------------------->
        </div>
    </form>
</body>
</html>