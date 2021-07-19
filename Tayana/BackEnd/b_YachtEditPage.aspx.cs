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
    public partial class WebForm32 : System.Web.UI.Page
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
                ShowHistoryContent();
                if (Request.QueryString["tab"] != null)
                {
                    TabName.Value = Request.QueryString["tab"].ToString();
                }
            }
            warning.Text = "";
        }

        private void ShowHistoryContent()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable yacht = db.GetSelectedDataTable("yachts", "id", id);
            switch (Convert.ToInt32(yacht.Rows[0]["newest"]))
            {
                case 0:
                    checkbox.Checked = false;
                    break;

                case 1:
                    checkbox.Checked = true;
                    break;
            }
            name.Text = yacht.Rows[0]["yachtName"].ToString();
            overview.Text = yacht.Rows[0]["overview"].ToString();
            dimensions.Text = yacht.Rows[0]["dimensions"].ToString();
            layout.Text = yacht.Rows[0]["layout"].ToString();
            specification.Text = yacht.Rows[0]["specification"].ToString();
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(checkTextBox()))
            {
                warning.Text = checkTextBox();
                return;
            }
            int id = Convert.ToInt32(Request.QueryString["id"]);
            db.UpdateYacht(id, name.Text, overview.Text, dimensions.Text, layout.Text, specification.Text, checkbox.Checked);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{name.Text}遊艇型號");
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('資料已儲存');", true);
            ShowHistoryContent();
        }

        protected void BackToList_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_YachtsList.aspx");
        }

        private string checkTextBox()
        {
            string warning = "";
            if (string.IsNullOrEmpty(name.Text))
            {
                warning += "遊艇型號必填, ";
            }
            if (string.IsNullOrEmpty(overview.Text))
            {
                warning += "遊艇簡介必填, ";
            }
            if (string.IsNullOrEmpty(dimensions.Text))
            {
                warning += "遊艇尺寸必填, ";
            }
            if (string.IsNullOrEmpty(layout.Text))
            {
                warning += "遊艇剖面結構圖必須提供喔, ";
            }
            if (string.IsNullOrEmpty(specification.Text))
            {
                warning += "遊艇規格必填 ";
            }
            return warning;
        }
    }
}