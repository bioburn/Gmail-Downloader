<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Receiver.aspx.cs" Inherits="GmailDownloader.Receiver" MasterPageFile="~/Site.Master" %>


<asp:Content ID="myContent" ContentPlaceHolderID="MainContent" runat="server">

    <body>

        <div>
            <h1>Gmail Attachments Downloader by Jackey Lau
            </h1>
            <br />
            <br />
            <div class="col-lg-12">
                <asp:HyperLink ID="testLink" runat="server" Text="For First Time Authorization Click Here"></asp:HyperLink>
            </div>

            <br />
            <div class="col-sm-3">
                Refresh Token:
                <asp:TextBox CssClass="input-group-lg" ID="RefreshTokenBox" runat="server"></asp:TextBox>
            </div>
            <div class="col-sm-3">
                Email Address: 
            <asp:TextBox CssClass="input-group-lg" ID="EmailID" runat="server"></asp:TextBox>
                <asp:Button ID="DownloadAttachments" CssClass="btn btn-primary" runat="server" Text="Download" OnClick="DownloadAttachments_Click" />

            </div>
            <br />
        </div>
        <br />
        <br />
        <br />
        <br />
        <div class="col-sm-6">
            Data processed from the gmail api is not transmitted to any third party entities nor the application creator.
        </div>
        <br />
        <div class="col-sm-12">
            Instructions:
            <br />
            <br />
            1. Click the link above if you are using the application for the first time or if you have lost your token.
            <br />
            Authorizing this application on your gmail account will provide you with a token. Keep this saved for future use.
            <br />
            2. After either the application or the user provides a token to the refresh token input field, type in the email address that was authorized for this token.
            <br />
            3. Hit the download button to save a zip file of all attachments in your inbox from the previous day.
            <br />
            <br />
        </div>
        <br />
        <br />

        <div class="col-sm-12">
            Coming Soon:
            <br />
            -Ability to specify date range
            <br />
            -Cleaner UI
            <br />
            -Ability to filter what attachments to download (eg. by type, filename, sender, etc...)
            <br />
            <br />
        </div>

    </body>

</asp:Content>



