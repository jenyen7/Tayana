using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Tayana
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInformation.IsPermissionAccess(4))
            {
                Response.Redirect("back_Index.aspx");
            }
            if (!IsPostBack)
            {
                ShowNews();
            }
            warning.Text = "";
        }

        private void ShowNews()
        {
            if (Session["searchStartDate"] != null && Session["searchEndDate"] != null && Session["searchNewsWord"] != null)
            {
                searchDateStart.Text = Session["searchStartDate"].ToString();
                searchDateEnd.Text = Session["searchEndDate"].ToString();
                searchBox.Text = Session["searchNewsWord"].ToString();
                showSearchingResults();
            }
            else if (Session["searchStartDate"] != null && Session["searchEndDate"] != null)
            {
                searchDateStart.Text = Session["searchStartDate"].ToString();
                searchDateEnd.Text = Session["searchEndDate"].ToString();
                showSearchingResults();
            }
            else if (Session["searchNewsWord"] != null)
            {
                searchBox.Text = Session["searchNewsWord"].ToString();
                showSearchingResults();
            }
            else
            {
                PagingControl.targetpage = "b_NewsList.aspx";
                PagingControl.limit = 5;
                PagingControl.totalitems = db.GetTotalPagesCount("news");
                string currentPage = Request.QueryString["page"];
                DataTable newsTable = db.GetPagingData("news", "pinned DESC", "postDate DESC", currentPage, PagingControl.limit);
                News.DataSource = newsTable;
                News.DataBind();
                PagingControl.showPageControls();
            }
        }

        protected void News_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Edit")
            {
                if (Session["searchStartDate"] == null && Session["searchEndDate"] == null && Session["searchNewsWord"] == null)
                {
                    string currentPage = Request.QueryString["page"];
                    if (!string.IsNullOrEmpty(currentPage))
                    {
                        Session["NewsCurrentPage"] = currentPage;
                    }
                }
                Response.Redirect("b_NewsEdit.aspx?id=" + id);
            }
            else if (e.CommandName == "Delete")
            {
                DataTable table = db.GetSelectedDataTable("news", "id", id);
                db.ExecuteDelete("news", "id", id);
                db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了新聞列表中的{table.Rows[0]["newsTitle"]}");
                ShowNews();
            }
        }

        protected void searchBtn_Click(object sender, EventArgs e)
        {
            if ((!string.IsNullOrEmpty(searchDateStart.Text) && searchDateEnd.Text == "") || (searchDateStart.Text == "" && !string.IsNullOrEmpty(searchDateEnd.Text)))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + "起始跟結束日期都得選喔" + "');", true);
                return;
            }
            if (string.IsNullOrEmpty(searchDateStart.Text) && string.IsNullOrEmpty(searchDateEnd.Text) && string.IsNullOrEmpty(searchBox.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + "請至少輸入一種搜尋模式喔" + "');", true);
                return;
            }
            Session["searchStartDate"] = searchDateStart.Text;
            Session["searchEndDate"] = searchDateEnd.Text;
            Session["searchNewsWord"] = searchBox.Text;
            Response.Redirect("b_NewsList.aspx");
            showSearchingResults();
        }

        private void showSearchingResults()
        {
            PagingControl.targetpage = "b_NewsList.aspx";
            PagingControl.limit = 5;
            PagingControl.totalitems = db.GetSelectedNewsTotalPagesCount(searchDateStart.Text, searchDateEnd.Text, searchBox.Text);
            string currentPage = Request.QueryString["page"];
            DataTable searchingResults = db.GetSelectedNewsPagingData(currentPage, PagingControl.limit, searchDateStart.Text, searchDateEnd.Text, searchBox.Text);
            if (searchingResults.Rows.Count > 0)
            {
                News.DataSource = searchingResults;
                News.DataBind();
            }
            else
            {
                noSearchingResultlbl.Visible = true;
            }
            PagingControl.showPageControls();
        }

        protected void News_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                RepeaterItem item = e.Item;
                if ((item.FindControl("newsTitle") as Label).Text.Length > 25)
                {
                    (item.FindControl("newsTitle") as Label).Text = (item.FindControl("newsTitle") as Label).Text.Substring(0, 25) + "(...)";
                }
                if ((item.FindControl("newsSubs") as Label).Text.Length > 25)
                {
                    (item.FindControl("newsTitle") as Label).Text = (item.FindControl("newsTitle") as Label).Text.Substring(0, 25) + "(...)";
                }
            }
        }

        protected void BackToIndexBtn_Click(object sender, EventArgs e)
        {
            Session["searchNewsWord"] = null;
            Session["searchStartDate"] = null;
            Session["searchEndDate"] = null;
            Response.Redirect("back_Index.aspx");
        }

        protected void AddNewstBtn_Click(object sender, EventArgs e)
        {
            Session["searchNewsWord"] = null;
            Session["searchStartDate"] = null;
            Session["searchEndDate"] = null;
            Response.Redirect("b_NewsAdd.aspx");
        }

        protected void clearSearch_Click(object sender, ImageClickEventArgs e)
        {
            Session["searchNewsWord"] = null;
            Session["searchStartDate"] = null;
            Session["searchEndDate"] = null;
            Response.Redirect("b_NewsList.aspx");
        }
    }
}