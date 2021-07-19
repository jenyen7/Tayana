using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

namespace Tayana
{
    public class Helper
    {
        public static string CheckUploadImage(FileUpload ImageUploaded)
        {
            string message = "";
            if (ImageUploaded.HasFile)
            {
                string fileExtension = Path.GetExtension(ImageUploaded.FileName);
                if (fileExtension.ToLower() != ".png" && fileExtension.ToLower() != ".jpg" && fileExtension.ToLower() != ".jpeg" && fileExtension.ToLower() != ".gif")
                {
                    message += "只接受PNG, GIF, JPG 及 JPEG檔案, 請重新選取,";
                }
                else
                {
                    int fileSize = ImageUploaded.PostedFile.ContentLength;
                    if (fileSize > 3145728)
                    {
                        message += "檔案太大,只接受3MB以下的圖片, 請重新選取,";
                    }
                    //2097152
                }
            }
            else
            {
                message += "沒有偵測到圖片，上傳失敗。";
            }
            message = message.Trim(',');
            return message;
        }

        public static string CheckUploadFile(FileUpload FileUpload)
        {
            string message = "";
            if (FileUpload.HasFile)
            {
                string fileExtension = Path.GetExtension(FileUpload.FileName);
                if (fileExtension.ToLower() != ".pdf")
                {
                    message += "只接受PDF檔案, 請重新選取,";
                }
                else
                {
                    int fileSize = FileUpload.PostedFile.ContentLength;
                    if (fileSize > 2097152)
                    {
                        message += "檔案太大,只接受2MB以下的檔案, 請重新選取,";
                    }
                }
            }
            else
            {
                message += "沒有偵測到檔案，上傳失敗。";
            }
            message = message.Trim(',');
            return message;
        }

        public static string CheckPassword(string password, string confirmPassword)
        {
            string message = "";
            if (password.Length < 5)
            {
                message += "密碼太短了,至少要五位數喔";
            }
            if (password != confirmPassword)
            {
                message += ",確認密碼不符喔";
            }
            return message;
        }

        public static string MD5password(string str)
        {
            var md5Hasher = new MD5CryptoServiceProvider();
            var data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(str));
            var sBuilder = new StringBuilder();
            foreach (var chr in data)
            {
                sBuilder.Append(chr.ToString("x2"));
            }
            return sBuilder.ToString();
        }

        public static bool isValidEmail(string email)
        {
            return Regex.IsMatch(email, @"\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)\Z", RegexOptions.IgnoreCase);
        }

        public static string GetPermissionsString(bool messagesChk, bool dealersChk, bool newsChk, bool yachtsChk, bool accountsChk)
        {
            string permissionStr = "";
            if (messagesChk)
            {
                permissionStr += "1";
            }
            else
            {
                permissionStr += "0";
            }
            if (dealersChk)
            {
                permissionStr += "1";
            }
            else
            {
                permissionStr += "0";
            }
            if (newsChk)
            {
                permissionStr += "1";
            }
            else
            {
                permissionStr += "0";
            }
            if (yachtsChk)
            {
                permissionStr += "1";
            }
            else
            {
                permissionStr += "0";
            }
            if (accountsChk)
            {
                permissionStr += "1";
            }
            else
            {
                permissionStr += "0";
            }
            return permissionStr;
        }

        public static void SendHtmlFormattedEmail(string recepientEmail, string subject, string body)
        {
            using (MailMessage mailMessage = new MailMessage())
            {
                mailMessage.From = new MailAddress(ConfigurationManager.AppSettings["UserName"], "Tayana", System.Text.Encoding.UTF8);
                mailMessage.BodyEncoding = System.Text.Encoding.UTF8;
                mailMessage.Subject = subject;
                mailMessage.BodyEncoding = System.Text.Encoding.UTF8;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = true;
                mailMessage.To.Add(new MailAddress(recepientEmail));
                SmtpClient smtp = new SmtpClient();
                smtp.Host = ConfigurationManager.AppSettings["Host"].ToString();
                smtp.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"]);
                NetworkCredential NetworkCred = new NetworkCredential();
                NetworkCred.UserName = ConfigurationManager.AppSettings["UserName"].ToString();
                NetworkCred.Password = ConfigurationManager.AppSettings["Password"].ToString();
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = Convert.ToInt16(ConfigurationManager.AppSettings["Port"]);
                smtp.Send(mailMessage);
            }
        }

        #region "舉世無敵縮圖程式"

