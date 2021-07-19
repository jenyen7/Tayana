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
    public partial class WebForm8 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInformation.IsPermissionAccess(16))
            {
                Response.Redirect("back_Index.aspx");
            }
            if (!IsPostBack)
            {
                LoadYachtsDDL();
                ShowMessages();
            }
            warning.Text = "";
        }

        private void LoadYachtsDDL()
        {
            DataTable yachtsList = db.GetAllDataTable("yachts");
            yachtsDDL.DataSource = yachtsList;
            yachtsDDL.DataTextField = "yachtName";
            yachtsDDL.DataValueField = "id";
            yachtsDDL.DataBind();
            yachtsDDL.Items.Insert(0, new ListItem("< 請選擇遊艇型號 >", "0"));
        }

        private void ShowMessages()
        {
            DataTable comments = db.GetAllDataTable("contact", "sentDate DESC");
            MessagesRpt.DataSource = comments;
            MessagesRpt.DataBind();
        }

        protected void BackToIndexBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("back_Index.aspx");
        }

        protected void yachtsDDL_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedYacht = ((DropDownList)sender).SelectedItem.Text;
            DataTable commentsFiltered = db.GetSelectedDataTable("contact", "brochure", selectedYacht);
            if (commentsFiltered.Rows.Count > 0)
            {
                MessagesRpt.DataSource = commentsFiltered;
                MessagesRpt.DataBind();
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + "無搜尋結果" + "');", true);
            }
        }

        protected void clearSearch_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("b_Messages.aspx");
        }
    }
}