using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Tayana
{
    public partial class Site2 : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                Response.Redirect("back-Login.aspx");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ShowInfo();
            }
        }

        private void ShowInfo()
        {
            DataBase db = new DataBase();
            string UserData = ((FormsIdentity)(HttpContext.Current.User.Identity)).Ticket.UserData;
            UserInformation thisUser = Newtonsoft.Json.JsonConvert.DeserializeObject<UserInformation>(UserData);
            userID.Text = thisUser.username;
            avatarImg.ImageUrl = "~/assets/images/" + thisUser.avatar;

            DataTable permissions = db.GetAllDataTable("accountsPermissions");
            int thisPermission = thisUser.permissions;
            if (thisPermission > 0)
            {
                links.Text += "<div class='pcoded-navigatio-lavel' data-i18n='nav.category.forms'>後台管理</div><ul class='pcoded-item pcoded-left-item'>";
                foreach (DataRow row in permissions.Rows)
                {
                    int permissionsAccess = Convert.ToInt16(row["permissionID"]);
                    string[] permissionsArray = row["permission"].ToString().Split(',');
                    if ((thisPermission & permissionsAccess) > 0 && permissionsArray.Length > 1)
                    {
                        string[] urlArray = row["url"].ToString().Split(',');
                        links.Text += $@"<li class='pcoded-hasmenu'><a href='javascript:void(0)'><span class='pcoded-micon'>{row["url_icon"]}</span><span class='pcoded-mtext'>{permissionsArray[0]}</span><span class='pcoded-mcaret'></span></a>
                                           <ul class='pcoded-submenu'>";
                        for (int i = 0; i < permissionsArray.Length; i++)
                        {
                            links.Text += $@"<li><a href='{urlArray[i]}'><span class='pcoded-micon'><i class='ti-angle-right'></i></span><span class='pcoded-mtext'>{permissionsArray[i]}</span><span class='pcoded-mcaret'></span></a></li>";
                        }
                        links.Text += @"</ul>";
                    }
                    else if ((thisPermission & permissionsAccess) > 0)
                    {
                        links.Text += $@"<li><a href='{row["url"]}'><span class='pcoded-micon'>{row["url_icon"]}</span><span class='pcoded-mtext'>{row["permission"]}</span><span class='pcoded-mcaret'></span></a></li>";
                    }
                }
                links.Text += "</ul>";
            }

            DataTable comments = db.GetTop3Comments();
            foreach (DataRow row in comments.Rows)
            {
                DateTime now = DateTime.Now;
                DateTime sent = Convert.ToDateTime(row["sentDate"]);
                TimeSpan interval = now - sent;
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
                recentMessageslit.Text += $@"<li><div class='media'><div class='media-body'><h5 class='notification-user'>[{row["country"]}] {row["name"]}</h5><p class='notification-msg'>詢問{row["brochure"]}目錄</p>
                                                <span class='notification-time'>{elapse}之前</span></div></div></li>";
            }
            //if (Request.Cookies["Permissions"] == null)
            //{
            //    Response.Cookies["Permissions"].Value = thisUser.permissions.ToString();
            //    Response.Cookies["Permissions"].Expires = DateTime.Now.AddDays(1);
            //}
        }

        protected void LogoutBtn_Click(object sender, EventArgs e)
        {
            if (Request.Cookies["Permissions"] != null)
            {
                Response.Cookies["Permissions"].Expires = DateTime.Now.AddDays(-1);
            }
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("back-Login.aspx");
        }
    }
}