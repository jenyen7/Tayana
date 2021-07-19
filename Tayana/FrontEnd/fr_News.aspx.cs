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
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderNews();
            }
        }

        private void RenderNews()
        {
            DataBase db = new DataBase();
            PagingControl.targetpage = "fr_News.aspx";
            PagingControl.limit = 5;
            PagingControl.totalitems = db.GetTotalPagesCount("news");
            string currentPage = Request.QueryString["page"];
            DataTable newsTable = db.GetPagingData("news", "pinned DESC", "postDate DESC", currentPage, PagingControl.limit);
            Repeater_News.DataSource = newsTable;
            Repeater_News.DataBind();

            PagingControl.showPageControls();
        }
    }
}