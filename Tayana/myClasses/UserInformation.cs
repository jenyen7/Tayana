using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace Tayana
{
    public class UserInformation
    {
        public string account { get; set; }
        public string username { get; set; }
        public string email { get; set; }
        public string avatar { get; set; }
        public int permissions { get; set; }
        public string joinedDate { get; set; }

        public static bool IsPermissionAccess(int thisPagePermission)
        {
            string UserData = ((FormsIdentity)(HttpContext.Current.User.Identity)).Ticket.UserData;
            UserInformation thisUser = Newtonsoft.Json.JsonConvert.DeserializeObject<UserInformation>(UserData);
            if ((thisUser.permissions & thisPagePermission) == 0)
            {
                return false;
            }
            return true;
        }
    }
}