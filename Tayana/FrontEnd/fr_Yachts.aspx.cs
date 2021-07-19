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
    public partial class WebForm15 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderYachts();
                RenderGallery();
                RenderPDFile();
            }
        }

        private void RenderYachts()
        {
            DataTable YachtsTable = db.GetAllDataTable("yachts");
            YachtsList_rpt.DataSource = YachtsTable;
            YachtsList_rpt.DataBind();

            int id = Convert.ToInt32(Request.QueryString["id"]);
            foreach (DataRow row in YachtsTable.Rows)
            {
                if (Convert.ToInt32(row["id"]) == id)
                {
                    string num_str = string.Empty;
                    string name = row["yachtName"].ToString();
                    for (int i = 0; i < name.Length; i++)
                    {
                        if (Char.IsDigit(name[i]))
                            num_str += name[i];
                    }
                    dimension_title.Text = num_str;
                    crumb_name.Text = row["yachtName"].ToString();
                    title_name.Text = row["yachtName"].ToString();
                    overview.Text = row["overview"].ToString();
                    dimensions.Text = row["dimensions"].ToString();
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

        private void RenderPDFile()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable pdfsTable = db.GetPDFList(id);
            if (pdfsTable.Rows.Count > 0)
            {
                PDFlit.Text = @"<p><img src='../assets_tayana/images/downloads.gif' alt=' & quot; &quot;' /></p> ";
                foreach (DataRow row in pdfsTable.Rows)
                {
                    PDFlit.Text += $@"<ul><li><a href='../assets_tayana/upload/PDFiles/{row["fileName"]}' type='{row["fileContentType"]}' target='_blank'>{row["renamePDF"]}</a></li></ul>";
                }
            }
        }
    }
}