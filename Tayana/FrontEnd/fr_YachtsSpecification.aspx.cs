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
    public partial class WebForm18 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderYachtsSpecification();
                RenderGallery();
            }
        }

        private void RenderYachtsSpecification()
        {
            DataTable YachtsTable = db.GetAllDataTable("yachts");
            YachtsList_rpt.DataSource = YachtsTable;
            YachtsList_rpt.DataBind();

            int id = Convert.ToInt32(Request.QueryString["id"]);
            foreach (DataRow row in YachtsTable.Rows)
            {
                if (Convert.ToInt32(row["id"]) == id)
                {
                    crumb_name.Text = row["yachtName"].ToString();
                    title_name.Text = row["yachtName"].ToString();
                    specification.Text = row["specification"].ToString();
                }
            }
        }

        private void RenderGallery()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable photosTable = db.GetYachtsGallery(id);
            if (photosTable.Rows.Count > 0)
            {
                Gallerylit.Text += @"<div id='gallery' class='ad-gallery'><div class='ad-image-wrapper'></div><div class='ad-controls'></div>
                                        <div class='ad-nav'><div class='ad-thumbs'><ul class='ad-thumb-list'>";
                foreach (DataRow row in photosTable.Rows)
                {
                    Gallerylit.Text += $@"<li><a href='../assets_tayana/upload/Images/{row["imageName"]}' alt='{row["imageAlt"]}'><img src='../assets_tayana/upload/Images/small_images/s{row["imageName"]}' class='image0' /></a></li>";
                }
                Gallerylit.Text += @"</ul></div></div></div>";
            }
            else
            {
                Gallerylit.Text = @"<img src='../assets_tayana/images/indexbanner.jpg' />";
            }
        }
    }
}