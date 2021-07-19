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
    public partial class WebForm14 : System.Web.UI.Page
    {
        private DataBase db = new DataBase();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderCountries();
                RenderDealers();
            }
        }

        private void RenderDealers()
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            DataTable dealersTable = db.GetDealerDataByID("countries.countryID", id);
            if (dealersTable.Rows.Count > 0)
            {
                Repeater_DealersInfo.DataSource = dealersTable;
                Repeater_DealersInfo.DataBind();
            }
            else
            {
                msg.Visible = true;
            }
        }

        private void RenderCountries()
        {
            DataTable countriesTable = db.GetAllDataTable("countries");
            Repeater_LinkCountries.DataSource = countriesTable;
            Repeater_LinkCountries.DataBind();

            int id = Convert.ToInt32(Request.QueryString["id"]);
            foreach (DataRow item in countriesTable.Rows)
            {
                if (Convert.ToInt32(item["countryID"]) == id)
                {
                    country.Text = item["country"].ToString();
                    title.Text = item["country"].ToString();
                }
            }
        }
    }
}