        /// <summary>
        /// 舉世無敵縮圖程式(多載)
        /// 1.會自動判斷是比較高還是比較寬，以比較大的那一方決定要縮的尺寸
        /// 2.指定寬度，等比例縮小
        /// 3.指定高度，等比例縮小
        /// </summary>
        /// <param name="name">原檔檔名</param>
        /// <param name="source">來源路徑</param>
        /// <param name="target">目的路徑</param>
        /// <param name="suffix">縮圖辯識符號</param>
        /// <param name="maxWidth">指定要縮的寬度</param>
        /// <param name="maxHeight">指定要縮的高度</param>
        /// <remarks></remarks>
        public void GenerateThumbnailImage(string name, string source, string target, string suffix, int maxWidth, int maxHeight)
        {
            System.Drawing.Image baseImage = System.Drawing.Image.FromFile(source + "\\" + name);
            var ratio = 0.0F; //存放縮圖比例
            float h = baseImage.Height;//圖像原尺寸高度
            float w = baseImage.Width;//圖像原尺寸寬度
            int ht;//圖像縮圖後高度
            int wt; //圖像縮圖後寬度
            if (w > h)
            {//圖像比較寬
                ratio = maxWidth / w;//計算寬度縮圖比例
                if (maxWidth < w)
                {
                    ht = Convert.ToInt32(ratio * h);
                    wt = maxWidth;
                }
                else
                {
                    ht = Convert.ToInt32(baseImage.Height);
                    wt = Convert.ToInt32(baseImage.Width);
                }
            }
            else
            {//比較高
                ratio = maxHeight / h;//計算寬度縮圖比例
                if (maxHeight < h)
                {
                    ht = maxHeight;
                    wt = Convert.ToInt32(ratio * w);
                }
                else
                {
                    ht = Convert.ToInt32(baseImage.Height);
                    wt = Convert.ToInt32(baseImage.Width);
                }
            }
            var filename = target + "\\" + suffix + name;
            System.Drawing.Bitmap img = new System.Drawing.Bitmap(wt, ht);
            System.Drawing.Graphics graphic = Graphics.FromImage(img);
            graphic.CompositingQuality = CompositingQuality.HighQuality;
            graphic.SmoothingMode = SmoothingMode.HighQuality;
            graphic.InterpolationMode = InterpolationMode.NearestNeighbor;
            graphic.DrawImage(baseImage, 0, 0, wt, ht);
            img.Save(filename);
            img.Dispose();
            graphic.Dispose();
            baseImage.Dispose();
        }

        /// <summary>
        /// 舉世無敵縮圖程式(多載)
        /// 1.會自動判斷是比較高還是比較寬，以比較大的那一方決定要縮的尺寸
        /// 2.指定寬度，等比例縮小
        /// 3.指定高度，等比例縮小
        /// </summary>
        /// <param name="name">原檔檔名</param>
        /// <param name="source">來源檔案的Stream,可接受上傳檔案</param>
        /// <param name="target">目的路徑</param>
        /// <param name="suffix">縮圖辯識符號</param>
        /// <param name="maxWidth">指定要縮的寬度</param>
        /// <param name="maxHeight">指定要縮的高度</param>
        /// <remarks></remarks>
        public void GenerateThumbnailImage(string name, System.IO.Stream source, string target, string suffix, int maxWidth, int maxHeight)
        {
            System.Drawing.Image baseImage = System.Drawing.Image.FromStream(source);
            var ratio = 0.0F; //存放縮圖比例
            float h = baseImage.Height; //圖像原尺寸高度
            float w = baseImage.Width;  //圖像原尺寸寬度
            int ht; //圖像縮圖後高度
            int wt;//圖像縮圖後寬度
            if (w > h)
            {
                ratio = maxWidth / w; //計算寬度縮圖比例
                if (maxWidth < w)
                {
                    ht = Convert.ToInt32(ratio * h);
                    wt = maxWidth;
                }
                else
                {
                    ht = Convert.ToInt32(baseImage.Height);
                    wt = Convert.ToInt32(baseImage.Width);
                }
            }
            else
            {
                ratio = maxHeight / h; //計算寬度縮圖比例
                if (maxHeight < h)
                {
                    ht = maxHeight;
                    wt = Convert.ToInt32(ratio * w);
                }
                else
                {
                    ht = Convert.ToInt32(baseImage.Height);
                    wt = Convert.ToInt32(baseImage.Width);
                }
            }
            var filename = target + "\\" + suffix + name;
            System.Drawing.Bitmap img = new System.Drawing.Bitmap(wt, ht);
            System.Drawing.Graphics graphic = Graphics.FromImage(img);
            graphic.CompositingQuality = CompositingQuality.HighQuality;
            graphic.SmoothingMode = SmoothingMode.HighQuality;
            graphic.InterpolationMode = InterpolationMode.NearestNeighbor;
            graphic.DrawImage(baseImage, 0, 0, wt, ht);
            img.Save(filename);
            img.Dispose();
            graphic.Dispose();
            baseImage.Dispose();
        }

