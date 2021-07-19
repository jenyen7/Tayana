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
    public partial class WebForm36 : System.Web.UI.Page
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
                AddAttributesToMyCheckboxes();
                ShowHistoryContent();
            }
            warning.Text = "";
            passwordlbl.Text = "";
            avatarlbl.Text = "";
        }

        private void AddAttributesToMyCheckboxes()
        {
            checkedAll.InputAttributes.Add("class", "checkAll");
            AuthAccounts.InputAttributes.Add("class", "checkSingle");
            AuthYachts.InputAttributes.Add("class", "checkSingle");
            AuthDealers.InputAttributes.Add("class", "checkSingle");
            AuthNews.InputAttributes.Add("class", "checkSingle");
            AuthMessages.InputAttributes.Add("class", "checkSingle");
        }

        private void ShowHistoryContent()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable accountHistory = db.GetSelectedDataTable("accounts", "id", id);
            account.Text = accountHistory.Rows[0]["account"].ToString();
            username.Text = accountHistory.Rows[0]["username"].ToString();
            email.Text = accountHistory.Rows[0]["email"].ToString();
            hidAvatar.Value = accountHistory.Rows[0]["avatar"].ToString();
            int permission = Convert.ToInt32(accountHistory.Rows[0]["permissions"]);
            DataTable permissions = db.GetAllDataTable("accountsPermissions");
            foreach (DataRow row in permissions.Rows)
            {
                int permissionID = Convert.ToInt16(row["permissionID"]);
                switch (permission & permissionID)
                {
                    case 1:
                        AuthAccounts.Checked = true;
                        break;

                    case 2:
                        AuthYachts.Checked = true;
                        break;

                    case 4:
                        AuthNews.Checked = true;
                        break;

                    case 8:
                        AuthDealers.Checked = true;
                        break;

                    case 16:
                        AuthMessages.Checked = true;
                        break;
                }
            }
        }

        protected void editAccountBtn_Click(object sender, EventArgs e)
        {
            if (!ValidateInfo())
            {
                return;
            }
            string filename;
            if (avatar.HasFile)
            {
                filename = DateTime.Now.ToString("yyyyMMdd_") + avatar.FileName;
                avatar.SaveAs(Server.MapPath("~/assets/images/" + filename));
            }
            else
            {
                filename = hidAvatar.Value;
            }
            int id = Convert.ToInt32(Request.QueryString["id"]);
            db.UpdateAccountsInfo(id, password.Text, username.Text, email.Text, filename, AuthMessages.Checked, AuthDealers.Checked, AuthNews.Checked, AuthYachts.Checked, AuthAccounts.Checked);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{account.Text}的帳號");

            if (Session["AccountsCurrentPage"] != null)
            {
                Response.Redirect("b_AccountsList.aspx?page=" + Session["AccountsCurrentPage"].ToString());
            }
            else
            {
                Session["searchPermissions"] = null;
                Session["searchAccountsWord"] = null;
                Response.Redirect("b_AccountsList.aspx");
            }
        }

        protected void BackToListBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_AccountsList.aspx");
        }

        private bool ValidateInfo()
        {
            bool flag = true;
            //檢查上傳的圖片
            if (avatar.HasFile)
            {
                string avatarMsg = Helper.CheckUploadImage(avatar);
                if (!string.IsNullOrEmpty(avatarMsg))
                {
                    avatarlbl.Text = avatarMsg;
                    flag = false;
                }
            }
            //檢查密碼正確性
            if (!string.IsNullOrEmpty(password.Text) || !string.IsNullOrEmpty(confirmPassword.Text))
            {
                string passwordMsg = Helper.CheckPassword(password.Text, confirmPassword.Text);
                if (!string.IsNullOrEmpty(passwordMsg))
                {
                    passwordlbl.Text = passwordMsg;
                    flag = false;
                }
            }
            //檢查email正確性
            if (!Helper.isValidEmail(email.Text))
            {
                emaillbl.Text = "Email格式不符";
                flag = false;
            }
            return flag;
        }
    }
}