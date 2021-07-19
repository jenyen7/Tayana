using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Tayana
{
    public partial class WebForm23 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ShowHistoryContent();
            }
            warning.Text = "";
            avatarlbl.Text = "";
        }

        private void ShowHistoryContent()
        {
            DataTable userInfo = db.GetSelectedDataTable("accounts", "account", HttpContext.Current.User.Identity.Name);
            username.Text = userInfo.Rows[0]["username"].ToString();
            email.Text = userInfo.Rows[0]["email"].ToString();
            hidAvatar.Value = userInfo.Rows[0]["avatar"].ToString();
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            string filename;
            if (avatar.HasFile)
            {
                string avatarMsg = Helper.CheckUploadImage(avatar);
                if (!string.IsNullOrEmpty(avatarMsg))
                {
                    avatarlbl.Text = avatarMsg;
                    return;
                }
                else
                {
                    filename = DateTime.Now.ToString("yyyyMMdd_") + avatar.FileName;
                    avatar.SaveAs(Server.MapPath("~/assets/images/" + filename));
                }
            }
            else
            {
                filename = hidAvatar.Value;
            }
            db.UpdateAccountsInfo(HttpContext.Current.User.Identity.Name, username.Text, email.Text, filename);
            Response.Redirect("b_AccountInfo.aspx");
        }

        protected void BackToIndexBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("back_Index.aspx");
        }
    }
}