        /// <summary>
        /// 舉世無敵縮圖程式(指定寬度，等比例縮小)
        /// </summary>
        /// <param name="name">原檔檔名</param>
        /// <param name="source">來源路徑</param>
        /// <param name="target">目的路徑</param>
        /// <param name="suffix">縮圖辯識符號</param>
        /// <param name="maxWidth">指定要縮的寬度</param>
        /// <remarks></remarks>
        public void GenerateThumbnailImage(int maxWidth, string name, string source, string target, string suffix)
        {
            System.Drawing.Image baseImage = System.Drawing.Image.FromFile(source + "\\" + name);
            var ratio = 0.0F; //存放縮圖比例
            float h = baseImage.Height; //圖像原尺寸高度
            float w = baseImage.Width; //圖像原尺寸寬度
            int ht; //圖像縮圖後高度
            int wt; //圖像縮圖後寬度
            ratio = maxWidth / w;//計算寬度縮圖比例
            if (maxWidth < w)
            {
                ht = Convert.ToInt32(ratio * h);
                wt = maxWidth;
            }
            else
            {
                ht = Convert.ToInt32(baseImage.Height);
                wt = Convert.ToInt32(baseImage.Width);
            }
            var filename = target + "\\" + suffix + name;
            System.Drawing.Bitmap img = new System.Drawing.Bitmap(wt, ht);
            System.Drawing.Graphics graphic = Graphics.FromImage(img);
            graphic.CompositingQuality = CompositingQuality.HighQuality;
            graphic.SmoothingMode = SmoothingMode.HighQuality;
            graphic.InterpolationMode = InterpolationMode.NearestNeighbor;
            graphic.DrawImage(baseImage, 0, 0, wt, ht);
            img.Save(filename, System.Drawing.Imaging.ImageFormat.Jpeg);
            img.Dispose();
            graphic.Dispose();
            baseImage.Dispose();
        }

        /// <summary>
        /// 舉世無敵縮圖程式(指定高度，等比例縮小)
        /// </summary>
        /// <param name="name">原檔檔名</param>
        /// <param name="source">來源路徑</param>
        /// <param name="target">目的路徑</param>
        /// <param name="suffix">縮圖辯識符號</param>
        /// <param name="maxHeight">指定要縮的高度</param>
        /// <remarks></remarks>
        public void GenerateThumbnailImage(string name, string source, string target, string suffix, int maxHeight)
        {
            System.Drawing.Image baseImage = System.Drawing.Image.FromFile(source + "\\" + name);
            var ratio = 0.0F;//存放縮圖比例
            float h = baseImage.Height; //圖像原尺寸高度
            float w = baseImage.Width;  //圖像原尺寸寬度
            int ht; //圖像縮圖後高度
            int wt; //圖像縮圖後寬度
            ratio = maxHeight / h; //計算寬度縮圖比例
            if (maxHeight < h)
            {
                ht = maxHeight;
                wt = Convert.ToInt32(ratio * w);
            }
            else
            {
                ht = Convert.ToInt32(baseImage.Height);
                wt = Convert.ToInt32(baseImage.Width);
            }
            var filename = target + "\\" + suffix + name;
            System.Drawing.Bitmap img = new System.Drawing.Bitmap(wt, ht);
            System.Drawing.Graphics graphic = Graphics.FromImage(img);
            graphic.CompositingQuality = CompositingQuality.HighQuality;
            graphic.SmoothingMode = SmoothingMode.HighQuality;
            graphic.InterpolationMode = InterpolationMode.NearestNeighbor;
            graphic.DrawImage(baseImage, 0, 0, wt, ht);
            img.Save(filename);
            img.Dispose();
            graphic.Dispose();
            baseImage.Dispose();
        }

        #endregion "舉世無敵縮圖程式"
    }
}