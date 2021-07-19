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
    public partial class WebForm35 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                account.Text = HttpContext.Current.User.Identity.Name;
            }
            warning.Text = "";
            passwordlbl.Text = "";
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            string passwordMsg = Helper.CheckPassword(password.Text, confirmPassword.Text);
            if (!string.IsNullOrEmpty(passwordMsg))
            {
                passwordlbl.Text = passwordMsg;
                return;
            }
            db.UpdatePassword(HttpContext.Current.User.Identity.Name, password.Text);
        }

        protected void BackToIndexBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("back_Index.aspx");
        }
    }
}