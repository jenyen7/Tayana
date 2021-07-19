using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace Tayana
{
    public class DataBase
    {
        private readonly SqlConnection _connection;

        #region "Constructors"

        public DataBase()
        {
            string str = System.Web.Configuration.WebConfigurationManager.
                    ConnectionStrings["tayanaConnectionString"].ConnectionString;
            _connection = new SqlConnection(str);
        }

        public DataBase(string connectionString)
        {
            string str = System.Web.Configuration.WebConfigurationManager.
                    ConnectionStrings[connectionString].ConnectionString;
            _connection = new SqlConnection(str);
        }

        #endregion "Constructors"

        #region "GetDataTable From Database"

        private DataTable GetDataTable(string sql, params SqlParameter[] paras)
        {
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            sqlCommand.Parameters.AddRange(paras);
            SqlDataAdapter SqlDataAdapter = new SqlDataAdapter(sqlCommand);
            DataTable table = new DataTable();
            SqlDataAdapter.Fill(table);
            return table;
        }

        public DataTable GetAllDataTable(string tableName)
        {
            DataTable AllDataTable = GetDataTable($@"SELECT * FROM {tableName}");
            return AllDataTable;
        }

        public DataTable GetAllDataTable(string tableName, string ordering)
        {
            DataTable AllDataTable = GetDataTable($@"SELECT * FROM {tableName} ORDER BY {ordering}");
            return AllDataTable;
        }

        public DataTable GetSelectedDataTable(string tableName, string dataColumn, int dataID)
        {
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@id", dataID)
            };
            DataTable selectedTable = GetDataTable($@"SELECT * FROM {tableName} WHERE {dataColumn}=@id", paras);
            return selectedTable;
        }

        public DataTable GetSelectedDataTable(string tableName, string dataColumn, string data)
        {
            SqlParameter[] paras = new SqlParameter[]
            {
                 new SqlParameter("@dataID", data)
            };
            DataTable selectedTable = GetDataTable($@"SELECT * FROM {tableName} WHERE {dataColumn} LIKE '%' + @dataID + '%'", paras);
            return selectedTable;
        }

        #endregion "GetDataTable From Database"

        #region"通用執行方法"

        public void ExecuteDelete(string tableName, string columnID, int id)
        {
            SqlCommand cmdDelete = new SqlCommand($@"DELETE {tableName} WHERE {columnID} = @id", _connection);
            cmdDelete.Parameters.Add("@id", SqlDbType.Int).Value = id;
            _connection.Open();
            cmdDelete.ExecuteNonQuery();
            _connection.Close();
        }

        public void RecordActivity(string userID, string activity)
        {
            SqlCommand sqlCommand = new SqlCommand(@"INSERT INTO activitiesRecords(userID,userActivity,modifiedDate) VALUES(@userID,@userActivity,@modifiedDate)", _connection);
            sqlCommand.Parameters.Add("@userID", SqlDbType.NVarChar).Value = userID;
            sqlCommand.Parameters.Add("@userActivity", SqlDbType.NVarChar).Value = activity;
            sqlCommand.Parameters.Add("@modifiedDate", SqlDbType.DateTime).Value = DateTime.Now.ToString();
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public int ExecuteNonQuery(string sql, params SqlParameter[] paras)
        {
            int result;
            using (_connection)
            {
                _connection.Open();
                SqlCommand sqlCommand = new SqlCommand(sql, _connection);
                sqlCommand.Parameters.AddRange(paras);
                result = sqlCommand.ExecuteNonQuery();
            }
            return result;
        }

        public object ExecuteScalar(string sql, params SqlParameter[] paras)
        {
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            sqlCommand.Parameters.Add(paras);
            _connection.Open();
            object obj = sqlCommand.ExecuteScalar();
            _connection.Close();
            return obj;
        }

        public SqlDataReader ExecuteReader(string sql, params SqlParameter[] paras)
        {
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            sqlCommand.Parameters.Add(paras);
            _connection.Open();
            SqlDataReader reader = sqlCommand.ExecuteReader(CommandBehavior.CloseConnection);
            //_connection.Close();
            return reader;
        }

        public DataTable GetPagingData(string tableName, string orderBy1, string orderBy2, string currentPage, int limit)
        {
            int page;
            if (currentPage == null)
            {
                page = 1;
            }
            else
            {
                page = Convert.ToInt32(currentPage);
            }
            int floor = (page - 1) * limit + 1;
            int ceiling = page * limit;
            string sql = $@"WITH tmpMsg AS (
                            SELECT ROW_NUMBER() OVER (ORDER BY {orderBy1},{orderBy2}) AS rowIndex, * FROM {tableName})
                            SELECT * FROM tmpMsg WHERE rowIndex >= @floor AND rowIndex <= @ceiling";
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@floor", floor),
                new SqlParameter("@ceiling", ceiling)
            };
            DataTable pagingTable = GetDataTable(sql, paras);
            return pagingTable;
        }

        public int GetTotalPagesCount(string tableName)
        {
            string sql = $@"SELECT COUNT(*) FROM {tableName}";
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            _connection.Open();
            int count = Convert.ToInt32(sqlCommand.ExecuteScalar());
            _connection.Close();
            return count;
        }

        #endregion

        #region "登入"

        public string Login(string account, string password)
        {
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@account", account),
                new SqlParameter("@password", Helper.MD5password(password))
            };
            DataTable userInfo = GetDataTable($@"SELECT * FROM accounts WHERE (account=@account) AND (password=@password)", paras);
            if (userInfo.Rows.Count > 0)
            {
                UserInformation UserInformation = new UserInformation();
                UserInformation.account = userInfo.Rows[0]["account"].ToString();
                UserInformation.username = userInfo.Rows[0]["username"].ToString();
                UserInformation.email = userInfo.Rows[0]["email"].ToString();
                UserInformation.avatar = userInfo.Rows[0]["avatar"].ToString();
                UserInformation.permissions = Convert.ToInt16(userInfo.Rows[0]["permissions"]);
                UserInformation.joinedDate = Convert.ToDateTime(userInfo.Rows[0]["joinedDate"]).ToString("yyyy-MM-dd");
                string userData = JsonConvert.SerializeObject(UserInformation);
                return userData;
            }
            return "loginFailed";
        }

        #endregion "Login"

        #region "帳號相關"

        public void InsertAccountsInfo(string account, string password, string username, string email, string avatar, bool messagesIfChecked, bool dealersIfChecked, bool newsIfChecked, bool yachtsIfChecked, bool accountsIfChecked)
        {
            SqlCommand sqlCommand = new SqlCommand(@"INSERT INTO accounts(account,password,username,email,avatar,permissions,joinedDate) VALUES(@account,@password,@username,@email,@avatar,@permissions,@joinedDate)", _connection);
            sqlCommand.Parameters.Add("@account", SqlDbType.NVarChar).Value = account;
            sqlCommand.Parameters.Add("@password", SqlDbType.NVarChar).Value = Helper.MD5password(password);
            sqlCommand.Parameters.Add("@username", SqlDbType.NVarChar).Value = username;
            sqlCommand.Parameters.Add("@email", SqlDbType.NVarChar).Value = email;
            if (!string.IsNullOrEmpty(avatar))
            {
                sqlCommand.Parameters.Add("@avatar", SqlDbType.NVarChar).Value = avatar;
            }
            else
            {
                sqlCommand.Parameters.Add("@avatar", SqlDbType.NVarChar).Value = "userIcon.png";
            }
            string permissionsStr = Helper.GetPermissionsString(messagesIfChecked, dealersIfChecked, newsIfChecked, yachtsIfChecked, accountsIfChecked);
            sqlCommand.Parameters.Add("@permissions", SqlDbType.Int).Value = Convert.ToInt32(permissionsStr, 2);
            sqlCommand.Parameters.Add("@joinedDate", SqlDbType.DateTime).Value = DateTime.Now.ToString();
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public DataRow CheckDuplicateAccount(string accountID)
        {
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@accountID", accountID)
            };
            DataTable accountsTable = GetDataTable($@"SELECT account FROM accounts WHERE account LIKE @accountID", paras);
            return accountsTable.Rows.Count > 0 ? accountsTable.Rows[0] : null;
        }

        public void UpdateAccountsInfo(int id, string password, string username, string email, string avatar, bool messagesIfChecked, bool dealersIfChecked, bool newsIfChecked, bool yachtsIfChecked, bool accountsIfChecked)
        {
            SqlCommand sqlCommand = new SqlCommand(@"UPDATE accounts SET password=@password,username=@username,email=@email,avatar=@avatar,permissions=@permissions WHERE id=@id", _connection);
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            if (!string.IsNullOrEmpty(password))
            {
                sqlCommand.Parameters.Add("@password", SqlDbType.NVarChar).Value = Helper.MD5password(password);
            }
            else
            {
                DataTable oldPasswordTable = GetSelectedDataTable("accounts", "id", id);
                sqlCommand.Parameters.Add("@password", SqlDbType.NVarChar).Value = oldPasswordTable.Rows[0]["password"].ToString();
            }
            sqlCommand.Parameters.Add("@username", SqlDbType.NVarChar).Value = username;
            sqlCommand.Parameters.Add("@email", SqlDbType.NVarChar).Value = email;
            sqlCommand.Parameters.Add("@avatar", SqlDbType.NVarChar).Value = avatar;
            string permissionsStr = Helper.GetPermissionsString(messagesIfChecked, dealersIfChecked, newsIfChecked, yachtsIfChecked, accountsIfChecked);
            sqlCommand.Parameters.Add("@permissions", SqlDbType.Int).Value = Convert.ToInt32(permissionsStr, 2);
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void UpdateAccountsInfo(string accountID, string username, string email, string avatar)
        {
            SqlCommand sqlCommand = new SqlCommand(@"UPDATE accounts SET username=@username,email=@email,avatar=@avatar WHERE account=@account", _connection);
            sqlCommand.Parameters.Add("@account", SqlDbType.NVarChar).Value = accountID;
            sqlCommand.Parameters.Add("@username", SqlDbType.NVarChar).Value = username;
            sqlCommand.Parameters.Add("@email", SqlDbType.NVarChar).Value = email;
            sqlCommand.Parameters.Add("@avatar", SqlDbType.NVarChar).Value = avatar;
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void UpdatePassword(string accountID, string password)
        {
            SqlCommand sqlCommand = new SqlCommand(@"UPDATE accounts SET password=@password WHERE account=@account", _connection);
            sqlCommand.Parameters.Add("@account", SqlDbType.NVarChar).Value = accountID;
            sqlCommand.Parameters.Add("@password", SqlDbType.NVarChar).Value = Helper.MD5password(password);
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public DataTable GetSelectedAccountsPagingData(string currentPage, int limit, string searchPermissions, string keyword)
        {
            string searchStr = "";
            int selectedPermission = 0;
            if (searchPermissions != "0")
            {
                selectedPermission = Convert.ToInt16(searchPermissions);
                searchStr += $@"(permissions&@selectedPermission) > 0";
            }
            if (!string.IsNullOrEmpty(keyword))
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"(account LIKE '%' + @keyword + '%' OR username LIKE '%' + @keyword2 + '%')";
            }
            int page;
            if (currentPage == null)
            {
                page = 1;
            }
            else
            {
                page = Convert.ToInt32(currentPage);
            }
            int floor = (page - 1) * limit + 1;
            int ceiling = page * limit;
            string sql = $@"WITH tmpMsg AS (
                            SELECT ROW_NUMBER() OVER (ORDER BY joinedDate DESC) AS rowIndex, * FROM accounts WHERE {searchStr})
                            SELECT * FROM tmpMsg WHERE rowIndex >= @floor AND rowIndex <= @ceiling";
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@floor", floor),
                new SqlParameter("@ceiling", ceiling),
                new SqlParameter("@selectedPermission", selectedPermission),
                new SqlParameter("@keyword", keyword),
                new SqlParameter("@keyword2", keyword)
            };
            DataTable pagingTable = GetDataTable(sql, paras);
            return pagingTable;
        }

        public int GetSelectedAccountsTotalPagesCount(string searchPermissions, string keyword)
        {
            string searchStr = "";
            int selectedPermission = 0;
            if (searchPermissions != "0")
            {
                selectedPermission = Convert.ToInt16(searchPermissions);
                searchStr += $@"(permissions&@selectedPermission) > 0";
            }
            if (!string.IsNullOrEmpty(keyword))
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"(account LIKE '%' + @keyword + '%' OR username LIKE '%' + @keyword2 + '%')";
            }
            string sql = $@"SELECT COUNT(*) FROM accounts WHERE {searchStr}";
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            sqlCommand.Parameters.Add("@selectedPermission", SqlDbType.Int).Value = selectedPermission;
            sqlCommand.Parameters.Add("@keyword", SqlDbType.NVarChar).Value = keyword;
            sqlCommand.Parameters.Add("@keyword2", SqlDbType.NVarChar).Value = keyword;
            _connection.Open();
            int count = Convert.ToInt32(sqlCommand.ExecuteScalar());
            _connection.Close();
            return count;
        }

        #endregion "AccountsRelated"

        #region "代理商相關"

        public void InsertCountry(string country)
        {
            SqlCommand sqlCommand = new SqlCommand($"INSERT INTO countries (country,dateAdded) VALUES (@country,@dateAdded)", _connection);
            sqlCommand.Parameters.Add("@country", SqlDbType.NVarChar).Value = country.ToUpper();
            sqlCommand.Parameters.Add("@dateAdded", SqlDbType.DateTime).Value = DateTime.Now.ToString();
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void UpdateCountry(int id, string country)
        {
            SqlCommand sqlCommand = new SqlCommand(@"UPDATE countries SET country=@country WHERE countryID=@id", _connection);
            sqlCommand.Parameters.Add("@country", SqlDbType.NVarChar).Value = country;
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public DataTable GetCitiesDataTable()
        {
            DataTable citiesTable = GetDataTable("SELECT cities.cityID, cities.countryID, cities.city, countries.country FROM cities INNER JOIN countries ON cities.countryID = countries.countryID ORDER BY cities.dateAdded DESC");
            return citiesTable;
        }

        public void InsertCity(string city, int country)
        {
            SqlCommand sqlCommand = new SqlCommand($"INSERT INTO cities (countryID,city,dateAdded) VALUES (@countryID, @city,@dateAdded)", _connection);
            sqlCommand.Parameters.Add("@countryID", SqlDbType.Int).Value = country;
            sqlCommand.Parameters.Add("@city", SqlDbType.NVarChar).Value = city;
            sqlCommand.Parameters.Add("@dateAdded", SqlDbType.DateTime).Value = DateTime.Now.ToString();
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void UpdateCity(int id, string city, int country)
        {
            SqlCommand sqlCommand = new SqlCommand($"UPDATE cities SET countryID=@countryID, city=@city WHERE cityID=@id", _connection);
            sqlCommand.Parameters.Add("@countryID", SqlDbType.Int).Value = country;
            sqlCommand.Parameters.Add("@city", SqlDbType.NVarChar).Value = city;
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void InsertDealer(string dealerName, string contactName, string dealerAddress, string dealerTel, string dealerFax, string dealerEmail, string filename, int cityID)
        {
            SqlCommand sqlCommand = new SqlCommand($"INSERT INTO dealers(dealerName,dealerContact,dealerAddress,dealerTel,dealerFax,dealerEmail,dealerCity,dealerPic,dateAdded) VALUES(@dealerName,@dealerContact,@dealerAddress,@dealerTel,@dealerFax,@dealerEmail,@dealerCity,@dealerPic,@dateAdded)", _connection);
            sqlCommand.Parameters.Add("@dealerName", SqlDbType.NVarChar).Value = dealerName;
            sqlCommand.Parameters.Add("@dealerContact", SqlDbType.NVarChar).Value = contactName;
            sqlCommand.Parameters.Add("@dealerAddress", SqlDbType.NVarChar).Value = dealerAddress;
            sqlCommand.Parameters.Add("@dealerTel", SqlDbType.NVarChar).Value = dealerTel;
            sqlCommand.Parameters.Add("@dealerFax", SqlDbType.NVarChar).Value = dealerFax;
            sqlCommand.Parameters.Add("@dealerEmail", SqlDbType.NVarChar).Value = dealerEmail;
            sqlCommand.Parameters.Add("@dealerCity", SqlDbType.Int).Value = cityID;
            sqlCommand.Parameters.Add("@dealerPic", SqlDbType.NVarChar).Value = filename;
            sqlCommand.Parameters.Add("@dateAdded", SqlDbType.DateTime).Value = DateTime.Now.ToString();
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public DataTable GetDealerDataByID(string columnID, int id)
        {
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@id", id)
            };
            DataTable table = GetDataTable($@"SELECT dealers.*, cities.city, cities.countryID, countries.country FROM cities INNER JOIN countries ON cities.countryID = countries.countryID INNER JOIN dealers ON cities.cityID = dealers.dealerCity WHERE {columnID} =@id", paras);
            return table;
        }

        public void UpdateDealer(int id, string dealerName, string contactName, string dealerAddress, string dealerTel, string dealerFax, string dealerEmail, string filename, int cityID)
        {
            SqlCommand sqlCommand = new SqlCommand($"UPDATE dealers SET dealerName=@dealerName,dealerContact=@dealerContact,dealerAddress=@dealerAddress,dealerTel=@dealerTel,dealerFax=@dealerFax,dealerEmail=@dealerEmail,dealerCity=@dealerCity,dealerPic=@dealerPic WHERE id=@id", _connection);
            sqlCommand.Parameters.Add("@dealerName", SqlDbType.NVarChar).Value = dealerName;
            sqlCommand.Parameters.Add("@dealerContact", SqlDbType.NVarChar).Value = contactName;
            sqlCommand.Parameters.Add("@dealerAddress", SqlDbType.NVarChar).Value = dealerAddress;
            sqlCommand.Parameters.Add("@dealerTel", SqlDbType.NVarChar).Value = dealerTel;
            sqlCommand.Parameters.Add("@dealerFax", SqlDbType.NVarChar).Value = dealerFax;
            sqlCommand.Parameters.Add("@dealerEmail", SqlDbType.NVarChar).Value = dealerEmail;
            sqlCommand.Parameters.Add("@dealerCity", SqlDbType.NVarChar).Value = cityID;
            sqlCommand.Parameters.Add("@dealerPic", SqlDbType.NVarChar).Value = filename;
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public DataTable GetDealersPagingData(string currentPage, int limit)
        {
            int page;
            if (currentPage == null)
            {
                page = 1;
            }
            else
            {
                page = Convert.ToInt32(currentPage);
            }
            int floor = (page - 1) * limit + 1;
            int ceiling = page * limit;
            string sql = $@"WITH tmpMsg AS (
                            SELECT ROW_NUMBER() OVER (ORDER BY dealers.dateAdded DESC,id) AS rowIndex, dealers.*, cities.city, countries.country FROM cities INNER JOIN countries ON
                            cities.countryID = countries.countryID INNER JOIN dealers ON cities.cityID = dealers.dealerCity)
                            SELECT * FROM tmpMsg WHERE rowIndex >= @floor AND rowIndex <= @ceiling";
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@floor", floor),
                new SqlParameter("@ceiling", ceiling)
            };
            DataTable dealersTable = GetDataTable(sql, paras);
            return dealersTable;
        }

        public DataTable GetSelectedDealersPagingData(string currentPage, int limit, string searchCountry, string searchCity, string searchName)
        {
            string searchStr = "";
            if (searchCountry != "0")
            {
                searchStr += $@"cities.countryID = @searchCountry";
            }
            if (searchCity != "0")
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"dealers.dealerCity = @searchCity";
            }
            if (!string.IsNullOrEmpty(searchName))
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"(dealerName LIKE '%' + @searchName + '%' OR dealerContact LIKE '%' + @searchContact + '%')";
            }

            int page;
            if (currentPage == null)
            {
                page = 1;
            }
            else
            {
                page = Convert.ToInt32(currentPage);
            }
            int floor = (page - 1) * limit + 1;
            int ceiling = page * limit;
            string sql = $@"WITH tmpMsg AS (
                            SELECT ROW_NUMBER() OVER(ORDER BY dealers.dateAdded DESC, id) AS rowIndex, dealers.*, cities.cityID,cities.city,cities.countryID, countries.country
                            FROM cities INNER JOIN countries ON cities.countryID = countries.countryID INNER JOIN dealers ON cities.cityID = dealers.dealerCity WHERE {searchStr})
                            SELECT * FROM tmpMsg WHERE rowIndex >= @floor AND rowIndex <= @ceiling";
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@floor", floor),
                new SqlParameter("@ceiling", ceiling),
                new SqlParameter("@searchCountry", searchCountry),
                new SqlParameter("@searchCity", searchCity),
                new SqlParameter("@searchName", searchName),
                new SqlParameter("@searchContact", searchName)
            };
            DataTable pagingTable = GetDataTable(sql, paras);
            return pagingTable;
        }

        public int GetSelectedDealersTotalPageCount(string searchCountry, string searchCity, string searchName)
        {
            string searchStr = "";
            if (searchCountry != "0")
            {
                searchStr += $@"cities.countryID = @searchCountry";
            }
            if (searchCity != "0")
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"dealers.dealerCity = @searchCity";
            }
            if (!string.IsNullOrEmpty(searchName))
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"(dealerName LIKE '%' + @searchName + '%' OR dealerContact LIKE '%' + @searchContact + '%')";
            }
            string sql = $@"SELECT COUNT(*) FROM cities INNER JOIN countries ON cities.countryID = countries.countryID INNER JOIN dealers ON cities.cityID = dealers.dealerCity WHERE {searchStr}";
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            sqlCommand.Parameters.Add("@searchCountry", SqlDbType.NVarChar).Value = searchCountry;
            sqlCommand.Parameters.Add("@searchCity", SqlDbType.NVarChar).Value = searchCity;
            sqlCommand.Parameters.Add("@searchName", SqlDbType.NVarChar).Value = searchName;
            sqlCommand.Parameters.Add("@searchContact", SqlDbType.NVarChar).Value = searchName;
            _connection.Open();
            int count = Convert.ToInt32(sqlCommand.ExecuteScalar());
            _connection.Close();
            return count;
        }

        #endregion

        #region "新聞相關"

        public void InsertNews(string title, string subs, string filename, string content, bool pin)
        {
            SqlCommand sqlCommand = new SqlCommand($"INSERT INTO news(newsTitle,newsSubs,postDate,newsCoverPic,newsContent,pinned) VALUES(@newsTitle,@newsSubs,@postDate,@newsCoverPic,@newsContent,@pinned)", _connection);
            sqlCommand.Parameters.Add("@newsTitle", SqlDbType.NVarChar).Value = title;
            sqlCommand.Parameters.Add("@newsSubs", SqlDbType.NVarChar).Value = subs;
            sqlCommand.Parameters.Add("@postDate", SqlDbType.DateTime).Value = DateTime.Now.ToString();
            sqlCommand.Parameters.Add("@newsCoverPic", SqlDbType.NVarChar).Value = filename;
            sqlCommand.Parameters.Add("@newsContent", SqlDbType.NVarChar).Value = content;
            if (pin)
            {
                sqlCommand.Parameters.Add("@pinned", SqlDbType.Int).Value = 1;
            }
            else
            {
                sqlCommand.Parameters.Add("@pinned", SqlDbType.Int).Value = 0;
            }
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void UpdateNews(int id, string title, string subs, string filename, string content, bool pin)
        {
            SqlCommand sqlCommand = new SqlCommand($"UPDATE dbo.news SET newsTitle=@newsTitle,newsSubs=@newsSubs,newsCoverPic=@newsCoverPic,newsContent=@newsContent,pinned=@pinned WHERE id=@id", _connection);
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            sqlCommand.Parameters.Add("@newsTitle", SqlDbType.NVarChar).Value = title;
            sqlCommand.Parameters.Add("@newsSubs", SqlDbType.NVarChar).Value = subs;
            sqlCommand.Parameters.Add("@newsCoverPic", SqlDbType.NVarChar).Value = filename;
            sqlCommand.Parameters.Add("@newsContent", SqlDbType.NVarChar).Value = content;
            if (pin)
            {
                sqlCommand.Parameters.Add("@pinned", SqlDbType.Int).Value = 1;
            }
            else
            {
                sqlCommand.Parameters.Add("@pinned", SqlDbType.Int).Value = 0;
            }
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public int GetSelectedNewsTotalPagesCount(string searchDateStart, string searchDateEnd, string searchTitle)
        {
            string searchStr = "";
            if (!string.IsNullOrEmpty(searchDateStart) && !string.IsNullOrEmpty(searchDateEnd))
            {
                searchStr += $@"postDate BETWEEN @searchDateStart AND DATEADD(day, 1, @searchDateEnd)";
            }
            if (!string.IsNullOrEmpty(searchTitle))
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"(newsTitle LIKE '%' + @searchTitle + '%' OR newsSubs LIKE '%' + @searchSubs + '%')";
            }
            string sql = $@"SELECT COUNT(*) FROM news WHERE {searchStr}";
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            sqlCommand.Parameters.AddWithValue("@searchDateStart", searchDateStart);
            sqlCommand.Parameters.AddWithValue("@searchDateEnd", searchDateEnd);
            sqlCommand.Parameters.Add("@searchTitle", SqlDbType.NVarChar).Value = searchTitle;
            sqlCommand.Parameters.Add("@searchSubs", SqlDbType.NVarChar).Value = searchTitle;
            _connection.Open();
            int count = Convert.ToInt32(sqlCommand.ExecuteScalar());
            _connection.Close();
            return count;
        }

        public DataTable GetSelectedNewsPagingData(string currentPage, int limit, string searchDateStart, string searchDateEnd, string searchTitle)
        {
            string searchStr = "";
            if (!string.IsNullOrEmpty(searchDateStart) && !string.IsNullOrEmpty(searchDateEnd))
            {
                searchStr += $@"postDate BETWEEN @searchDateStart AND DATEADD(day, 1, @searchDateEnd)";
            }
            if (!string.IsNullOrEmpty(searchTitle))
            {
                if (!string.IsNullOrEmpty(searchStr))
                {
                    searchStr += " AND ";
                }
                searchStr += $@"(newsTitle LIKE '%' + @searchTitle + '%' OR newsSubs LIKE '%' + @searchSubs + '%')";
            }
            int page;
            if (currentPage == null)
            {
                page = 1;
            }
            else
            {
                page = Convert.ToInt32(currentPage);
            }
            int floor = (page - 1) * limit + 1;
            int ceiling = page * limit;
            string sql = $@"WITH tmpMsg AS (
                            SELECT ROW_NUMBER() OVER (ORDER BY pinned DESC, postDate DESC) AS rowIndex, * FROM news WHERE {searchStr})
                            SELECT * FROM tmpMsg WHERE rowIndex >= @floor AND rowIndex <= @ceiling";
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@floor", floor),
                new SqlParameter("@ceiling", ceiling),
                new SqlParameter("@searchDateStart", searchDateStart),
                new SqlParameter("@searchDateEnd", searchDateEnd),
                new SqlParameter("@searchTitle", searchTitle),
                new SqlParameter("@searchSubs", searchTitle)
            };
            DataTable pagingTable = GetDataTable(sql, paras);
            return pagingTable;
        }

        #endregion

        #region "遊艇型號相關"

        public int InsertYacht(string name, string overview, string dimensions, string layout, string specification, bool newest)
        {
            SqlCommand sqlCommand = new SqlCommand(@"INSERT INTO yachts(yachtName,overview,dimensions,layout,specification,newest,publishedDate) VALUES(@yachtName,@overview,@dimensions,@layout,@specification,@newest,@publishedDate); SELECT SCOPE_IDENTITY();", _connection);
            sqlCommand.Parameters.Add("@yachtName", SqlDbType.NVarChar).Value = name;
            sqlCommand.Parameters.Add("@overview", SqlDbType.NVarChar).Value = overview;
            sqlCommand.Parameters.Add("@dimensions", SqlDbType.NVarChar).Value = dimensions;
            sqlCommand.Parameters.Add("@layout", SqlDbType.NVarChar).Value = layout;
            sqlCommand.Parameters.Add("@specification", SqlDbType.NVarChar).Value = specification;
            sqlCommand.Parameters.Add("@publishedDate", SqlDbType.DateTime).Value = DateTime.Now.ToString();
            if (newest)
            {
                sqlCommand.Parameters.Add("@newest", SqlDbType.Int).Value = 1;
            }
            else
            {
                sqlCommand.Parameters.Add("@newest", SqlDbType.Int).Value = 0;
            }
            _connection.Open();
            int id = Convert.ToInt32(sqlCommand.ExecuteScalar());
            _connection.Close();
            return id;
        }

        public void UpdateYacht(int id, string name, string overview, string dimensions, string layout, string specification, bool newest)
        {
            SqlCommand sqlCommand = new SqlCommand(@"UPDATE yachts SET yachtName=@yachtName,overview=@overview,dimensions=@dimensions,layout=@layout,specification=@specification,newest=@newest WHERE id=@id", _connection);
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            sqlCommand.Parameters.Add("@yachtName", SqlDbType.NVarChar).Value = name;
            sqlCommand.Parameters.Add("@overview", SqlDbType.NVarChar).Value = overview;
            sqlCommand.Parameters.Add("@dimensions", SqlDbType.NVarChar).Value = dimensions;
            sqlCommand.Parameters.Add("@layout", SqlDbType.NVarChar).Value = layout;
            sqlCommand.Parameters.Add("@specification", SqlDbType.NVarChar).Value = specification;
            if (newest)
            {
                sqlCommand.Parameters.Add("@newest", SqlDbType.Int).Value = 1;
            }
            else
            {
                sqlCommand.Parameters.Add("@newest", SqlDbType.Int).Value = 0;
            }
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void InsertPDFile(int yachtID, string rename, string filename, string contentType, int visibility)
        {
            SqlCommand sqlCommand = new SqlCommand(@"INSERT INTO yachtsPDFfile(yachtID,renamePDF,fileName,fileContentType,fileOrder,visible,dateAdded) VALUES(@yachtID,@renamePDF,@fileName,@fileContentType,@fileOrder,@visible,@dateAdded)", _connection);
            sqlCommand.Parameters.Add("@yachtID", SqlDbType.Int).Value = yachtID;
            sqlCommand.Parameters.Add("@renamePDF", SqlDbType.NVarChar).Value = rename;
            sqlCommand.Parameters.Add("@fileName", SqlDbType.NVarChar).Value = filename;
            sqlCommand.Parameters.Add("@fileContentType", SqlDbType.NVarChar).Value = contentType;
            sqlCommand.Parameters.Add("@visible", SqlDbType.Int).Value = visibility;
            sqlCommand.Parameters.Add("@dateAdded", SqlDbType.DateTime).Value = DateTime.Now.ToString();

            SqlCommand cmd = new SqlCommand($@"SELECT COUNT(*) FROM yachtsPDFfile WHERE yachtID={yachtID}", _connection);
            _connection.Open();
            int count = Convert.ToInt16(cmd.ExecuteScalar());
            _connection.Close();

            sqlCommand.Parameters.Add("@fileOrder", SqlDbType.Int).Value = count + 1;
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void UpdatePDFile(int id, string rename, bool visibility, string fileOrder)
        {
            SqlCommand sqlCommand = new SqlCommand($@"UPDATE yachtsPDFfile SET renamePDF=@renamePDF,fileOrder=@fileOrder,visible=@visible WHERE id =@id", _connection);
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            sqlCommand.Parameters.Add("@renamePDF", SqlDbType.NVarChar).Value = rename;
            if (visibility)
            {
                sqlCommand.Parameters.Add("@visible", SqlDbType.Int).Value = 1;
            }
            else
            {
                sqlCommand.Parameters.Add("@visible", SqlDbType.Int).Value = 0;
            }
            sqlCommand.Parameters.Add("@fileOrder", SqlDbType.Int).Value = Convert.ToInt16(fileOrder);

            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void InsertYachtPhoto(int yachtID, string imageName, string imageAlt)
        {
            SqlCommand sqlCommand = new SqlCommand(@"INSERT INTO yachtsGallery(yachtID,imageName,imageAlt,imageOrder,dateAdded) VALUES(@yachtID,@imageName,@imageAlt,@imageOrder,@dateAdded)", _connection);
            sqlCommand.Parameters.Add("@yachtID", SqlDbType.Int).Value = yachtID;
            sqlCommand.Parameters.Add("@imageName", SqlDbType.NVarChar).Value = imageName;
            sqlCommand.Parameters.Add("@imageAlt", SqlDbType.NVarChar).Value = imageAlt;
            sqlCommand.Parameters.Add("@dateAdded", SqlDbType.DateTime).Value = DateTime.Now.ToString();

            SqlCommand cmd = new SqlCommand($@"SELECT COUNT(*) FROM yachtsGallery WHERE yachtID={yachtID}", _connection);
            _connection.Open();
            int count = Convert.ToInt16(cmd.ExecuteScalar());
            _connection.Close();

            sqlCommand.Parameters.Add("@imageOrder", SqlDbType.Int).Value = count + 1;
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public void UpdateYachtPhoto(int id, string imageAlt, string imageOrder)
        {
            SqlCommand sqlCommand = new SqlCommand($@"UPDATE yachtsGallery SET imageAlt=@imageAlt,imageOrder=@imageOrder WHERE id =@id", _connection);
            sqlCommand.Parameters.Add("@id", SqlDbType.Int).Value = id;
            sqlCommand.Parameters.Add("@imageAlt", SqlDbType.NVarChar).Value = imageAlt;
            sqlCommand.Parameters.Add("@imageOrder", SqlDbType.Int).Value = Convert.ToInt16(imageOrder);

            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        public int GetSelectedYachtsTotalPagesCount(string startDateSearch, string endDateSearch, string keyword)
        {
            string searchStr = "";
            if (!string.IsNullOrEmpty(startDateSearch) && !string.IsNullOrEmpty(endDateSearch))
            {
                searchStr += $@" AND publishedDate BETWEEN @searchDateStart AND DATEADD(day, 1, @searchDateEnd)";
            }
            if (!string.IsNullOrEmpty(keyword))
            {
                searchStr += $@"AND yachtName LIKE '%' + @keyword + '%' ";
            }
            string sql = $@"SELECT COUNT(*) FROM yachts WHERE 1=1 {searchStr}";
            SqlCommand sqlCommand = new SqlCommand(sql, _connection);
            sqlCommand.Parameters.AddWithValue("@searchDateStart", startDateSearch);
            sqlCommand.Parameters.AddWithValue("@searchDateEnd", endDateSearch);
            sqlCommand.Parameters.AddWithValue("@keyword", keyword);
            _connection.Open();
            int count = Convert.ToInt32(sqlCommand.ExecuteScalar());
            _connection.Close();
            return count;
        }

        public DataTable GetSelectedYachtsPagingData(string currentPage, int limit, string startDateSearch, string endDateSearch, string keyword)
        {
            int page;
            if (currentPage == null)
            {
                page = 1;
            }
            else
            {
                page = Convert.ToInt32(currentPage);
            }
            int floor = (page - 1) * limit + 1;
            int ceiling = page * limit;

            string searchStr = "";
            if (!string.IsNullOrEmpty(startDateSearch) && !string.IsNullOrEmpty(endDateSearch))
            {
                searchStr += $@"AND publishedDate BETWEEN @searchDateStart AND DATEADD(day, 1, @searchDateEnd)";
            }
            if (!string.IsNullOrEmpty(keyword))
            {
                searchStr += $@"AND yachtName LIKE '%' + @keyword + '%' ";
            }
            string sql = $@"WITH tmpMsg AS (
                            SELECT ROW_NUMBER() OVER (ORDER BY newest DESC, publishedDate DESC) AS rowIndex, * FROM yachts WHERE 1=1 {searchStr})
                            SELECT * FROM tmpMsg WHERE rowIndex >= @floor AND rowIndex <= @ceiling";

            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@floor", floor),
                new SqlParameter("@ceiling", ceiling),
                new SqlParameter("@searchDateStart", startDateSearch),
                new SqlParameter("@searchDateEnd", endDateSearch),
                new SqlParameter("@keyword", keyword)
            };
            DataTable pagingTable = GetDataTable(sql, paras);
            return pagingTable;
        }

        #endregion

        #region "留言相關"

        public void InsertMessage(string name, string email, string phone, string country, string yachtBrochure, string comments)
        {
            SqlCommand sqlCommand = new SqlCommand(@"INSERT INTO contact(name,email,phone,country,brochure,comments,sentDate) VALUES(@name,@email,@phone,@country,@brochure,@comments,GetDate())", _connection);
            sqlCommand.Parameters.Add("@name", SqlDbType.NVarChar).Value = name;
            sqlCommand.Parameters.Add("@email", SqlDbType.NVarChar).Value = email;
            sqlCommand.Parameters.Add("@phone", SqlDbType.NVarChar).Value = phone;
            sqlCommand.Parameters.Add("@country", SqlDbType.NVarChar).Value = country;
            sqlCommand.Parameters.Add("@brochure", SqlDbType.NVarChar).Value = yachtBrochure;
            sqlCommand.Parameters.Add("@comments", SqlDbType.NVarChar).Value = comments;
            _connection.Open();
            sqlCommand.ExecuteNonQuery();
            _connection.Close();
        }

        #endregion

        #region "TOP3 系列 & 相簿"

        public DataTable GetAllCounts()
        {
            DataTable table = GetDataTable(@"SELECT COUNT(*) AS ships,(SELECT COUNT(*) FROM news)AS reports,(SELECT COUNT(*) FROM dealers)AS dealers,(SELECT COUNT(*) FROM contact)AS comments FROM yachts");
            return table;
        }

        public DataTable GetUserActivities()
        {
            DataTable table = GetDataTable(@"SELECT TOP 8 activitiesRecords.*, accounts.username, accounts.avatar FROM accounts INNER JOIN activitiesRecords ON accounts.account = activitiesRecords.userID ORDER BY modifiedDate DESC");
            return table;
        }

        public DataTable GetTop3Yachts()
        {
            DataTable table = GetDataTable("SELECT TOP 3 * FROM yachts ORDER BY newest DESC, publishedDate DESC");
            return table;
        }

        public DataTable GetTop3News()
        {
            DataTable table = GetDataTable("SELECT TOP 3 * FROM news ORDER BY pinned DESC, postDate DESC");
            return table;
        }

        public DataTable GetTop3Dealers()
        {
            DataTable table = GetDataTable("SELECT  TOP 3 dealers.*, countries.*, cities.* FROM cities INNER JOIN countries ON cities.countryID = countries.countryID INNER JOIN dealers ON cities.cityID = dealers.dealerCity");
            return table;
        }

        public DataTable GetTop3Comments()
        {
            DataTable table = GetDataTable("SELECT TOP 3 * FROM contact ORDER BY sentDate DESC");
            return table;
        }

        public DataTable GetIndexGallery()
        {
            DataTable table = GetDataTable($@"SELECT yachts.newest,yachts.yachtName, yachtsGallery.* FROM yachts INNER JOIN yachtsGallery ON yachts.id = yachtsGallery.yachtID WHERE imageOrder=1");
            return table;
        }

        public DataTable GetYachtsGallery(int id)
        {
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@id", id)
            };
            DataTable table = GetDataTable($@"SELECT * FROM yachtsGallery WHERE yachtID=@id ORDER BY CASE WHEN imageOrder IS NULL THEN 1 ELSE 0 END, imageOrder, id", paras);
            return table;
        }

        public DataTable GetPDFList(int id)
        {
            SqlParameter[] paras = new SqlParameter[]
            {
                new SqlParameter("@id", id)
            };
            DataTable table = GetDataTable($@"SELECT * FROM yachtsPDFfile WHERE yachtID=@id AND visible=1 ORDER BY fileOrder", paras);
            return table;
        }

        #endregion
    }
}