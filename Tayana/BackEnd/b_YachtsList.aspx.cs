using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Tayana
{
    public partial class WebForm20 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInformation.IsPermissionAccess(2))
            {
                Response.Redirect("back_Index.aspx");
            }
            if (!IsPostBack)
            {
                ShowYachts();
            }
            warning.Text = "";
        }

        private void ShowYachts()
        {
            if (Session["searchDateStart"] != null && Session["searchDateEnd"] != null && Session["searchYachtsWord"] != null)
            {
                searchDateStart.Text = Session["searchDateStart"].ToString();
                searchDateEnd.Text = Session["searchDateEnd"].ToString();
                searchBox.Text = Session["searchYachtsWord"].ToString();
                showSearchingResults();
            }
            else if (Session["searchDateStart"] != null && Session["searchDateEnd"] != null)
            {
                searchDateStart.Text = Session["searchDateStart"].ToString();
                searchDateEnd.Text = Session["searchDateEnd"].ToString();
                showSearchingResults();
            }
            else if (Session["searchYachtsWord"] != null)
            {
                searchBox.Text = Session["searchYachtsWord"].ToString();
                showSearchingResults();
            }
            else
            {
                PagingControl.targetpage = "b_YachtsList.aspx";
                PagingControl.limit = 5;
                PagingControl.totalitems = db.GetTotalPagesCount("yachts");
                string currentPage = Request.QueryString["page"];
                DataTable yachtsTable = db.GetPagingData("yachts", "newest DESC", "publishedDate DESC", currentPage, PagingControl.limit);
                Yachts.DataSource = yachtsTable;
                Yachts.DataBind();
                PagingControl.showPageControls();
            }
        }

        protected void searchBtn_Click(object sender, EventArgs e)
        {
            if ((!string.IsNullOrEmpty(searchDateStart.Text) && searchDateEnd.Text == "") || (searchDateStart.Text == "" && !string.IsNullOrEmpty(searchDateEnd.Text)))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + "起始跟結束日期都得選喔" + "');", true);
                return;
            }
            Session["searchDateStart"] = searchDateStart.Text;
            Session["searchDateEnd"] = searchDateEnd.Text;
            Session["searchYachtsWord"] = searchBox.Text;
            Response.Redirect("b_YachtsList.aspx");
            showSearchingResults();
        }

        private void showSearchingResults()
        {
            PagingControl.targetpage = "b_YachtsList.aspx";
            PagingControl.limit = 5;
            PagingControl.totalitems = db.GetSelectedYachtsTotalPagesCount(searchDateStart.Text, searchDateEnd.Text, searchBox.Text);
            string currentPage = Request.QueryString["page"];
            DataTable yachtsTable = db.GetSelectedYachtsPagingData(currentPage, PagingControl.limit, searchDateStart.Text, searchDateEnd.Text, searchBox.Text);
            if (yachtsTable.Rows.Count > 0)
            {
                Yachts.DataSource = yachtsTable;
                Yachts.DataBind();
            }
            else
            {
                noSearchingResultlbl.Visible = true;
            }
            PagingControl.showPageControls();
        }

        protected void Yachts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Edit")
            {
                if (Session["searchDateStart"] == null && Session["searchDateEnd"] == null && Session["searchYachtsWord"] == null)
                {
                    string currentPage = Request.QueryString["page"];
                    if (!string.IsNullOrEmpty(currentPage))
                    {
                        Session["YachtsCurrentPage"] = currentPage;
                    }
                }
                Response.Redirect("b_YachtEditPage.aspx?id=" + id);
            }
            else if (e.CommandName == "Delete")
            {
                DataTable gallerylist = db.GetSelectedDataTable("yachtsGallery", "yachtID", id);
                DataTable pdflist = db.GetSelectedDataTable("yachtsPDFfile", "yachtID", id);
                if (gallerylist.Rows.Count > 0 || pdflist.Rows.Count > 0)
                {
                    warning.Text = "此遊艇型號有儲存相片或者PDF檔案喔，無法直接刪除，請先刪除他的相片或者PDF檔案";
                    return;
                }
                DataTable table = db.GetSelectedDataTable("yachts", "id", id);
                db.ExecuteDelete("yachts", "id", id);
                db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了遊艇列表中的({table.Rows[0]["yachtName"]})");
                ShowYachts();
            }
        }

        protected void BackToIndexBtn_Click(object sender, EventArgs e)
        {
            Session["searchYachtsWord"] = null;
            Session["searchDateStart"] = null;
            Session["searchDateEnd"] = null;
            Response.Redirect("back_Index.aspx");
        }

        protected void AddNewYachtBtn_Click1(object sender, EventArgs e)
        {
            Session["searchYachtsWord"] = null;
            Session["searchDateStart"] = null;
            Session["searchDateEnd"] = null;
            Response.Redirect("b_YachtAddPage.aspx");
        }

        protected void clearSearch_Click(object sender, ImageClickEventArgs e)
        {
            Session["searchYachtsWord"] = null;
            Session["searchDateStart"] = null;
            Session["searchDateEnd"] = null;
            Response.Redirect("b_YachtsList.aspx");
        }
    }
}