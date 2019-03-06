<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CommandBuilder.aspx.cs" Inherits="GmailDownloader.CommandBuilder" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <div>
            <p id="p">
                Command String Builder
            </p>
            <%--<textarea id="input"></textarea>
            <button onclick="myFunction()" type="button" id="inputButton">Build</button>--%>
            <button class="btn btn-primary" onclick="deleteNode()" type="button" id="deleteButton">Delete</button>
            <button class="btn btn-primary" onclick="append(12)" type="button" id="newLine">Next Line</button>
            <div>
                <%--<button onclick="append(0)" type="button">&#x25B3;</button>
                <button onclick="append(1)" type="button">&#x25A2;</button>
                <button onclick="append(2)" type="button">X</button>
                <button onclick="append(3)" type="button">&#x25EF;</button>--%>
                <button class="btn btn-primary" onclick="append(13)" type="button"> + </button>
                <button class="btn btn-primary" onclick="append(14)" type="button"> S </button>
            </div>
            <%-- <div>
                <button onclick="append(4)" type="button">LEFT</button>
                <button onclick="append(5)" type="button">UP</button>
                <button onclick="append(6)" type="button">DOWN</button>
                <button onclick="append(7)" type="button">RIGHT</button>
            </div>--%>

            <div>
                <table>
                    <tr>
                        <td>
                             <table style="width: 100px">
                    <tr>
                        <td>
                            <button class="btn btn-info" onclick="append(8)" type="button">&#x2196;</button>
                        </td>
                        <td align="center">
                            <button class="btn btn-info" onclick="append(5)" type="button">&uarr;</button>

                        </td>
                        <td>
                            <button class="btn btn-info" onclick="append(9)" type="button">&#x2197;</button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <button class="btn btn-info" onclick="append(4)" type="button">&larr;</button>
                        </td>
                        <td></td>
                        <td>
                            <button class="btn btn-info" onclick="append(7)" type="button">&rarr;</button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <button class="btn btn-info" onclick="append(10)" type="button">&#x2199;</button>
                        </td>
                        <td>
                            <button class="btn btn-info" onclick="append(6)" type="button">&darr;</button>
                        </td>
                        <td>
                            <button class="btn btn-info" onclick="append(11)" type="button">&#x2198;</button>
                        </td>
                    </tr>
                </table>
                        </td>
                        <td>
                              <table style="width: 100px">
                    <tr>
                        <td>
                           
                        </td>
                        <td align="center">
                            <button class="btn btn-warning" id="triangle" onclick="append(0)" type="button">&#x25B3;</button> 

                        </td>
                        <td>
                           
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <button class="btn btn-primary" id="square" onclick="append(1)" type="button">&#x25A2;</button>
                        </td>
                        <td></td>
                        <td>
                            <button class="btn btn-warning" id="circle" onclick="append(3)" type="button">&#x25EF;</button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            
                        </td>
                        <td>
                            <button class="btn btn-success" id="x" onclick="append(2)" type="button">X</button>
                        </td>
                        <td>
                            
                        </td>
                    </tr>
                </table>
                        </td>
                    </tr>
                   
                </table>
               
              
            </div>

            <div>
                <table>
                    <tr>
                        <td>Commands to Save:</td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <textarea disabled="disabled" id="inputTextToSave" style="width: 512px; height: 256px"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>Filename to Save As:</td>
                        <td>
                            <input id="inputFileNameToSaveAs"></input></td>
                        <td>
                            <button onclick="saveTextAsFile()">Save Text to File</button></td>
                    </tr>
                    <tr>
                        <td>Select a File to Load:</td>
                        <td>
                            <input type="file" id="fileToLoad">
                            <td>
                                <button onclick="loadFileAsText()">Load Selected File</button><td>
                    </tr>
                </table>
            </div>
            <script>
                var paragraph = document.getElementById("inputTextToSave");
                var lastNode = null;
                var stack = [];

                //var textToAppend = document.getElementById("input").textContent;

                //var text = document.createTextNode(textToAppend);

                //paragraph.appendChild(text);
                //paragraph.removeChild(text);
                //paragraph.textContent += "Test";

                function append(id) {
                    var textToAppend = '';
                    switch (id) {
                        case 0:
                            textToAppend = '2 ';
                            break;
                        case 1:
                            textToAppend = "1 ";
                            break;
                        case 2:
                            textToAppend = "3 ";
                            break;
                        case 3:
                            textToAppend = "4 ";
                            break;
                        case 4:
                            textToAppend = "B ";
                            break;
                        case 5:
                            textToAppend = "U ";
                            break;
                        case 6:
                            textToAppend = "D ";
                            break;
                        case 7:
                            textToAppend = "F ";
                            break;

                        case 10:
                            textToAppend = "DB ";
                            break;


                        case 11:
                            textToAppend = "DF ";
                            break;


                        case 8:
                            textToAppend = "UB ";
                            break;


                        case 9:
                            textToAppend = "UF ";
                            break;

                        case 12:
                            textToAppend = "\n";
                            break;

                        case 13:
                            textToAppend = "+ ";
                            break;

                        case 14:
                            textToAppend = "S "
                            break;

                    }

                    //textToAppend += ' ';
                    var text = document.createTextNode(textToAppend);
                    paragraph.appendChild(text);
                    stack.push(text);
                }

                function myFunction() {
                    var textToAppend = document.getElementById("input").value;

                    var text = document.createTextNode(textToAppend);
                    paragraph.appendChild(text);
                    lastNode = text;
                    stack.push(text);
                    document.getElementById("input").value = '';
                }

                function deleteNode() {
                    paragraph.removeChild(stack.pop());
                }

               

                function translate(command, type) {
                    //stack holds the entire command string
                    //traverse it and convert each element
                    //use this function individually
                    //command is the individual command
                    //need to build a mapping between all inputs...
                    //let's construct a mapping like this:
                    //[universal input id] : [playstation] : [Xbox]
                    //game input?

                }




                function saveTextAsFile() {
                    var textToWrite = document.getElementById("inputTextToSave").value;
                    var textFileAsBlob = new Blob([textToWrite], { type: 'text/plain' });
                    var fileNameToSaveAs = document.getElementById("inputFileNameToSaveAs").value;

                    var downloadLink = document.createElement("a");
                    downloadLink.download = fileNameToSaveAs;
                    downloadLink.innerHTML = "Download File";
                    if (window.webkitURL != null) {
                        // Chrome allows the link to be clicked
                        // without actually adding it to the DOM.
                        downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
                    }
                    else {
                        // Firefox requires the link to be added to the DOM
                        // before it can be clicked.
                        downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
                        downloadLink.onclick = destroyClickedElement;
                        downloadLink.style.display = "none";
                        document.body.appendChild(downloadLink);
                    }

                    downloadLink.click();
                }

                function destroyClickedElement(event) {
                    document.body.removeChild(event.target);
                }

                function loadFileAsText() {
                    var fileToLoad = document.getElementById("fileToLoad").files[0];

                    var fileReader = new FileReader();
                    fileReader.onload = function (fileLoadedEvent) {
                        var textFromFileLoaded = fileLoadedEvent.target.result;
                        document.getElementById("inputTextToSave").value = textFromFileLoaded;
                    };
                    fileReader.readAsText(fileToLoad, "UTF-8");
                }


            </script>
        </div>


</asp:Content>
