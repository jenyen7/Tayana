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
    public partial class WebForm31 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ShowTotalNumbers();
                ShowSummary();
                ShowProfile();
                ShowUserAcivities();
            }
        }

        private void ShowTotalNumbers()
        {
            DataTable TotalNumbers = db.GetAllCounts();
            yachtsTotal.Text = TotalNumbers.Rows[0]["ships"].ToString();
            newsTotal.Text = TotalNumbers.Rows[0]["reports"].ToString();
            dealersTotal.Text = TotalNumbers.Rows[0]["dealers"].ToString();
            commentsTotal.Text = TotalNumbers.Rows[0]["comments"].ToString();
        }

        private void ShowSummary()
        {
            DataTable yachts = db.GetTop3Yachts();
            yachts_rpt.DataSource = yachts;
            yachts_rpt.DataBind();

            DataTable news = db.GetTop3News();
            news_rpt.DataSource = news;
            news_rpt.DataBind();

            DataTable dealers = db.GetTop3Dealers();
            dealers_rpt.DataSource = dealers;
            dealers_rpt.DataBind();

            DataTable comments = db.GetTop3Comments();
            comments_rpt.DataSource = comments;
            comments_rpt.DataBind();
        }

        private void ShowProfile()
        {
            string UserData = ((FormsIdentity)(HttpContext.Current.User.Identity)).Ticket.UserData;
            UserInformation thisUser = Newtonsoft.Json.JsonConvert.DeserializeObject<UserInformation>(UserData);
            profilename.Text = thisUser.username;
            profileemail.Text = thisUser.email;
            ImageProfile.ImageUrl = "~/assets/images/" + thisUser.avatar;
            joindate.Text = thisUser.joinedDate;
        }

        private void ShowUserAcivities()
        {
            DataTable userActivities = db.GetUserActivities();
            foreach (DataRow row in userActivities.Rows)
            {
                activitiesLit.Text += $@" <li class='active-feed'><div class='feed-user-img'>
                    <img src='../assets/images/{row["avatar"]}' class='img-radius ' alt='User-Profile-Image'></div>
                    <h6>";
                if (row["userActivity"].ToString().Contains("帳號"))
                {
                    activitiesLit.Text += $@"<span class='label label-danger'>帳號</span>";
                }
                else if (row["userActivity"].ToString().Contains("遊艇"))
                {
                    activitiesLit.Text += $@"<span class='label label-primary'>遊艇</span>";
                }
                else if (row["userActivity"].ToString().Contains("新聞"))
                {
                    activitiesLit.Text += $@"<span class='label label-success'>新聞</span>";
                }
                else
                {
                    activitiesLit.Text += $@"<span class='label label-warning'>代理商</span>";
                }
                DateTime now = DateTime.Now;
                DateTime edit = Convert.ToDateTime(row["modifiedDate"]);
                TimeSpan interval = now - edit;
                string elapse;
                if (interval.Duration().Days > 0)
                {
                    elapse = $@"{interval.Duration().Days}天";
                }
                else if (interval.Duration().Hours < 1)
                {
                    elapse = $@"{interval.Duration().Minutes}分鐘";
                }
                else
                {
                    elapse = $@"{interval.Duration().Hours}小時";
                }
                activitiesLit.Text += $@"{row["username"]} <span class=''>{row["userActivity"]}</span>
                    <small class='text-muted'> 於 {elapse}之前</small></h6></li>";
            }
        }
    }
}