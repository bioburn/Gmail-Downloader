using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;

namespace GmailDownloader
{
    public partial class Receiver : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string code = Request.QueryString["code"];
            if (code != null && !IsPostBack)
            {
                //code to get new refresh token here
                RefreshTokenBox.Text = getRefreshToken(code);
            }
            //construct the authorization url
            testLink.NavigateUrl = //"https://accounts.google.com/o/oauth2/v2/auth?client_id=316651371589-sb93p6suqkt2797vpsrv61qrtim5t9b1.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A54158%2FReceiver.aspx&scope=https%3A%2F%2Fmail.google.com%2F&access_type=offline&prompt=consent&response_type=code";
            "https://accounts.google.com/o/oauth2/v2/auth?client_id=316651371589-sb93p6suqkt2797vpsrv61qrtim5t9b1.apps.googleusercontent.com&redirect_uri=https%3A%2F%2Fkingsstoreinternational.com%2Freceiver&scope=https%3A%2F%2Fmail.google.com%2F&access_type=offline&prompt=consent&response_type=code";
           // "https://accounts.google.com/o/oauth2/v2/auth?client_id=316651371589-sb93p6suqkt2797vpsrv61qrtim5t9b1.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A62805%2FReceiver.aspx&scope=https%3A%2F%2Fmail.google.com%2F&access_type=offline&prompt=consent&response_type=code";
        }


        private string getMessages(string emailAddress, string suppliedRefreshToken)
        {
            //https://www.googleapis.com/gmail/v1/users/userId/messages
            string ids = "";

            System.Collections.Generic.Dictionary<string, byte[]> AttachmentsList = new Dictionary<string, byte[]>();
            

            //something is breaking 
            try
            {
                bool NextPageExists = true;
                string token = refreshToken(suppliedRefreshToken);// "ya29.Gly9BkrrTImyTUo2LP2g_tA5-m5lDyPbJ0oN0zvjuJZH7zRhDiU6yZO6hxXWVrCmjFGqxNf0UH-bx04DCj-QbNMPl74wRSfO9kAqsV0ht4AVkxlwHQO-8aJTSGVPlg";

                var nextPageUrl = "https://www.googleapis.com/gmail/v1/users/" + emailAddress + "/messages";//libraryConfiguration.GetAppSetting("TrustPilot.APIURL");
                while (NextPageExists)
                {

                    WebRequest webReq = WebRequest.Create(nextPageUrl);

                    webReq.Headers.Add("Authorization", "Bearer " + token);

                    webReq.Method = "GET";
                    // Set the content type of the data being posted.
                    //webReq.ContentType = "raw";
                    webReq.ContentType = "application/x-www-form-urlencoded";


                    ServicePointManager.ServerCertificateValidationCallback = (s, cert, chain, ssl) => true;

                    WebResponse webResp = webReq.GetResponse();

                    Stream TokenResponseStream = webResp.GetResponseStream();
                    // read the stream
                    StreamReader tokenResponseReader = new StreamReader(TokenResponseStream);
                    // display the stream

                    string TokenResponseJSON = tokenResponseReader.ReadToEnd();
                    JObject MessagesObject = null;
                    TokenResponseStream.Close();
                    MessagesObject = JObject.Parse(TokenResponseJSON);

                    for (JToken i = MessagesObject.SelectToken("messages").First; i != null; i = i.Next)
                    {
                        string messageID = i.SelectToken("id").ToString();
                        //debug
                        if (messageID == "1692bb8abdbd555a")
                        {

                        }
                        //make a nested web request to get the contents/info of the message
                        string getMessageURL = "https://www.googleapis.com/gmail/v1/users/" + emailAddress + "/messages/" + messageID;

                        WebRequest nestedWebRequest = WebRequest.Create(getMessageURL);
                        nestedWebRequest.Method = "GET";
                        nestedWebRequest.ContentType = "application/x-www-form-urlencoded";
                        nestedWebRequest.Headers.Add("Authorization", "Bearer " + token);
                        WebResponse nestedWebResp = nestedWebRequest.GetResponse();

                        Stream nestedResponseStream = nestedWebResp.GetResponseStream();
                        StreamReader nestedResponseReader = new StreamReader(nestedResponseStream);

                        string nestedResponseJSON = nestedResponseReader.ReadToEnd();
                        JObject nestedMessageObject = null;
                        nestedResponseStream.Close();
                        nestedMessageObject = JObject.Parse(nestedResponseJSON);

                        try
                        {
                            for (JToken j = nestedMessageObject.SelectToken("payload.parts").First; j != null; j = j.Next)
                            {
                                string fileName = j.SelectToken("filename").ToString();
                                if (fileName != "")
                                {
                                    ids += messageID + "\n";
                                    string attachmentID = j.SelectToken("body").SelectToken("attachmentId").ToString();
                                    byte[] data = getAttachment(messageID, emailAddress, attachmentID, token, fileName);
                                    AttachmentsList.Add(fileName, data);
                                }

                            }
                        }
                        catch
                        {

                        }


                        //var test = nestedMessageObject.SelectToken("payload.parts").First;
                        string epochDate = nestedMessageObject.SelectToken("internalDate").ToString();
                        DateTime convertedDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc).AddMilliseconds(long.Parse(epochDate));
                        DateTime now = DateTime.Today.AddDays(-1);
                        if (DateTime.Compare(now, convertedDate) > 0)
                        {
                            NextPageExists = false;
                            break;

                        }

                        //ids += messageID + "\n";
                    }

                    string nextPageToken = null;

                    nextPageToken = MessagesObject.SelectToken("nextPageToken").ToString();

                    nextPageUrl = "https://www.googleapis.com/gmail/v1/users/" + emailAddress + "/messages?pageToken=" + nextPageToken;
                    //Parse json and grab what we want
                    JObject TokenResponseJObject = JObject.Parse(TokenResponseJSON);

                    //string AccessToken = TokenResponseJObject["access_token"].ToString();
                    //string RefreshToken = TokenResponseJObject["refresh_token"].ToString();

                    //string quickbaseConnectionString = libraryConfiguration.GetConnectionString("Quickbase");
                    //return;
                }

                //return the attachmentslist as a zip 

                HttpResponse response = HttpContext.Current.Response;
                //string filePath = zipLoc;
                response.Clear();
                response.ClearContent();
                response.ClearHeaders();
                //response.TransmitFile(data);




                using (var CompressedFileStream = new MemoryStream())
                {
                    using (var zipArchive = new ZipArchive(CompressedFileStream, ZipArchiveMode.Update, false))
                    {
                        foreach (var item in AttachmentsList)
                        {
                            var zipEntry = zipArchive.CreateEntry(item.Key);
                            using (var originalFileStream = new MemoryStream(item.Value))
                            {
                                using (var zipEntryStream = zipEntry.Open())
                                {
                                    originalFileStream.CopyTo(zipEntryStream);
                                }
                            }
                        }


                    }
                    //response.BinaryWrite(data);
                    response.BinaryWrite(CompressedFileStream.ToArray());
                    response.Buffer = true;
                    response.ContentType = "application/pdf";
                    response.AddHeader("Content-Disposition", "attachment;filename=" + DateTime.Now.ToString() + ".zip");
                    response.Flush();
                    //response.End();


                }

                //stop here

                return ids;

            }
            catch (Exception ex)
            {
                //WriteToTrustPilotLog("1", "CommunicationLibrary", "GetNewTrustPilotAccessToken()", "Error occured while trying to call TrustPilot API \nError:" + ex.ToString());
                return "";
            }
        }

        private string refreshToken(string actualRefreshToken)
        {
            string googleplus_client_id = "316651371589-sb93p6suqkt2797vpsrv61qrtim5t9b1.apps.googleusercontent.com";    // Replace this with your Client ID
            string googleplus_client_secret = "y-6VZyyhO7hfNHrQX7qJJOLw";                                                // Replace this with your Client Secret
            string googleplus_redirect_url = "http://localhost:54158/Receiver.aspx"; //"http://localhost:8080";                                         // Replace this with your Redirect URL; Your Redirect URL from your developer.google application should match this URL.
            string Parameters;

            //Added the authorization string to app config
            //"ZUc0M0dFRnl5V0RXbGIwS1hGcmpURVduRXcyalR5bjA6Y3pSRnhyeEpMNERrVEFnVQ==";
            try
            {

                var googleURL = "https://www.googleapis.com/oauth2/v4/token";//libraryConfiguration.GetAppSetting("TrustPilot.APIURL");
                WebRequest webReq = WebRequest.Create(googleURL);

                //webReq.Headers.Add("Authorization", authorization);

                webReq.Method = "POST";
                // Set the content type of the data being posted.
                //webReq.ContentType = "raw";
                webReq.ContentType = "application/x-www-form-urlencoded";

                //add body
                //Stream PostBodyWriteStream = webReq.GetRequestStream();

                //add the credentials to app config

                Parameters = "client_secret=" + googleplus_client_secret + "&client_id=" + googleplus_client_id + "&grant_type=refresh_token&refresh_token=" + actualRefreshToken;// 1/ENsitwT8ZkSyT0fn1_BX1I5Hf0MUoA_mI1i_O89-6D0";

                ASCIIEncoding encoding = new ASCIIEncoding();
                byte[] byteArray = encoding.GetBytes(Parameters);
                //byte[] PostBodySize = encoding.GetBytes(postData);

                webReq.ContentLength = byteArray.Length;
                Stream postStream = webReq.GetRequestStream();
                // Add the post data to the web request
                postStream.Write(byteArray, 0, byteArray.Length);
                postStream.Close();


                //PostBodyWriteStream.Write(PostBodySize, 0, PostBodySize.Length);
                //PostBodyWriteStream.Close();

                //perform request and get response
                //HttpWebResponse webResp = (HttpWebResponse)webReq.GetResponse();
                ServicePointManager.ServerCertificateValidationCallback = (s, cert, chain, ssl) => true;

                WebResponse webResp = webReq.GetResponse();

                Stream TokenResponseStream = webResp.GetResponseStream();
                // read the stream
                StreamReader tokenResponseReader = new StreamReader(TokenResponseStream);
                // display the stream

                string TokenResponseJSON = tokenResponseReader.ReadToEnd();

                //Parse json and grab what we want
                JObject TokenResponseJObject = JObject.Parse(TokenResponseJSON);

                string AccessToken = TokenResponseJObject["access_token"].ToString();
                //string RefreshToken = TokenResponseJObject["refresh_token"].ToString();

                //string quickbaseConnectionString = libraryConfiguration.GetConnectionString("Quickbase");
                return AccessToken;

            }
            catch (Exception ex)
            {
                //WriteToTrustPilotLog("1", "CommunicationLibrary", "GetNewTrustPilotAccessToken()", "Error occured while trying to call TrustPilot API \nError:" + ex.ToString());
                return "";
            }

        }

        private byte[] getAttachment(string messageID, string userID, string attachmentID, string token, string fileName)
        {

            string url = "https://www.googleapis.com/gmail/v1/users/" + userID + "/messages/" + messageID + "/attachments/" + attachmentID;
            WebRequest webReq = WebRequest.Create(url);

            webReq.Headers.Add("Authorization", "Bearer " + token);

            webReq.Method = "GET";
            // Set the content type of the data being posted.
            //webReq.ContentType = "raw";
            webReq.ContentType = "application/x-www-form-urlencoded";


            ServicePointManager.ServerCertificateValidationCallback = (s, cert, chain, ssl) => true;

            WebResponse webResp = webReq.GetResponse();

            Stream TokenResponseStream = webResp.GetResponseStream();
            // read the stream
            StreamReader tokenResponseReader = new StreamReader(TokenResponseStream);
            // display the stream

            string TokenResponseJSON = tokenResponseReader.ReadToEnd();
            JObject MessagesObject = null;
            TokenResponseStream.Close();
            MessagesObject = JObject.Parse(TokenResponseJSON);

            String attachData = MessagesObject.SelectToken("data").ToString().Replace('-', '+');
            attachData = attachData.Replace('_', '/');
            byte[] data = Convert.FromBase64String(attachData);
            //File.WriteAllBytes(Path.Combine(@"C:\Users\jlau\Desktop", fileName), data);

            //*******
           


            //*******





            return data;

           

        }

        private string getRefreshToken(string code)
        {
            string googleplus_client_id = "316651371589-sb93p6suqkt2797vpsrv61qrtim5t9b1.apps.googleusercontent.com";    // Replace this with your Client ID
            string googleplus_client_secret = "y-6VZyyhO7hfNHrQX7qJJOLw";                                                // Replace this with your Client Secret
            string googleplus_redirect_url = //"http://localhost:54158/Receiver.aspx";
                "https://kingsstoreinternational.com/receiver";
                //"http://localhost:62805/Receiver.aspx";

            string Parameters;

            var googleURL = "https://www.googleapis.com/oauth2/v4/token";//libraryConfiguration.GetAppSetting("TrustPilot.APIURL");

            WebRequest webReq = WebRequest.Create(googleURL);

            //webReq.Headers.Add("Authorization", authorization);

            webReq.Method = "POST";
            // Set the content type of the data being posted.
            //webReq.ContentType = "raw";
            webReq.ContentType = "application/x-www-form-urlencoded";

            //add body
            //Stream PostBodyWriteStream = webReq.GetRequestStream();

            //add the credentials to app config

            //parameters need scope,clientid,redirect,code,granttype,clientsecret
            Parameters = "scope=https://mail.google.com/"
                + "&client_id=" + googleplus_client_id
                + "&redirect_uri=" + googleplus_redirect_url
                + "&code=" + code
                + "&grant_type=authorization_code"
                + "&client_secret=" + googleplus_client_secret
                ;//"client_secret=" + googleplus_client_secret + "&client_id=" + googleplus_client_id + "&grant_type=refresh_token&refresh_token=1/ENsitwT8ZkSyT0fn1_BX1I5Hf0MUoA_mI1i_O89-6D0";

            ASCIIEncoding encoding = new ASCIIEncoding();
            byte[] byteArray = encoding.GetBytes(Parameters);
            //byte[] PostBodySize = encoding.GetBytes(postData);

            webReq.ContentLength = byteArray.Length;
            Stream postStream = webReq.GetRequestStream();
            // Add the post data to the web request
            postStream.Write(byteArray, 0, byteArray.Length);
            postStream.Close();


            //PostBodyWriteStream.Write(PostBodySize, 0, PostBodySize.Length);
            //PostBodyWriteStream.Close();

            //perform request and get response
            //HttpWebResponse webResp = (HttpWebResponse)webReq.GetResponse();
            ServicePointManager.ServerCertificateValidationCallback = (s, cert, chain, ssl) => true;

            WebResponse webResp = webReq.GetResponse();

            Stream TokenResponseStream = webResp.GetResponseStream();
            // read the stream
            StreamReader tokenResponseReader = new StreamReader(TokenResponseStream);
            // display the stream

            string TokenResponseJSON = tokenResponseReader.ReadToEnd();

            //Parse json and grab what we want
            JObject TokenResponseJObject = JObject.Parse(TokenResponseJSON);



            return TokenResponseJObject.SelectToken("refresh_token").ToString();
        }

        protected void DownloadAttachments_Click(object sender, EventArgs e)
        {
            getMessages(EmailID.Text, RefreshTokenBox.Text);
        }
    }
}