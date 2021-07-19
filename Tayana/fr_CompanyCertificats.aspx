<%@ Page Title="" Language="C#" MasterPageFile="~/frontLayaout.Master" AutoEventWireup="true" CodeBehind="fr_CompanyCertificats.aspx.cs" Inherits="Tayana.WebForm13" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Banner_img" runat="server">
    <div class="banner">
        <ul>
            <li>
                <img src="assets_tayana/images/company.jpg" alt="Tayana Yachts" />
            </li>
        </ul>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Left_NavBar" runat="server">
    <p><span>COMPANY</span></p>
    <ul>
        <li><a href='fr_Company.aspx' target='_self'>About Us</a></li>
        <li><a href='#' target='_self'>Certificat</a></li>
    </ul>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="Content" runat="server">
    <div id="crumb"><a href="fIndex.aspx">Home</a> >> <a href="#">Company </a>>> <a href="#"><span class="on1">Certificat</span></a></div>
    <div class="right">
        <div class="right1">
            <div class="title"><span>Certificat</span></div>
            <!--------------------------------內容開始---------------------------------------------------->
            <div class="box3">
                Tayana Yacht has the approval of ISO9001: 2000 quality certification by Bureau Veritas Certification
              (Taiwan) Co., Ltd in 2002. In August, 2011, formally upgraded to ISO9001: 2008. We will continue to adhere
              to quality-oriented, transparent and committed to delivering improvement customer satisfaction and build
              even stronger trusting relationships with customers.
              <br />
                <br />
                <div class="pit">
                    <ul>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat001.jpg" alt="Tayana " />
                            </p>
                        </li>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat002.jpg" alt="Tayana " />
                            </p>
                        </li>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat003.jpg" alt="Tayana " />
                            </p>
                        </li>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat004.jpg" alt="Tayana " />
                            </p>
                        </li>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat005.jpg" alt="Tayana " />
                            </p>
                        </li>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat006.jpg" alt="Tayana " />
                            </p>
                        </li>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat007.jpg" alt="Tayana " width="319" height="234" />
                            </p>
                        </li>
                        <li>
                            <p>
                                <img src="assets_tayana/images/certificat008.jpg" alt="Tayana " width="319" height="234" />
                            </p>
                        </li>
                    </ul>
                </div>
            </div>
            <!--------------------------------內容結束------------------------------------------------------>
        </div>
    </div>
</asp:Content>