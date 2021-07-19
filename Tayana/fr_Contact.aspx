<%@ Page Title="" Language="C#" MasterPageFile="~/frontLayaout.Master" AutoEventWireup="true" CodeBehind="fr_Contact.aspx.cs" Inherits="Tayana.WebForm16" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .error {
            color: red;
        }
    </style>
    <script src="assets_tayana/jquery_validation/lib/jquery.js"></script>
    <script src="assets_tayana/jquery_validation/dist/jquery.validate.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#form1").validate({
                ignore: ".ignore",
                rules: {
                    ctl00$Content$Name: "required",
                    ctl00$Content$Email: {
                        required: true,
                        email: true
                    },
                    ctl00$Content$Phone: "required",
                    ctl00$Content$Country: "required",
                    ctl00$Content$Yachts: "required",
                    ctl00$Content$Comments: {
                        maxlength: 200
                    },
                    ctl00$Content$hiddenRecaptcha: {
                        required: function () {
                            if (grecaptcha.getResponse() == '') {
                                return true;
                            } else {
                                return false;
                            }
                        }
                    }
                },
                messages: {
                    ctl00$Content$Name: "*請輸入名字",
                    ctl00$Content$Email: "*請輸入正確的Email",
                    ctl00$Content$Phone: "*請輸入電話",
                    ctl00$Content$Country: "請選擇國家",
                    ctl00$Content$Yachts: "請選擇遊艇型號",
                    ctl00$Content$Comments: "字數超過上限(200字)",
                    ctl00$Content$hiddenRecaptcha: "*請透過reCaptcha驗證是否為機器人"
                },
            });
        });
    </script>
    <script type="text/javascript" src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer></script>
    <script type="text/javascript">
        var onloadCallback = function () {
            grecaptcha.render('dvCaptcha', {
                'sitekey': '<%=ReCaptcha_Key %>',
                'callback': function (response) {
                    $.ajax({
                        type: "POST",
                        url: "fr_Contact.aspx",
                        data: "{response: '" + response + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (r) {
                            var captchaResponse = jQuery.parseJSON(r.d);
                            if (captchaResponse.success) {
                                $("[id*=Content_Name]").val(captchaResponse.success);
                                $("[id*=Content_Email]").val(captchaResponse.success);
                                $("[id*=Content_Phone]").val(captchaResponse.success);
                                $("[id*=Content_rfvCaptcha]").hide();
                            } else {
                                $("[id*=Content_Name]").val("");
                                $("[id*=Content_Email]").val("");
                                $("[id*=Content_Phone]").val("");
                                $("[id*=Content_rfvCaptcha]").show();
                                var error = captchaResponse["error-codes"][0];
                                $("[id*=Content_rfvCaptcha]").html("RECaptcha error. " + error);
                            }
                        }
                    });
                }
            });
        };
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script type="text/javascript">
        function recaptchaCallback() {
            $('#Content_hiddenRecaptcha').valid();
        };
        function successAlert() {
            Swal.fire({
                title: '郵件已寄出。',
                text: '謝謝您的耐心等候~',
                imageUrl: 'assets_tayana/mail-icon1.png',
                imageWidth: 200,
                imageHeight: 200,
                imageAlt: 'mail_icon',
            });
        };
        function failureAlert() {
            Swal.fire({
                icon: 'error',
                title: '出現錯誤。',
                text: '請聯繫管理員，謝謝~',
            })
        };
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Banner_img" runat="server">
    <div class="banner">
        <ul>
            <li>
                <img src="assets_tayana/images/contact.jpg" alt="Tayana Yachts" />
            </li>
        </ul>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Left_NavBar" runat="server">
    <p><span>CONTACT</span></p>
    <ul>
        <li><a href="#">contacts</a></li>
    </ul>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="Content" runat="server">
    <div id="crumb"><a href="fIndex.aspx">Home</a> >> <a href="#"><span class="on1">Contact</span></a></div>
    <div class="right">
        <div class="right1">
            <div class="title"><span>Contact</span></div>
            <!--------------------------------內容開始---------------------------------------------------->
            <!--表單-->
            <div class="from01 row g-3">
                <p>
                    Please Enter your contact information<span class="span01">*Required</span>
                </p>
                <br />
                <table>
                    <tr>
                        <td class="from01td01">
                            <label for="Content_Name">Name :</label></td>
                        <td><span>*</span><asp:TextBox ID="Name" runat="server" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="from01td01">
                            <label for="Content_Email">Email :</label></td>
                        <td><span>*</span><asp:TextBox ID="Email" runat="server" Width="250px" TextMode="Email">
                        </asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="from01td01">
                            <label for="Content_Phone">Phone :</label></td>
                        <td><span>*</span><asp:TextBox ID="Phone" runat="server" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="from01td01">Country :</td>
                        <td><span>*</span><asp:DropDownList ID="Country" runat="server"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><span>*</span>Brochure of interest *Which Brochure would you like to view?</td>
                    </tr>
                    <tr>
                        <td class="from01td01">&nbsp;</td>
                        <td>
                            <asp:DropDownList ID="Yachts" runat="server"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="from01td01">
                            <label for="Content_Comments">Comments:</label></td>
                        <td>
                            <asp:TextBox ID="Comments" runat="server" Height="150px" Width="330px" TextMode="MultiLine" MaxLength="200"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="from01td01">&nbsp;</td>
                        <td class="f_right">
                            <div id="dvCaptcha" data-callback="recaptchaCallback"></div>
                            <div style="text-align: left">
                                <asp:HiddenField ID="hiddenRecaptcha" runat="server" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="from01td01">&nbsp;</td>
                        <td class="f_right">
                            <asp:ImageButton ID="sendEmail" type="submit" runat="server" AlternateText="submit_button" ImageUrl="assets_tayana/images/buttom03.gif" OnClick="sendEmail_Click" />
                            <asp:Label ID="msg" runat="server" ForeColor="Red"></asp:Label>
                            <div class="spinner-box hide">
                                <div class="pulse-container">
                                    <div class="pulse-bubble pulse-bubble-1"></div>
                                    <div class="pulse-bubble pulse-bubble-2"></div>
                                    <div class="pulse-bubble pulse-bubble-3"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <!--表單-->
            <div class="box1">
                <span class="span02">Contact with us</span><br />
                Thanks for your enjoying our web site as an introduction to the Tayana world and our range of yachts.
              As all the designs in our range are semi-custom built, we are glad to offer a personal service to all our
              potential customers.
              If you have any questions about our yachts or would like to take your interest a stage further, please
              feel free to contact us.
            </div>
            <div class="list03">
                <p>
                    <span>TAYANA HEAD OFFICE</span><br />
                    NO.60 Haichien Rd. Chungmen Village Linyuan Kaohsiung Hsien 832 Taiwan R.O.C<br />
                    tel. +886(7)641 2422<br />
                    fax. +886(7)642 3193<br />
                </p>
            </div>
            <div class="box4">
                <h4>Location</h4>
                <p>
                    <iframe title="map" width="695" height="518" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d117898.25198552442!2d120.24783065460194!3d22.567117928976216!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3471e297f292ef73%3A0x99f03ba7afab5cec!2z5aSn5rSL6YGK6ImH5LyB5qWt6IKh5Lu95pyJ6ZmQ5YWs5Y-4!5e0!3m2!1szh-TW!2stw!4v1611825296365!5m2!1szh-TW!2stw"></iframe>
                </p>
            </div>
            <!--------------------------------內容結束------------------------------------------------------>
        </div>
    </div>
</asp:Content>