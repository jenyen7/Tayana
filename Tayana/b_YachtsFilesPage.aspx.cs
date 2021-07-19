using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Tayana
{
    public partial class WebForm30 : System.Web.UI.Page
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
                ShowFiles();
            }
            warning.Text = "";
            Filelbl.Text = "";
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

        private void ShowFiles()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable pdfFiles = db.GetSelectedDataTable("yachtsPDFfile", "yachtID", id);
            if (pdfFiles.Rows.Count > 0)
            {
                FilesGrid.DataSource = pdfFiles;
                FilesGrid.DataBind();
                int count = 0;
                foreach (DataRow dataRow in pdfFiles.Rows)
                {
                    CheckBox visibility = FilesGrid.Rows[count].FindControl("visibility") as CheckBox;
                    if (Convert.ToInt32(dataRow["visible"]) == 1)
                    {
                        visibility.Checked = true;
                    }
                    else
                    {
                        visibility.Checked = false;
                    }
                    count++;
                }
            }
            else
            {
                pdfFiles.Rows.Add(pdfFiles.NewRow());
                FilesGrid.DataSource = pdfFiles;
                FilesGrid.DataBind();
                FilesGrid.Rows[0].Cells.Clear();
                FilesGrid.Rows[0].Cells.Add(new TableCell());
                FilesGrid.Rows[0].Cells[0].ColumnSpan = pdfFiles.Columns.Count;
                FilesGrid.Rows[0].Cells[0].Text = "目前沒有任何PDF檔喔";
                FilesGrid.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
            }
        }

        protected void BackToList_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_YachtsList.aspx");
        }

        protected void AddFileBtn_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Helper.CheckUploadFile(FileUpload)))
            {
                Filelbl.Text = Helper.CheckUploadFile(FileUpload);
                Filelbl.ForeColor = System.Drawing.Color.Red;
                return;
            }
            int id = Convert.ToInt32(Request.QueryString["id"]);
            string fileName = DateTime.Now.ToString("yyyyMMdd_") + FileUpload.FileName;
            string contentType = FileUpload.PostedFile.ContentType;
            FileUpload.SaveAs(Server.MapPath("~/assets_tayana/upload/PDFiles/" + fileName));
            Filelbl.Text = "檔案上傳成功";
            Filelbl.ForeColor = System.Drawing.Color.Green;
            db.InsertPDFile(id, FileName.Text, fileName, contentType, 1);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{name.Text}遊艇的PDF檔案");
            ShowFiles();
            FileName.Text = "";
        }

        protected void updateBtn_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in FilesGrid.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int id = Convert.ToInt32(FilesGrid.DataKeys[row.RowIndex].Value);
                    string rename = (row.FindControl("renamePDF") as TextBox).Text;
                    CheckBox visibility = row.FindControl("visibility") as CheckBox;
                    string fileOrder = (row.FindControl("fileOrderBox") as TextBox).Text;
                    for (int i = 0; i < fileOrder.Length; i++)
                    {
                        if (!Char.IsDigit(fileOrder[i]))
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('檔案排放順序只能是整數喔');", true);
                            return;
                        }
                    }
                    if (string.IsNullOrEmpty(rename) || string.IsNullOrEmpty(fileOrder))
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('欄位不能是空的喔');", true);
                        return;
                    }
                    db.UpdatePDFile(id, rename, visibility.Checked, fileOrder);
                }
            }
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{name.Text}遊艇的PDF檔案");
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('資料已儲存');", true);
            ShowFiles();
        }

        protected void deleteBtn_Click(object sender, EventArgs e)
        {
            List<int> FilesToBeDeleted = new List<int>();
            foreach (GridViewRow row in FilesGrid.Rows)
            {
                CheckBox checkbox = row.FindControl("check") as CheckBox;
                if (checkbox.Checked && row.RowType == DataControlRowType.DataRow)
                {
                    int id = Convert.ToInt32(FilesGrid.DataKeys[row.RowIndex].Value);
                    FilesToBeDeleted.Add(id);
                }
            }
            var conn = new SqlConnection(System.Web.Configuration.WebConfigurationManager.ConnectionStrings["tayanaConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand($@"DELETE FROM yachtsPDFfile WHERE id IN ({string.Join<int>(",", FilesToBeDeleted)})", conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了{name.Text}遊艇的PDF檔案");
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('檔案已刪除');", true);
            ShowFiles();
        }

        protected void previewBtn_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            string pdf = FilesGrid.Rows[rowIndex].Cells[2].Text;

            string FilePath = Server.MapPath("~/assets_tayana/upload/PDFiles/" + pdf);
            WebClient User = new WebClient();
            Byte[] FileBuffer = User.DownloadData(FilePath);
            if (FileBuffer != null)
            {
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-length", FileBuffer.Length.ToString());
                Response.BinaryWrite(FileBuffer);
            }
        }
    }
}