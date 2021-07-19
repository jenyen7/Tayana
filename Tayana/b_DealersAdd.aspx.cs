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
    public partial class WebForm10 : System.Web.UI.Page
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
                LoadDDL();
            }
            warning.Text = "";
            lblmessage.Text = "";
        }

        private void LoadDDL()
        {
            DataTable countries = db.GetAllDataTable("countries");
            DDLcountries.DataSource = countries;
            DDLcountries.DataTextField = "country";
            DDLcountries.DataValueField = "countryID";
            DDLcountries.DataBind();
            DDLcountries.Items.Insert(0, new ListItem("< 請選擇國家 >", "0"));
            DDLcities.Items.Insert(0, new ListItem("< 請選擇城市 >", "0"));
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

        protected void AddDealerBtn_Click(object sender, EventArgs e)
        {
            if (ValidateDealer())
            {
                return;
            }
            string filename = DateTime.Now.ToString("yyyyMMddhhmmss") + dealersPic.FileName;
            dealersPic.SaveAs(Server.MapPath("~/assets_tayana/upload/Images/" + filename));
            db.InsertDealer(dealersName.Text, contactName.Text, dealersAddress.Text, dealersTel.Text, dealersFax.Text, dealersEmail.Text, filename, Convert.ToInt32(DDLcities.SelectedValue));
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{dealersName.Text}代理商");
            Response.Redirect("b_DealersList.aspx");
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