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
    public partial class WebForm29 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInformation.IsPermissionAccess(2))
            {
                Response.Redirect("back_Index.aspx");
            }
            if (!IsPostBack)
            {
                ShowYachtInfo();
                ShowGallery();
            }
            warning.Text = "";
            Imagelbl.Text = "";
        }

        private void ShowYachtInfo()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable yacht = db.GetSelectedDataTable("yachts", "id", id);
            name.Text = yacht.Rows[0]["yachtName"].ToString();
            switch (Convert.ToInt32(yacht.Rows[0]["newest"]))
            {
                case 0:
                    checkbox.Checked = false;
                    break;

                case 1:
                    checkbox.Checked = true;
                    break;
            }
        }

        private void ShowGallery()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable pictures = db.GetSelectedDataTable("yachtsGallery", "yachtID", id);
            if (pictures.Rows.Count > 0)
            {
                ImagesGrid.DataSource = pictures;
                ImagesGrid.DataBind();
            }
            else
            {
                pictures.Rows.Add(pictures.NewRow());
                ImagesGrid.DataSource = pictures;
                ImagesGrid.DataBind();
                ImagesGrid.Rows[0].Cells.Clear();
                ImagesGrid.Rows[0].Cells.Add(new TableCell());
                ImagesGrid.Rows[0].Cells[0].ColumnSpan = pictures.Columns.Count;
                ImagesGrid.Rows[0].Cells[0].Text = "目前沒有任何照片喔";
                ImagesGrid.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
            }
        }

        protected void BackToList_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_YachtsList.aspx");
        }

        protected void AddImageBtn_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Helper.CheckUploadImage(ImageUpload)))
            {
                Imagelbl.Text = Helper.CheckUploadImage(ImageUpload);
                Imagelbl.ForeColor = System.Drawing.Color.Red;
                return;
            }
            int id = Convert.ToInt32(Request.QueryString["id"]);
            string imageName = DateTime.Now.ToString("yyyyMMddhh") + ImageUpload.FileName;
            ImageUpload.SaveAs(Server.MapPath("~/assets_tayana/upload/Images/" + imageName));
            Imagelbl.Text = "照片上傳成功";
            Imagelbl.ForeColor = System.Drawing.Color.Green;
            db.InsertYachtPhoto(id, imageName, ImageAlt.Text);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{name.Text}遊艇的照片");
            Helper helper = new Helper();
            helper.GenerateThumbnailImage(imageName, @"C:\Users\Jen\source\repos\Tayana\Tayana\assets_tayana\upload\Images", @"C:\Users\Jen\source\repos\Tayana\Tayana\assets_tayana\upload\Images\small_images", "s", 60);
            ShowGallery();
            ImageAlt.Text = "";
        }

        protected void updateBtn_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in ImagesGrid.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int id = Convert.ToInt32(ImagesGrid.DataKeys[row.RowIndex].Value);
                    string imageAlt = (row.FindControl("imageAltBox") as TextBox).Text;
                    string imageOrder = (row.FindControl("imageOrderBox") as TextBox).Text;
                    for (int i = 0; i < imageOrder.Length; i++)
                    {
                        if (!Char.IsDigit(imageOrder[i]))
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('照片輪播順序只能是整數喔');", true);
                            return;
                        }
                    }
                    if (string.IsNullOrEmpty(imageAlt) || string.IsNullOrEmpty(imageOrder))
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('欄位不能是空的喔');", true);
                        return;
                    }
                    db.UpdateYachtPhoto(id, imageAlt, imageOrder);
                }
            }
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{name.Text}遊艇的照片");
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('資料已儲存');", true);
            ShowGallery();
        }

        protected void deleteBtn_Click(object sender, EventArgs e)
        {
            List<int> PicsToBeDeleted = new List<int>();
            foreach (GridViewRow row in ImagesGrid.Rows)
            {
                CheckBox checkbox = row.FindControl("check") as CheckBox;
                if (checkbox.Checked && row.RowType == DataControlRowType.DataRow)
                {
                    int id = Convert.ToInt32(ImagesGrid.DataKeys[row.RowIndex].Value);
                    PicsToBeDeleted.Add(id);
                }
            }
            var conn = new SqlConnection(System.Web.Configuration.WebConfigurationManager.ConnectionStrings["tayanaConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand($@"DELETE FROM yachtsGallery WHERE id IN ({string.Join<int>(",", PicsToBeDeleted)})", conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了{name.Text}遊艇的照片");
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('照片已刪除');", true);
            ShowGallery();
        }
    }
}