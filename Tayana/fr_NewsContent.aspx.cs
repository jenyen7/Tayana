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
    public partial class WebForm11 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderNewsContent();
            }
        }

        private void RenderNewsContent()
        {
            DataBase db = new DataBase();
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable newsTable = db.GetSelectedDataTable("news", "id", id);
            Repeater_NewsContent.DataSource = newsTable;
            Repeater_NewsContent.DataBind();
        }
    }
}