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
    public partial class WebForm4 : System.Web.UI.Page
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
                ShowHistoryContent();
            }
            warning.Text = "";
            lblmessage.Text = "";
            check_newsContent.Text = "";
        }

        private void ShowHistoryContent()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable news = db.GetSelectedDataTable("news", "id", id);
            switch (Convert.ToInt32(news.Rows[0]["pinned"]))
            {
                case 0:
                    pin.Checked = false;
                    break;

                case 1:
                    pin.Checked = true;
                    break;
            }
            postDate.Text = Convert.ToDateTime(news.Rows[0]["postDate"]).ToString("yyyy-MM-dd");
            newsTitle.Text = news.Rows[0]["newsTitle"].ToString();
            newsSubs.Text = news.Rows[0]["newsSubs"].ToString();
            newsContent.Text = news.Rows[0]["newsContent"].ToString();
            hidCoverPic.Value = news.Rows[0]["newsCoverPic"].ToString();
            hidCoverPic.DataBind();
        }

        protected void EditNews_Click(object sender, EventArgs e)
        {
            if (ValidateNews())
            {
                return;
            }
            string filename;
            if (newsCoverPic.HasFile)
            {
                filename = DateTime.Now.ToString("yyyyMMddhhmmss") + newsCoverPic.FileName;
                newsCoverPic.SaveAs(Server.MapPath("~/assets_tayana/upload/Images/" + filename));
            }
            else
            {
                filename = hidCoverPic.Value;
            }
            int id = Convert.ToInt32(Request.QueryString["id"]);
            db.UpdateNews(id, newsTitle.Text, newsSubs.Text, filename, newsContent.Text, pin.Checked);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{newsTitle.Text}新聞");

            if (Session["NewsCurrentPage"] != null)
            {
                Response.Redirect("b_NewsList.aspx?page=" + Session["NewsCurrentPage"].ToString());
            }
            else
            {
                Session["searchNewsWord"] = null;
                Session["searchStartDate"] = null;
                Session["searchEndDate"] = null;
                Response.Redirect("b_NewsList.aspx");
            }
        }

        private bool ValidateNews()
        {
            bool flag = false;
            if (string.IsNullOrEmpty(newsContent.Text))
            {
                check_newsContent.Text = "這邊必填喔";
                flag = true;
            }
            if (newsCoverPic.HasFile)
            {
                string imageMsg = Helper.CheckUploadImage(newsCoverPic);
                if (!string.IsNullOrEmpty(imageMsg))
                {
                    lblmessage.Text = imageMsg;
                    flag = true;
                }
            }
            DataTable checkPinned = db.GetSelectedDataTable("news", "pinned", 1);
            if (checkPinned.Rows.Count > 2 && pin.Checked)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('已經達到新聞置頂上限(3個)了喔，請先移除其他新聞的置頂設定，謝謝');", true);
                flag = true;
            }
            return flag;
        }

        protected void BackToListBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_NewsList.aspx");
        }
    }
}