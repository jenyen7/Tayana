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
    public partial class mainPage : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderbannerImg();
                RenderTopNews();
            }
        }

        private void RenderbannerImg()
        {
            DataTable galleryTable = db.GetIndexGallery();
            Repeater_banner.DataSource = galleryTable;
            Repeater_banner.DataBind();
            foreach (DataRow row in galleryTable.Rows)
            {
                banner_img.Text += $@"<li><div><p class='bannerimg_p'><img src='assets_tayana/upload/Images/small_images/s{row["imageName"]}' alt='{row["imageAlt"]}' /></p></div></li>";
            }
        }

        private void RenderTopNews()
        {
            DataTable newsTable = db.GetTop3News();
            Repeater_TopNews.DataSource = newsTable;
            Repeater_TopNews.DataBind();
        }
    }
}