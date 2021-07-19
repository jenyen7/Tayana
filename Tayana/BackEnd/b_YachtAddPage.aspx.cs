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
    public partial class WebForm26 : System.Web.UI.Page
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
                ShowBasicLayout();
            }
            warning.Text = "";
        }

        private void ShowBasicLayout()
        {
            dimensions.Text = @"<table class='table02' style='text-align:left; height:340'><tbody><tr><td class='table02td01'><table><tbody><tr>
            <th style='width:260px'>Hull length</th><td style='width:175px'></td></tr><tr class='tr003'>
            <th>L.W.L.</th><td></td></tr><tr>
            <th>B. MAX</th><td></td></tr><tr class='tr003'>
            <th>Standard draft</th><td></td></tr><tr>
            <th>Ballast</th><td></td></tr><tr class='tr003'>
            <th>Displacement</th><td></td></tr><tr>
            <th>Sail area</th><td></td></tr><tr class='tr003'>
            <th>Cutter</th><td></td></tr><tr>
            <th></th><td></td></tr><tr class='tr003'>
            <th></th><td></td></tr><tr>
            <th></th><td></td></tr><tr class='tr003'>
            <th></th><td></td></tr><tr>
            </tbody></table></td>
            <td style='width:300px'>圖片請放這個格子(圖片放置好後  這行字請刪除)</td></tr></tbody></table>";
            layout.Text = @"<ul><li></li><li></li><li></li></ul>";
            specification.Text = @"<p>HULL</p><ul><li>Hand laid up FRP hull, white with blue cove stripe and boot top.</li><li> Teak rubrail.<br /></li></ul>";
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(checkTextBox()))
            {
                warning.Text = checkTextBox();
                return;
            }
            int id = db.InsertYacht(name.Text, overview.Text, dimensions.Text, layout.Text, specification.Text, checkbox.Checked);
            db.RecordActivity(HttpContext.Current.User.Identity.Name, $@"新增了{name.Text}遊艇型號");
            Response.Redirect($"b_YachtsGalleryPage.aspx?id={id}");
        }

        protected void BackToList_Click(object sender, EventArgs e)
        {
            Response.Redirect("b_YachtsList.aspx");
        }

        private string checkTextBox()
        {
            string warning = "";
            if (string.IsNullOrEmpty(name.Text))
            {
                warning += "遊艇型號必填, ";
            }
            if (string.IsNullOrEmpty(overview.Text))
            {
                warning += "遊艇簡介必填, ";
            }
            if (string.IsNullOrEmpty(dimensions.Text))
            {
                warning += "遊艇尺寸必填, ";
            }
            if (string.IsNullOrEmpty(layout.Text))
            {
                warning += "遊艇剖面結構圖必須提供喔, ";
            }
            if (string.IsNullOrEmpty(specification.Text))
            {
                warning += "遊艇規格必填 ";
            }
            return warning;
        }
    }
}