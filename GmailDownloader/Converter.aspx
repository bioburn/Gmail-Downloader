<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Converter.aspx.cs" Inherits="GmailDownloader.Converter" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <div>
        Command String Builder
        <br />
        <br />
        Translated:
        <br />
            <p id="p2">
                <textarea id="p" style="width:512px;height:100px;"></textarea>
            </p>
            <div class="btn-group">
                 <button class="btn btn-primary" onclick="deleteNode()" type="button" id="deleteButton">Delete</button>
                 <button class="btn btn-primary" onclick="append(12)" type="button" id="newLine">Next Line</button>
            </div>
           
      
          

            
        <br />
        <div>
            <b>Select Input Type: </b>
            <select class="btn btn-info dropdown dropdown-toggle" onchange="changeButtonText()" id="inputFrom">
                <option value="0">Universal</option>
                <option value="1">PlayStation</option>
                <option value="2">XBox</option>
                <option value="3">Switch</option>
            </select>
        </div>
        <div>
            <b>Select Directional Type: </b>
            <select class="btn btn-info dropdown dropdown-toggle" id="directionalInput">
                <option value="0">BDUF</option>
                <option value="1">Arrows</option>
                <option value="2">Numerical</option>
            </select>
        </div>
        <div>
            <B>Select Output Type: </B>
              
            <select class="btn btn-info dropdown dropdown-toggle" id="console">
                <option value="0">PlayStation</option>
                <option value="1">XBox</option>
                <option value="2">Switch</option>
            </select> <br />
            <button class="btn btn-success" onclick="translateTest()" type="button">Convert! </button>
        </div>
        <br />


        <div class="btn-group">
          
                <button class="btn btn-primary" onclick="append(13)" type="button">Jump</button>
                <button class="btn btn-primary" onclick="append(14)" type="button">Amplify</button>
                <button class="btn btn-primary" onclick="append(15)" type="button">+</button>
            </div>

            <div>
                <table id="directionals">
                    <tr>
                        <td>
                             <table style="width: 100px">
                    <tr>
                        <td id="upleft">
                            <button style="display:block;margin:auto" class="btn btn-info" onclick="append(8)" type="button">&#x2196;</button>
                        </td>
                        <td id="up">
                            <button class="btn btn-info" onclick="append(5)" type="button">&uarr;</button>

                        </td>
                        <td id="upright">
                            <button style="display:block;margin:auto" class="btn btn-info" onclick="append(9)" type="button">&#x2197;</button>
                        </td>
                    </tr>
                    <tr>
                        <td id="left">
                            <button class="btn btn-info" onclick="append(4)" type="button">&larr;</button>
                        </td>
                        <td></td>
                        <td id="right">
                            <button class="btn btn-info" onclick="append(7)" type="button">&rarr;</button>
                        </td>
                    </tr>
                    <tr>
                        <td id="downleft">
                            <button style="display:block;margin:auto" class="btn btn-info" onclick="append(10)" type="button">&#x2199;</button>
                        </td>
                        <td id="down">
                            <button class="btn btn-info" onclick="append(6)" type="button">&darr;</button>
                        </td>
                        <td id="downright">
                            <button style="display:block;margin:auto" class="btn btn-info" onclick="append(11)" type="button">&#x2198;</button>
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
                            <button class="btn btn-warning" id="triangle" onclick="append(0)" type="button">2<%--&#x25B3;--%></button> 

                        </td>
                        <td>
                           
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <button class="btn btn-primary" id="square" onclick="append(1)" type="button">1<%--&#x25A2;--%></button>
                        </td>
                        <td></td>
                        <td>
                            <button class="btn btn-danger" id="circle" onclick="append(3)" type="button">4<%--&#x25EF;--%></button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            
                        </td>
                        <td>
                            <button class="btn btn-success" id="x" onclick="append(2)" type="button">3<%--X--%></button>
                        </td>
                        <td>
                            
                        </td>
                    </tr>
                </table>
                        </td>
                    </tr>
                   
                </table>
               
              
            </div>


            <div >
                <table >
                    <tr>
                        <td>Commands to Save:</td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <textarea class="panel panel-info" disabled="disabled" id="inputTextToSave" style="width: 512px; height: 256px;background-color:aqua"></textarea>
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
                //NEEDS BETTER DOCUMENTATION
                //Will document the structure and flow

                var paragraph = document.getElementById("inputTextToSave");
                var lastNode = null;
                var stack = [];

                //var textToAppend = document.getElementById("input").textContent;

                //var text = document.createTextNode(textToAppend);

                //paragraph.appendChild(text);
                //paragraph.removeChild(text);
                //paragraph.textContent += "Test";

                //*** brainstorming for structure
                //first dropdown determines starting input type
                //depending on this value, the buttons will produce the 'inputs' based on the mapping table


                //here's the table of button values that correspond to each command
                var inputMap = { key: ["value1", "value2", "value3" , "value4"] };
                inputMap.one = ["1", "▢", "X", "Y"];
                inputMap.two = ["2", "△", "Y", "X"];
                inputMap.three = ["3", "X", "A", "B"];
                inputMap.four = ["4", "O", "B", "A"];

                //here's where I'm going to put the table of directional values
                var directionalMap = { key: ["value1", "value2", "value3"] };
                directionalMap.left = ["B", "←", "4"];
                directionalMap.right = ["F", "→", "6"];
                directionalMap.up =["U","↑","8"];
                directionalMap.down =["D","↓","2"];
                directionalMap.upleft=["UB","↖","7"];
                directionalMap.upright=["UF","↗","9"];
                directionalMap.downleft=["DB","↙","1"];
                directionalMap.downright=["DF","↘","3"];


                function append(id) {

                    var e = document.getElementById("inputFrom");
                    var index = e.options[e.selectedIndex].value;

                    var f = document.getElementById("directionalInput");
                    var directionalIndex = f.options[f.selectedIndex].value;


                    var textToAppend = '';
                    switch (id) {
                        case 0://triangle/y/2
                            textToAppend = inputMap.two[index] +" ";//'2 ';
                            break;
                        case 1://square/x/1
                            textToAppend = inputMap.one[index]+" ";//"1 ";
                            break;
                        case 2://X/A/3
                            textToAppend = inputMap.three[index]+" ";//"3 ";
                            break;
                        case 3://circle/B/4
                            textToAppend = inputMap.four[index]+" ";//"4 ";
                            break;
                        case 4:
                            textToAppend = directionalMap.left[directionalIndex] + " "; //"B ";//"← ";
                            break;
                        case 5:
                            textToAppend = directionalMap.up[directionalIndex] + " "; //"U ";//"↑ ";
                            break;
                        case 6:
                            textToAppend = directionalMap.down[directionalIndex] + " "; //"D ";//"↓ ";
                            break;
                        case 7:
                            textToAppend = directionalMap.right[directionalIndex] + " "; //"F ";//"→ ";
                            break;

                        case 10:
                            textToAppend = directionalMap.downleft[directionalIndex] + " "; //"DB ";//"↙ ";
                            break;


                        case 11:
                            textToAppend = directionalMap.downright[directionalIndex] + " "; //"DF ";//"↘ ";
                            break;


                        case 8:
                            textToAppend = directionalMap.upleft[directionalIndex] + " "; //"UB ";//'↖ ';
                            break;


                        case 9:
                            textToAppend = directionalMap.upright[directionalIndex] + " "; //"UF ";//"↗ ";
                            break;

                        case 12:
                            textToAppend = "\n";
                            break;

                        case 13:
                            textToAppend = "J ";
                            break;

                        case 14:
                            textToAppend = "AMP ";
                            break;
                        case 15:
                            textToAppend = "+ ";
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

               

                function translateTest() {
                    var e = document.getElementById("console");
                    var selectedItem = e.options[e.selectedIndex].value;
                    var toConsole = 0;
                    switch (selectedItem) {
                        case "1":
                            toConsole = 1;
                            break;
                        case "2":
                            toConsole = 2;
                            break;
                        
                    }


                    var test = document.getElementById("p");

                    var text = document.createTextNode("a");

                    var mapping = { key: ["value1", "value2", "value3"] };
                    mapping.one = ["▢ ", "X ", "Y "];
                    mapping.two = ["△ ", "Y ", "X "];
                    mapping.three = ["X ", "A ", "B "];
                    mapping.four = ["O ", "B ", "A "];

                    console.log(mapping.one);
                    console.log(mapping.four[0]);
                    console.log(stack);

                    var newlineNode = document.createTextNode("\n");

                    stack.forEach(function (element)
                    {
                        var elementText = "";
                        elementText = element.nodeValue;
                        console.log(elementText);
                        switch (elementText) {
                            case "2 "://2
                                text = document.createTextNode(mapping.two[toConsole]);
                                break;
                            case "1 "://1
                                text = document.createTextNode(mapping.one[toConsole]);
                                break;
                            case "4 "://4
                                text = document.createTextNode(mapping.four[toConsole]);
                                break;
                            case "3 "://3
                                text = document.createTextNode(mapping.three[toConsole]);
                                break;
                            default: text = element.cloneNode(true);
                        }

                        var isEqualNode = element.isEqualNode(newlineNode);
                        console.log(isEqualNode);
                        if (isEqualNode) {
                            text = document.createTextNode("\n");
                        }
                        console.log(element);
                        console.log("final : ");
                        console.log(text);
                        //var index = 0;
                        //var text = document.createTextNode(mapping.four[index]);
                        test.appendChild(text);
                        //don't use append, should concatenate instead...
                    });
                    //stack holds the entire command string
                    //traverse it and convert each element
                    //use this function individually
                    //command is the individual command
                    //need to build a mapping between all inputs...
                    //let's construct a mapping like this:
                    //[universal input id] : [playstation] : [Xbox]
                    //game input?
                    //when translate button gets hit, take the array of the stack and traverse.
                    //for each element in array going forward, depending on the from and to type, get the corresponding item from the array
                    test.appendChild(document.createTextNode("\n"));

                }

                function changeButtonText() {
                    var e = document.getElementById("inputFrom");
                    var index = e.options[e.selectedIndex].value;

                    //need to set 4 buttons
                    document.getElementById("square").innerHTML = inputMap.one[index];
                    document.getElementById("triangle").innerHTML = inputMap.two[index];
                    document.getElementById("x").innerHTML = inputMap.three[index];
                    document.getElementById("circle").innerHTML = inputMap.four[index];
                }



                //***This snippet saves the textarea value to a text file


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
