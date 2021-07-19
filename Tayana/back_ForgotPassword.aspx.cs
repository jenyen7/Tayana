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
    public partial class back_ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            messagelbl.Text = "";
        }

        protected void changePasswordBtn_Click(object sender, EventArgs e)
        {
            //SqlConnection conn = DataBase.Connect("tayanaConnectionString");
            //DataTable userInfo = DataBase.GetDataTable(conn, $@"SELECT * FROM accounts WHERE (account='{accountID.Text}') AND (email='{email.Text}')");
            //if (userInfo.Rows.Count > 0)
            //{
            //    if (!string.IsNullOrEmpty(checkPasswords()))
            //    {
            //        return;
            //    }
            //    try
            //    {
            //        SqlCommand sqlCommand = new SqlCommand($@"UPDATE accounts SET password='{Helper.MD5password(password.Text)}' WHERE account='{accountID.Text}'", conn);
            //        conn.Open();
            //        sqlCommand.ExecuteNonQuery();
            //        conn.Close();
            //        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "sweetAlert();", true);
            //    }
            //    catch (Exception ex)
            //    {
            //        messagelbl.Text = ex.Message;
            //    }
            //}
            //else
            //{
            //    messagelbl.Text = "帳號或Email錯誤，請重新輸入。";
            //}
        }

        private string checkPasswords()
        {
            string message = "";
            if (password.Text.Length < 5)
            {
                messagelbl.Text = "密碼太短了,至少要五位數喔</br>";
                message += "密碼不OK,";
            }
            if (password.Text != confirmPassword.Text)
            {
                messagelbl.Text += "確認密碼不符喔";
                message += "密碼還是不OK,";
            }
            message = message.Trim(',');
            return message;
        }
    }
}