﻿<%@ Page Title="" Language="C#" MasterPageFile="~/backLayout.Master" AutoEventWireup="true" CodeBehind="b_YachtAddPage.aspx.cs" Inherits="Tayana.WebForm26" ValidateRequest="False" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Scripts/ckeditor/ckeditor.js"></script>
    <style>
        .switch {
            position: relative;
            display: inline-block;
            width: 38px;
            height: 20px;
        }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #B4C3CA;
            -webkit-transition: .5s;
            transition: .5s;
            border: 2px solid white;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 20px;
                left: -3px;
                bottom: -2px;
                background-color: white;
                -webkit-transition: .5s;
                transition: .5s;
            }

            .slider.round {
                border-radius: 34px;
            }

                .slider.round:before {
                    border-radius: 50%;
                }

        input:checked + .slider {
            background-color: #3A6EFF;
            /*background-color: #2196F3;*/
        }

        input:focus + .slider {
            box-shadow: 0 0 1px #2196F3;
        }

        input:checked + .slider:before {
            -webkit-transform: translateX(20px);
            -ms-transform: translateX(20px);
            transform: translateX(20px);
        }

        .adjust-btn {
            padding-left: 40px;
            padding-right: 40px;
            letter-spacing: 10px;
            margin-right: -15px;
        }

        .adjust-width {
            width: 20% !important;
        }

        .adjust-margin {
            margin-top: 30px;
        }

        .littleheader {
            padding: 15px;
            border-radius: 5px;
            background-image: linear-gradient(to right, #57AAE1, #B4C3FA);
            position: relative;
            margin: 15px 12px 20px 15px;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script>
        $(document).ready(function () {
            (function () {
                $('.btn-tab-prev').on('click', function (e) {
                    e.preventDefault()
                    $('#' + $('.nav-item > .active').parent().prev().find('a').attr('id')).tab('show')
                })
                $('.btn-tab-next').on('click', function (e) {
                    e.preventDefault()
                    $('#' + $('.nav-item > .active').parent().next().find('a').attr('id')).tab('show')
                    $("html, body").animate({ scrollTop: 0 }, 1000);
                    return false;
                })
            })();

        });
    </script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).on("submit", "form", function (event) {
            window.onbeforeunload = null;
        });
        window.onbeforeunload = confirmExit;
        function confirmExit() {
            return "您確定要離開此頁嗎?";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-header card">
        <div class="card-block" style="position: relative">
            <h4 class="mb-10" style="color: #546D77">新增遊艇型號</h4>
            <div style="position: absolute; right: 30px; top: 30px">
                <asp:LinkButton ID="BackToList" runat="server" CssClass="btn btn-primary btn-round f-16 font-weight-bold" OnClick="BackToList_Click" OnClientClick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="ti-back-right"></i>返回遊艇列表</asp:LinkButton>
            </div>
            <p class="text-muted f-16">
                請依序將所有資料填妥再送出，相簿及檔案管理待文字敘述的部分填寫完畢時即可開啟。
            </p>
            <ul class="breadcrumb-title b-t-default p-t-10">
                <li class="breadcrumb-item">
                    <a href="back_Index.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;"><i class="fa fa-home"></i></a>
                </li>
                <li class="breadcrumb-item"><a href="b_YachtsList.aspx" onclick="javascript:if(!window.confirm('您即將離開此頁面，已填寫的資料將會遺失，您確定要離開嗎?')) window.event.returnValue = false;">管理遊艇列表</a>
                </li>
                <li class="breadcrumb-item"><a href="#!">新增遊艇型號</a>
                </li>
            </ul>
            <br />
            <asp:Label ID="warning" runat="server" ForeColor="Red" Font-Size="16px"></asp:Label>
        </div>
    </div>

    <div class="card">
        <div class="card-block tab-icon">
            <div class="row">
                <div class="col-lg-12">
                    <div class="littleheader">
                        <div class="fontsize-18 font-weight-bold text-white" style="margin-bottom: 10px; letter-spacing: 1px">請填寫遊艇型號 :</div>
                        <asp:TextBox ID="name" runat="server" CssClass="form-control col-sm-3 fontsize-16" required="" placeholder="記得填寫遊艇型號喔" />
                        <div style="position: absolute; top: 65px; right: 30px;">
                            <label class="switch">
                                <asp:CheckBox ID="checkbox" runat="server" />
                                <span class="slider round"></span>
                            </label>
                            <span style="color: white; font-size: 18px; padding-left: 10px; font-weight: bold; text-shadow: 1px 1px #3A6EFF">標註為最新船型</span>
                        </div>
                    </div>

                    <div class="container">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs md-tabs" id="tab-next-prev" role="tablist">
                            <li class="nav-item adjust-width">
                                <a class="nav-link active f-16" id="tab1-tab" data-toggle="tab" href="#tab1" role="tab" aria-controls="tab1" aria-selected="true"><i class="ti-agenda"></i>&nbsp 1.遊艇總覽Overview</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16" id="tab2-tab" data-toggle="tab" href="#tab2" role="tab" aria-controls="tab2" aria-selected="false"><i class="ti-ruler-alt-2"></i>&nbsp 2.遊艇結構Layout</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16" id="tab3-tab" data-toggle="tab" href="#tab3" role="tab" aria-controls="tab3" aria-selected="false"><i class="icofont icofont-ui-settings"></i>&nbsp 3.遊艇規格Specification</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16 text-default" id="tab4-tab" aria-readonly="true"><i class="ti-gallery"></i>&nbsp 4.上傳相片(相片輪播)</a>
                                <div class="slide adjust-width"></div>
                            </li>
                            <li class="nav-item adjust-width">
                                <a class="nav-link f-16 text-default" id="tab5-tab" aria-readonly="true"><i class="ti-files"></i>&nbsp 5.上傳PDF檔案</a>
                                <div class="slide adjust-width"></div>
                            </li>
                        </ul>
                        <!-- Tab panes -->
                        <div class="tab-content" id="tab-next-prev-content">
                            <div class="tab-pane fade show active" id="tab1" role="tabpanel" aria-labelledby="tab1-tab">
                                <div class="adjust-margin">
                                    <h5 class="sub-title fontsize-16">。請填寫遊艇簡介</h5>
                                    <asp:TextBox ID="overview" runat="server" TextMode="MultiLine" required=""></asp:TextBox><br />
                                </div>
                                <div class="adjust-margin">
                                    <h5 class="sub-title fontsize-16">。請輸入遊艇尺寸Dimensions<span style="color: darkcyan">( 上傳圖片建議的寬度為280以內，並且盡量不要更動表格格式 )</span></h5>
                                    <asp:TextBox ID="dimensions" runat="server" TextMode="MultiLine" required=""></asp:TextBox><br />
                                </div>
                                <div class="d-flex justify-content-end" style="margin-right: 20px"><a href="#" role="button" class="btn btn-primary btn-round btn-tab-next f-16 font-weight-bold adjust-btn">下一步</a></div>
                            </div>
                            <div class="tab-pane fade" id="tab2" role="tabpanel" aria-labelledby="tab2-tab">
                                <div class="adjust-margin">
                                    <h5 class="sub-title fontsize-16">。請上傳遊艇剖面結構圖<span style="color: darkcyan">( 上傳圖片建議的寬度為610以內，並且請將每張圖片加上一個項目符號<i class="ti-layout-list-thumb-alt"></i> )</span></h5>
                                    <asp:TextBox ID="layout" runat="server" TextMode="MultiLine" required=""></asp:TextBox><br />
                                </div>
                                <div class="d-flex justify-content-end" style="margin-right: 20px"><a href="#" role="button" class="btn btn-primary btn-round btn-tab-next f-16 font-weight-bold adjust-btn">下一步</a></div>
                            </div>
                            <div class="tab-pane fade" id="tab3" role="tabpanel" aria-labelledby="tab3-tab">
                                <div class="adjust-margin">
                                    <h5 class="sub-title fontsize-16">。請填寫遊艇詳細規格<span style="color: darkcyan">( 請以條列式的方式敘述遊艇規格<i class="ti-layout-list-thumb-alt"></i> )</span></h5>
                                    <asp:TextBox ID="specification" runat="server" TextMode="MultiLine" required=""></asp:TextBox><br />
                                </div>
                                <div class="d-flex justify-content-end" style="margin-right: 20px; margin-top: 10px">
                                    <asp:Label ID="lbl" CssClass="f-16 font-weight-bold text-c-blue" runat="server" Text="結束文字撰寫，前往相簿及檔案管理。"></asp:Label>
                                </div>
                                <div class="d-flex justify-content-end" style="margin-right: 20px">
                                    <asp:Button ID="nextBtn" runat="server" Text="下一步" role="button" CssClass="btn btn-primary btn-round f-16 font-weight-bold adjust-btn" OnClick="nextBtn_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        CKEDITOR.replace('ContentPlaceHolder1_overview',
            {
                filebrowserBrowseUrl: '/Scripts/ckfinder/ckfinder.html',
                filebrowserImageBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Images',
                filebrowserFlashBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Flash',
                filebrowserUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Files',
                filebrowserImageUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Images',
                filebrowserFlashUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Flash',
                height: '300',
                uiColor: '#ADD6F1'
            });
        CKEDITOR.replace('ContentPlaceHolder1_dimensions',
            {
                filebrowserBrowseUrl: '/Scripts/ckfinder/ckfinder.html',
                filebrowserImageBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Images',
                filebrowserFlashBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Flash',
                filebrowserUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Files',
                filebrowserImageUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Images',
                filebrowserFlashUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Flash',
                height: '370',
                uiColor: '#ADD6F1'
            });
        CKEDITOR.replace('ContentPlaceHolder1_layout',
            {
                filebrowserBrowseUrl: '/Scripts/ckfinder/ckfinder.html',
                filebrowserImageBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Images',
                filebrowserFlashBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Flash',
                filebrowserUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Files',
                filebrowserImageUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Images',
                filebrowserFlashUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Flash',
                height: '700',
                uiColor: '#ADD6F1'
            });
        CKEDITOR.replace('ContentPlaceHolder1_specification',
            {
                filebrowserBrowseUrl: '/Scripts/ckfinder/ckfinder.html',
                filebrowserImageBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Images',
                filebrowserFlashBrowseUrl: '/Scripts/ckfinder/ckfinder.html?type=Flash',
                filebrowserUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Files',
                filebrowserImageUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Images',
                filebrowserFlashUploadUrl: '/Scripts/ckfinder/core/connector/aspx/connector.aspx?command=QuickUpload&type=Flash',
                height: '700',
                uiColor: '#ADD6F1'
            });
    </script>
</asp:Content>