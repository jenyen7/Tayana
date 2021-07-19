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
    public partial class WebForm22 : System.Web.UI.Page
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
            }
            warning.Text = "";
            accountlbl.Text = "";
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

        protected void addAccountBtn_Click(object sender, EventArgs e)
        {
            if (!ValidateInfo())
            {
                return;
            }
            string filename = "";
            if (avatar.HasFile)
            {
                filename = DateTime.Now.ToString("yyyyMMdd_") + avatar.FileName;
                avatar.SaveAs(Server.MapPath("~/assets/images/" + filename));
            }
            db.InsertAccountsInfo(account.Text, password.Text, username.Text, email.Text, filename, AuthMessages.Checked, AuthDealers.Checked, AuthNews.Checked, AuthYachts.Checked, AuthAccounts.Checked);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{account.Text}的帳號");
            Response.Redirect("b_AccountsList.aspx");
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
            //檢查帳號是否有重複
            DataRow row = db.CheckDuplicateAccount(account.Text);
            if (row != null)
            {
                accountlbl.Text = "此帳號已經有人使用過了";
                flag = false;
            }
            //檢查密碼正確性
            string passwordMsg = Helper.CheckPassword(password.Text, confirmPassword.Text);
            if (!string.IsNullOrEmpty(passwordMsg))
            {
                passwordlbl.Text = passwordMsg;
                flag = false;
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