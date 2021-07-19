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
    public partial class WebForm2 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInformation.IsPermissionAccess(4))
            {
                Response.Redirect("back_Index.aspx");
            }
            if (!IsPostBack)
            {
                postDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
            warning.Text = "";
            lblmessage.Text = "";
            check_newsContent.Text = "";
        }

        protected void PostNews_Click(object sender, EventArgs e)
        {
            if (ValidateNews())
            {
                return;
            }
            string filename = DateTime.Now.ToString("yyyyMMddhhmmss") + newsCoverPic.FileName;
            newsCoverPic.SaveAs(Server.MapPath("~/assets_tayana/upload/Images/" + filename));
            db.InsertNews(newsTitle.Text, newsSubs.Text, filename, newsContent.Text, pin.Checked);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{newsTitle.Text}新聞");
            Response.Redirect("b_NewsList.aspx");
        }

        private bool ValidateNews()
        {
            bool flag = false;
            if (string.IsNullOrEmpty(newsContent.Text))
            {
                check_newsContent.Text = "這邊必填喔";
                flag = true;
            }
            string imageMsg = Helper.CheckUploadImage(newsCoverPic);
            if (!string.IsNullOrEmpty(imageMsg))
            {
                lblmessage.Text = imageMsg;
                flag = true;
            }
            DataTable checkPinned = db.GetSelectedDataTable("news", "pinned", 1);
            if (checkPinned.Rows.Count > 2 && pin.Checked)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('已經達到新聞置頂上限(3個)了喔，請先移除其他新聞的置頂設定，謝謝');", true);
                flag = true;
            }
            return flag;
        }

        protected void BackToList_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_NewsList.aspx");
        }
    }
}