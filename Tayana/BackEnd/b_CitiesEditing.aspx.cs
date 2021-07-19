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
    public partial class WebForm7 : System.Web.UI.Page
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
                ShowCities();
                LoadCountriesDDL();
            }
            warning.Text = "";
            SuccessMsg.Text = "";
            ErrorMsg.Text = "";
        }

        private void ShowCities()
        {
            DataTable citiesTable = db.GetCitiesDataTable();
            if (citiesTable.Rows.Count > 0)
            {
                cities.DataSource = citiesTable;
                cities.DataBind();
            }
            else
            {
                citiesTable.Rows.Add(citiesTable.NewRow());
                cities.DataSource = citiesTable;
                cities.DataBind();
                cities.Rows[0].Cells.Clear();
                cities.Rows[0].Cells.Add(new TableCell());
                cities.Rows[0].Cells[0].ColumnSpan = citiesTable.Columns.Count;
                cities.Rows[0].Cells[0].Text = "目前沒有任何城市資料";
                cities.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
            }
        }

        private void LoadCountriesDDL()
        {
            DataTable countriesTable = db.GetAllDataTable("countries");
            countriesSelect.DataSource = countriesTable;
            countriesSelect.DataTextField = "country";
            countriesSelect.DataValueField = "countryID";
            countriesSelect.DataBind();
            countriesSelect.Items.Insert(0, new ListItem("< 請選取國家 >", "0"));
        }

        protected void cities_RowEditing(object sender, GridViewEditEventArgs e)
        {
            cities.EditIndex = e.NewEditIndex;
            ShowCities();
        }

        protected void cities_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            cities.EditIndex = -1;
            ShowCities();
        }

        protected void cities_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(cities.DataKeys[e.RowIndex].Value);
            int countryID = Convert.ToInt32((cities.Rows[e.RowIndex].FindControl("countryDrop") as DropDownList).SelectedValue);
            string city = (cities.Rows[e.RowIndex].FindControl("cityBox") as TextBox).Text;
            if (string.IsNullOrEmpty(city))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('城市不能是空的喔');", true);
                return;
            }
            db.UpdateCity(id, city, countryID);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{city}城市");
            cities.EditIndex = -1;
            ShowCities();
            SuccessMsg.Text = "修改成功!";
        }

        protected void cities_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(cities.DataKeys[e.RowIndex].Value);
            DataTable dealersList = db.GetSelectedDataTable("dealers", "dealerCity", id);
            if (dealersList.Rows.Count > 0)
            {
                warning.Text = "此城市有綁定代理商，無法直接刪除，請先刪除位於這城市的代理商";
                return;
            }
            DataTable table = db.GetSelectedDataTable("cities", "cityID", id);
            db.ExecuteDelete("cities", "cityID", id);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了城市列表中的{table.Rows[0]["city"]}");
            ShowCities();
            SuccessMsg.Text = "紀錄已刪除";
        }

        protected void insert_btn_Click(object sender, EventArgs e)
        {
            if (countriesSelect.SelectedValue == "0")
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + "請選擇國家喔" + "');", true);
                return;
            }
            db.InsertCity(cityInsertBox.Text, Convert.ToInt32(countriesSelect.SelectedValue));
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{cityInsertBox.Text}城市");
            ShowCities();
            SuccessMsg.Text = "新增成功!";
            cityInsertBox.Text = "";
            countriesSelect.ClearSelection();
        }

        protected void cities_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && cities.EditIndex == e.Row.RowIndex)
            {
                DropDownList ddlCountries = (DropDownList)e.Row.FindControl("countryDrop");
                DataTable countriesTable = db.GetAllDataTable("countries");
                ddlCountries.DataSource = countriesTable;
                ddlCountries.DataTextField = "country";
                ddlCountries.DataValueField = "countryID";
                ddlCountries.DataBind();
                ddlCountries.SelectedValue = DataBinder.Eval(e.Row.DataItem, "countryID").ToString();
            }
        }
    }
}