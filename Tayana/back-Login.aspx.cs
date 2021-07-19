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
    public partial class ba_Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void loginBtn_Click(object sender, EventArgs e)
        {
            DataBase dataBase = new DataBase();
            string userData = dataBase.Login(accountID.Text, password.Text);
            if (userData == "loginFailed")
            {
                messagelbl.Text = "帳號或密碼錯誤，請重新輸入。";
            }
            else
            {
                SetAuthenTicket(accountID.Text, userData, rememberMe.Checked);
                Response.Redirect("back_Index.aspx");
            }
        }

        private void SetAuthenTicket(string userName, string userData, bool rememberMe)
        {
            const int userLoggedOnTime = 1;
            //宣告一個驗證票
            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, userName, DateTime.Now, DateTime.Now.AddDays(userLoggedOnTime), rememberMe, userData);
            //加密驗證票
            string encryptedTicket = FormsAuthentication.Encrypt(ticket);
            //建立Cookie
            HttpCookie authenticationCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
            {
                //帳號保留時間
                Expires = DateTime.Now.AddDays(userLoggedOnTime)
            };
            //將Cookie寫入回應
            Response.Cookies.Add(authenticationCookie);
        }
    }
}