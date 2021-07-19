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
    public partial class WebForm6 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInformation.IsPermissionAccess(8))
            {
                Response.Redirect("back_Index.aspx");
            }
            if (!IsPostBack)
            {
                ShowCountries();
            }
            warning.Text = "";
            SuccessMsg.Text = "";
            ErrorMsg.Text = "";
        }

        private void ShowCountries()
        {
            DataTable countriesTable = db.GetAllDataTable("countries", "dateAdded DESC");
            if (countriesTable.Rows.Count > 0)
            {
                countries.DataSource = countriesTable;
                countries.DataBind();
            }
            else
            {
                countriesTable.Rows.Add(countriesTable.NewRow());
                countries.DataSource = countriesTable;
                countries.DataBind();
                countries.Rows[0].Cells.Clear();
                countries.Rows[0].Cells.Add(new TableCell());
                countries.Rows[0].Cells[0].ColumnSpan = countriesTable.Columns.Count;
                countries.Rows[0].Cells[0].Text = "目前沒有任何國家資料";
                countries.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
            }
        }

        protected void countries_RowEditing(object sender, GridViewEditEventArgs e)
        {
            countries.EditIndex = e.NewEditIndex;
            ShowCountries();
        }

        protected void countries_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            countries.EditIndex = -1;
            ShowCountries();
        }

        protected void countries_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(countries.DataKeys[e.RowIndex].Value);
            string countryUpdated = (countries.Rows[e.RowIndex].FindControl("countryBox") as TextBox).Text;
            if (string.IsNullOrEmpty(countryUpdated))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('國家不能是空的喔');", true);
                return;
            }
            db.UpdateCountry(id, countryUpdated);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{countryUpdated}國家");
            countries.EditIndex = -1;
            ShowCountries();
            SuccessMsg.Text = "修改成功!";
        }

        protected void countries_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(countries.DataKeys[e.RowIndex].Value);
            DataTable citiesList = db.GetSelectedDataTable("cities", "countryID", id);
            if (citiesList.Rows.Count > 0)
            {
                warning.Text = "此國家有綁定城市，無法直接刪除，請先行刪除此國家的城市名稱";
                return;
            }
            DataTable table = db.GetSelectedDataTable("countries", "countryID", id);
            db.ExecuteDelete("countries", "countryID", id);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了國家列表中的{table.Rows[0]["country"]}");
            ShowCountries();
            SuccessMsg.Text = "紀錄已刪除";
        }

        protected void insert_btn_Click(object sender, EventArgs e)
        {
            db.InsertCountry(countryInsertBox.Text);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{countryInsertBox.Text}國家");
            ShowCountries();
            SuccessMsg.Text = "新增成功!";
            countryInsertBox.Text = "";
        }
    }
}