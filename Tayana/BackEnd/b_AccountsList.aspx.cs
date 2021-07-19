using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Tayana
{
    public partial class WebForm33 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInformation.IsPermissionAccess(1))
            {
                Response.Redirect("back_Index.aspx");
            }
            if (!IsPostBack)
            {
                LoadPermissionsDDL();
                ShowAccounts();
            }
            warning.Text = "";
        }

        private void LoadPermissionsDDL()
        {
            DataTable permissionsList = db.GetAllDataTable("accountsPermissions");
            permissionDDL.DataSource = permissionsList;
            permissionDDL.DataTextField = "permission";
            permissionDDL.DataValueField = "permissionID";
            permissionDDL.DataBind();
            permissionDDL.Items.Insert(0, new ListItem("< 請選擇權限 >", "0"));
        }

        private void ShowAccounts()
        {
            if (Session["searchPermissions"] != null && Session["searchAccountsWord"] != null)
            {
                searchBox.Text = Session["searchAccountsWord"].ToString();
                permissionDDL.SelectedValue = Session["searchPermissions"].ToString();
                ShowSearchResult();
            }
            else if (Session["searchPermissions"] != null)
            {
                permissionDDL.SelectedValue = Session["searchPermissions"].ToString();
                ShowSearchResult();
            }
            else if (Session["searchAccountsWord"] != null)
            {
                searchBox.Text = Session["searchAccountsWord"].ToString();
                ShowSearchResult();
            }
            else
            {
                PagingControl.targetpage = "b_AccountsList.aspx";
                PagingControl.limit = 5;
                PagingControl.totalitems = db.GetTotalPagesCount("accounts");
                string currentPage = Request.QueryString["page"];
                DataTable accountsTable = db.GetPagingData("accounts", "joinedDate DESC", "id", currentPage, PagingControl.limit);
                AccountsRpt.DataSource = accountsTable;
                AccountsRpt.DataBind();
                PagingControl.showPageControls();
            }
        }

        protected void searchBtn_Click(object sender, EventArgs e)
        {
            if (permissionDDL.SelectedValue == "0" && string.IsNullOrEmpty(searchBox.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + "請至少輸入一種搜尋模式喔" + "');", true);
                return;
            }
            Session["searchPermissions"] = permissionDDL.SelectedValue;
            Session["searchAccountsWord"] = searchBox.Text;
            Response.Redirect("b_AccountsList.aspx");
            ShowSearchResult();
        }

        private void ShowSearchResult()
        {
            PagingControl.targetpage = "b_AccountsList.aspx";
            PagingControl.limit = 5;
            PagingControl.totalitems = db.GetSelectedAccountsTotalPagesCount(permissionDDL.SelectedValue, searchBox.Text);
            string currentPage = Request.QueryString["page"];
            DataTable accountsTable = db.GetSelectedAccountsPagingData(currentPage, PagingControl.limit, permissionDDL.SelectedValue, searchBox.Text);
            if (accountsTable.Rows.Count > 0)
            {
                AccountsRpt.DataSource = accountsTable;
                AccountsRpt.DataBind();
            }
            else
            {
                noSearchingResultlbl.Visible = true;
            }
            PagingControl.showPageControls();
        }

        protected void AccountsRpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Edit")
            {
                if (Session["searchPermissions"] == null && Session["searchAccountsWord"] == null)
                {
                    string currentPage = Request.QueryString["page"];
                    if (!string.IsNullOrEmpty(currentPage))
                    {
                        Session["AccountsCurrentPage"] = currentPage;
                    }
                }
                Response.Redirect("b_AccountEdit.aspx?id=" + id);
            }
            else if (e.CommandName == "Delete")
            {
                DataTable table = db.GetSelectedDataTable("accounts", "id", id);
                db.ExecuteDelete("accounts", "id", id);
                db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了{table.Rows[0]["account"]}的帳號");
                ShowAccounts();
            }
        }

        protected void AddAccountBtn_Click(object sender, EventArgs e)
        {
            Session["searchPermissions"] = null;
            Session["searchAccountsWord"] = null;
            Response.Redirect("b_AccountAdd.aspx");
        }

        protected void BackToIndexBtn_Click(object sender, EventArgs e)
        {
            Session["searchPermissions"] = null;
            Session["searchAccountsWord"] = null;
            Response.Redirect("back_Index.aspx");
        }

        protected void clearSearch_Click(object sender, ImageClickEventArgs e)
        {
            Session["searchPermissions"] = null;
            Session["searchAccountsWord"] = null;
            Response.Redirect("b_AccountsList.aspx");
        }
    }
}