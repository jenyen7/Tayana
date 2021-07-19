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
    public partial class WebForm5 : System.Web.UI.Page
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
                LoadCountriesDDL();
                ShowDealers();
            }
            warning.Text = "";
        }

        private void LoadCountriesDDL()
        {
            DataTable countries = db.GetAllDataTable("countries");
            searchByCountry.DataSource = countries;
            searchByCountry.DataTextField = "country";
            searchByCountry.DataValueField = "countryID";
            searchByCountry.DataBind();
            searchByCountry.Items.Insert(0, new ListItem("< 請選擇國家 >", "0"));
            searchByCity.Items.Insert(0, new ListItem("< 請選擇城市 >", "0"));
        }

        private void ShowDealers()
        {
            if (Session["searchDealersWord"] != null && Session["selectedCountry"] != null && Session["selectedCity"] != null)
            {
                searchBox.Text = Session["searchDealersWord"].ToString();
                searchByCountry.SelectedValue = Session["selectedCountry"].ToString();
                LoadSelectedCountryCitiesDDL();
                searchByCity.SelectedValue = Session["selectedCity"].ToString();
                ShowSearchingResult();
            }
            else if (Session["selectedCity"] != null && Session["selectedCountry"] != null && Session["selectedCity"] == null)
            {
                searchByCountry.SelectedValue = Session["selectedCountry"].ToString();
                LoadSelectedCountryCitiesDDL();
                searchByCity.SelectedValue = Session["selectedCity"].ToString();
                ShowSearchingResult();
            }
            else if (Session["selectedCountry"] != null && Session["searchDealersWord"] != null)
            {
                searchBox.Text = Session["searchDealersWord"].ToString();
                searchByCountry.SelectedValue = Session["selectedCountry"].ToString();
                LoadSelectedCountryCitiesDDL();
                ShowSearchingResult();
            }
            else if (Session["searchDealersWord"] != null)
            {
                searchBox.Text = Session["searchDealersWord"].ToString();
                ShowSearchingResult();
            }
            else
            {
                PagingControl.targetpage = "b_DealersList.aspx";
                PagingControl.limit = 5;
                PagingControl.totalitems = db.GetTotalPagesCount("dealers");
                string currentPage = Request.QueryString["page"];
                DataTable dealersTable = db.GetDealersPagingData(currentPage, PagingControl.limit);
                Dealers.DataSource = dealersTable;
                Dealers.DataBind();
                PagingControl.showPageControls();
            }
        }

        protected void searchByCountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            searchByCity.Items.Clear();
            LoadSelectedCountryCitiesDDL();
        }

        private void LoadSelectedCountryCitiesDDL()
        {
            int countryID = Convert.ToInt32(searchByCountry.SelectedValue);
            DataTable cities = db.GetSelectedDataTable("cities", "countryID", countryID);
            searchByCity.DataSource = cities;
            searchByCity.DataTextField = "city";
            searchByCity.DataValueField = "cityID";
            searchByCity.DataBind();
            searchByCity.Items.Insert(0, new ListItem("< 請選擇城市 >", "0"));
        }

        protected void searchBtn_Click(object sender, EventArgs e)
        {
            if (searchByCountry.SelectedValue == "0" && searchByCity.SelectedValue == "0" && string.IsNullOrEmpty(searchBox.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + "請至少輸入一種搜尋模式喔" + "');", true);
                return;
            }
            Session["selectedCountry"] = searchByCountry.SelectedValue;
            Session["selectedCity"] = searchByCity.SelectedValue;
            Session["searchDealersWord"] = searchBox.Text;
            Response.Redirect("b_DealersList.aspx");
            ShowSearchingResult();
        }

        private void ShowSearchingResult()
        {
            PagingControl.targetpage = "b_DealersList.aspx";
            PagingControl.limit = 5;
            PagingControl.totalitems = db.GetSelectedDealersTotalPageCount(searchByCountry.SelectedValue, searchByCity.SelectedValue, searchBox.Text);
            string currentPage = Request.QueryString["page"];
            DataTable dealers = db.GetSelectedDealersPagingData(currentPage, PagingControl.limit, searchByCountry.SelectedValue, searchByCity.SelectedValue, searchBox.Text);
            if (dealers.Rows.Count > 0)
            {
                Dealers.DataSource = dealers;
                Dealers.DataBind();
            }
            else
            {
                noSearchingResultlbl.Visible = true;
            }
            PagingControl.showPageControls();
        }

        protected void Dealers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Edit")
            {
                if (Session["searchDealersWord"] == null && Session["selectedCountry"] == null && Session["selectedCity"] == null)
                {
                    string currentPage = Request.QueryString["page"];
                    if (!string.IsNullOrEmpty(currentPage))
                    {
                        Session["DealersCurrentPage"] = currentPage;
                    }
                }
                Response.Redirect("b_DealersEdit.aspx?id=" + id);
            }
            else if (e.CommandName == "Delete")
            {
                DataTable table = db.GetSelectedDataTable("dealers", "id", id);
                db.ExecuteDelete("dealers", "id", id);
                db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"刪除了代理商列表中的{table.Rows[0]["dealerName"]}");
                ShowDealers();
            }
            else if (e.CommandName == "GetInfo")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                DataTable dealersInfo = db.GetAllDataTable("dealers");
                foreach (DataRow item in dealersInfo.Rows)
                {
                    if (Convert.ToInt32(item["id"]) == id)
                    {
                        Tel.Text = item["dealerTel"].ToString();
                        Fax.Text = item["dealerFax"].ToString();
                        Email.Text = item["dealerEmail"].ToString();
                        Address.Text = item["dealerAddress"].ToString();
                    }
                }
            }
        }

        protected void Dealers_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                RepeaterItem item = e.Item;
                string city = (item.FindControl("city") as Label).Text;
                string dealerName = (item.FindControl("dealerName") as Label).Text;
                if (city.Length > 22)
                {
                    string city_br = "";
                    for (int i = 0; i < city.Length; i++)
                    {
                        city_br += city[i];
                        if (i == 22)
                        {
                            city_br += "</br>";
                        }
                    }
                    (item.FindControl("city") as Label).Text = city_br;
                }
                if (dealerName.Length > 22)
                {
                    string name_br = "";
                    for (int i = 0; i < dealerName.Length; i++)
                    {
                        name_br += dealerName[i];
                        if (i == 22)
                        {
                            name_br += "</br>";
                        }
                    }
                    (item.FindControl("dealerName") as Label).Text = name_br;
                }
            }
        }

        protected void AddDealerBtn_Click(object sender, EventArgs e)
        {
            Session["searchDealersWord"] = null;
            Session["selectedCountry"] = null;
            Session["selectedCity"] = null;
            Response.Redirect("b_DealersAdd.aspx");
        }

        protected void BackToIndexBtn_Click(object sender, EventArgs e)
        {
            Session["searchDealersWord"] = null;
            Session["selectedCountry"] = null;
            Session["selectedCity"] = null;
            Response.Redirect("back_Index.aspx");
        }

        protected void clearSearch_Click(object sender, ImageClickEventArgs e)
        {
            Session["searchDealersWord"] = null;
            Session["selectedCountry"] = null;
            Session["selectedCity"] = null;
            Response.Redirect("b_DealersList.aspx");
        }
    }
}