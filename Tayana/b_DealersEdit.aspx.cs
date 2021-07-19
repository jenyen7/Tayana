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
    public partial class WebForm9 : System.Web.UI.Page
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
                LoadCountryDDL();
                ShowHistoryContent();
            }
            warning.Text = "";
            lblmessage.Text = "";
        }

        private void LoadCountryDDL()
        {
            DataTable countries = db.GetAllDataTable("countries");
            DDLcountries.DataSource = countries;
            DDLcountries.DataTextField = "country";
            DDLcountries.DataValueField = "countryID";
            DDLcountries.DataBind();
            DDLcountries.Items.Insert(0, new ListItem("< 請選擇國家 >", "0"));
        }

        private void ShowHistoryContent()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable dealer = db.GetDealerDataByID("id", id);
            DataTable cities = db.GetSelectedDataTable("cities", "countryID", Convert.ToInt32(dealer.Rows[0]["countryID"].ToString()));
            DDLcities.DataSource = cities;
            DDLcities.DataTextField = "city";
            DDLcities.DataValueField = "cityID";
            DDLcities.DataBind();
            DDLcities.Items.Insert(0, new ListItem("< 請選擇城市 >", "0"));

            dealersName.Text = dealer.Rows[0]["dealerName"].ToString();
            contactName.Text = dealer.Rows[0]["dealerContact"].ToString();
            dealersAddress.Text = dealer.Rows[0]["dealerAddress"].ToString();
            dealersTel.Text = dealer.Rows[0]["dealerTel"].ToString();
            dealersFax.Text = dealer.Rows[0]["dealerFax"].ToString();
            dealersEmail.Text = dealer.Rows[0]["dealerEmail"].ToString();
            DDLcountries.SelectedValue = dealer.Rows[0]["countryID"].ToString();
            DDLcities.SelectedValue = dealer.Rows[0]["dealerCity"].ToString();
            hidDealerPic.Value = dealer.Rows[0]["dealerPic"].ToString();
            hidDealerPic.DataBind();
        }

        protected void DDLcountries_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedCountry = Convert.ToInt32(((DropDownList)sender).SelectedValue);
            DDLcities.Items.Clear();

            DataTable cities = db.GetSelectedDataTable("cities", "countryID", selectedCountry);
            DDLcities.DataSource = cities;
            DDLcities.DataTextField = "city";
            DDLcities.DataValueField = "cityID";
            DDLcities.DataBind();
            DDLcities.Items.Insert(0, new ListItem("< 請選擇城市 >", "0"));
        }

        protected void EditDealerBtn_Click(object sender, EventArgs e)
        {
            if (ValidateDealer())
            {
                return;
            }
            string filename;
            if (dealersPic.HasFile)
            {
                filename = DateTime.Now.ToString("yyyyMMddhhmmss") + dealersPic.FileName;
                dealersPic.SaveAs(Server.MapPath("~/assets_tayana/upload/Images/" + filename));
            }
            else
            {
                filename = hidDealerPic.Value;
            }
            int id = Convert.ToInt32(Request.QueryString["id"]);
            db.UpdateDealer(id, dealersName.Text, contactName.Text, dealersAddress.Text, dealersTel.Text, dealersFax.Text, dealersEmail.Text, filename, Convert.ToInt32(DDLcities.SelectedValue));
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"編輯了{dealersName.Text}代理商");

            if (Session["DealersCurrentPage"] != null)
            {
                Response.Redirect("b_DealersList.aspx?page=" + Session["DealersCurrentPage"].ToString());
            }
            else
            {
                Session["searchDealersWord"] = null;
                Session["selectedCountry"] = null;
                Session["selectedCity"] = null;
                Response.Redirect("b_DealersList.aspx");
            }
        }

        protected void BackToList_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_DealersList.aspx");
        }

        private bool ValidateDealer()
        {
            bool flag = false;
            //檢查上傳的圖片
            if (dealersPic.HasFile)
            {
                string msg = Helper.CheckUploadImage(dealersPic);
                if (!string.IsNullOrEmpty(msg))
                {
                    lblmessage.Text = msg;
                    flag = true;
                }
            }
            //檢查email正確性
            if (!Helper.isValidEmail(dealersEmail.Text))
            {
                emaillbl.Text = "Email格式不符";
                flag = true;
            }
            //檢查城市有沒有選
            if (DDLcities.SelectedValue == "0")
            {
                citylbl.Text = "城市必選";
                flag = true;
            }
            return flag;
        }
    }
}