using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace Tayana
{
    public partial class WebForm16 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();
        protected static string ReCaptcha_Key = ConfigurationManager.AppSettings["ReCaptcha_Key"].ToString();
        protected static string ReCaptcha_Secret = ConfigurationManager.AppSettings["ReCaptcha_Secret"].ToString();

        [WebMethod]
        public static string VerifyCaptcha(string response)
        {
            string url = "https://www.google.com/recaptcha/api/siteverify?secret=" + ReCaptcha_Secret + "&response=" + response;
            return (new WebClient()).DownloadString(url);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderDDL();
            }
        }

        private void RenderDDL()
        {
            DataTable countriesTable = db.GetAllDataTable("countries");
            Country.DataSource = countriesTable;
            Country.DataTextField = "country";
            Country.DataValueField = "countryID";
            Country.DataBind();

            DataTable yachtsTable = db.GetAllDataTable("yachts");
            Yachts.DataSource = yachtsTable;
            Yachts.DataTextField = "yachtName";
            Yachts.DataValueField = "id";
            Yachts.DataBind();
        }

        protected void sendEmail_Click(object sender, ImageClickEventArgs e)
        {
            if (!string.IsNullOrEmpty(checkIfEmpty()))
            {
                msg.Text = checkIfEmpty();
                return;
            }
            try
            {
                string body = PopulateBody(Name.Text.Trim(), "我們已收到您的訊息，將會盡快回覆您。", "您索取的目錄:", Yachts.SelectedItem.Text);
                Helper.SendHtmlFormattedEmail(Email.Text.Trim(), "Tayana遊艇", body);
                string body2 = PopulateBody("Jen", "有新的客戶通知喔~", $"來自{Country.SelectedItem.Text}的{Name.Text.Trim()}申請以下目錄:", Yachts.SelectedItem.Text + "<br/><br/>他的聯繫方式:<br/>" + Email.Text + "<br/>" + Phone.Text + "<br/>" + Comments.Text);
                Helper.SendHtmlFormattedEmail("tryphenayen@gmail.com", "Tayana遊艇新訊息通知", body2);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "successAlert();", true);
                db.InsertMessage(Name.Text, Email.Text, Phone.Text, Country.SelectedItem.Text, Yachts.SelectedItem.Text, Comments.Text);
            }
            catch (Exception)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "failureAlert();", true);
            }
            msg.Text = "";
            Name.Text = "";
            Email.Text = "";
            Phone.Text = "";
            Country.ClearSelection();
            Yachts.ClearSelection();
            Comments.Text = "";
        }

        private string PopulateBody(string userName, string content, string title, string description)
        {
            string body = string.Empty;
            using (StreamReader reader = new StreamReader(Server.MapPath("~/HtmlPage_forEmail.html")))
            {
                body = reader.ReadToEnd();
            }
            body = body.Replace("{UserName}", userName);
            body = body.Replace("{Title}", title);
            body = body.Replace("{Content}", content);
            body = body.Replace("{Description}", description);
            return body;
        }

        private string checkIfEmpty()
        {
            string message = "";
            if (string.IsNullOrEmpty(Name.Text))
            {
                message += "名字必填,";
            }
            if (string.IsNullOrEmpty(Email.Text))
            {
                message += "Email必填,";
            }
            if (!Helper.isValidEmail(Email.Text.Trim()))
            {
                message += "Email格式錯誤，請重新輸入";
            }
            if (string.IsNullOrEmpty(Phone.Text))
            {
                message += "電話必填,";
            }
            if (Country.SelectedValue == "0")
            {
                message += "國家必填,";
            }
            if (Yachts.SelectedValue == "0")
            {
                message += "遊艇型號必填,";
            }
            message.Trim(',');
            return message;
        }
    }
}