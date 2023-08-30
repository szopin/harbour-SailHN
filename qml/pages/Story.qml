import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: commentpage
    allowedOrientations: Orientation.All
    property string storyid
    property string content
    property string source: "https://hacker-news.firebaseio.com/v0/item/"
    property string intro
    property var kids
    property int descendants
    property int commentcount
    property int kidsl
    property string url
    property string ttitle
    property string discussion
    property bool deleted
    

    
             function gettopcomments(story, ind){

            var xhr = new XMLHttpRequest;
            xhr.open("GET", source + story + ".json");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var data = JSON.parse(xhr.responseText);
                 if (data.kids !==0){
                for (var k=0;k<=data.kids.length;k++){
                  getcomments(data.kids[k], ind);
                 }
                }
                }
                }
            
            xhr.send();
        
    }


         function getcomments(kidid, ind){
        
            var xhr2 = new XMLHttpRequest;
            xhr2.open("GET", source + kidid + ".json", 1);
            xhr2.onreadystatechange = function() {
                if (xhr2.readyState === XMLHttpRequest.DONE) {
                    var data2 = JSON.parse(xhr2.responseText);

                if(data2 !== undefined && data2 !== "" && kidid){
              var  kids2 = data2.kids
               data2.deleted !== undefined && data2.deleted ? deleted = true :  deleted = false
                     kids2 && kids2 !== undefined ?  kidsl = kids2.length : kidsl =0

list.model.append({comment: data2.text, indent: ind, nickname: data2.by, parent: data2.parent, cid: data2.id, time: data2.time, kids: kidsl, deleted: deleted});
                    
              if (kids2 !== undefined && kids2 !== 0){                
                    for (var j = 0; j<=kids2.length;j++){                     
                        getcomments(kids2[j], ind +1);                     
                    }
                }
                }
            }  
        }
            xhr2.send();       
    }

    function sortcomments(){ 

            for(var i = 0; i < list.count; i++){
        
            if(list.model.get(i).parent != storyid){
            
                for (var j=0;j<i;j++){
                    if(list.model.get(j).cid == list.model.get(i).parent){

                    for(var k=0;k<list.model.get(j).kids;k++){

                    if(list.model.get(j+k+1).parent !==  list.model.get(i).parent){
                        list.model.move(i,j+k +1,1);

                        break;
                    }
                    }
                } 
                }
            }
        }
    }


       
    SilicaListView {
        id: list
        header: PageHeader {
            title: ttitle
            id: pageHeader
        }
        width: parent.width
        height: parent.height
        anchors.top: header.bottom
        VerticalScrollDecorator {}
        
        ViewPlaceholder {
            id: vplaceholder
            enabled: list.model.count < descendants
            text: "Loading..."
        onEnabledChanged: sortcomments()
            }

        model: ListModel { id: commodel}

          delegate: Item {
            visible: !deleted
            width: list.width
            height: !deleted ? cid.height : 0

            anchors  {
                left: parent.left
                right: parent.right

                }
              Repeater {
                model: indent
                
                   Rectangle {

                    color: index % 2 ? "orange" : "blue"
                    anchors {
                        top: parent.top
                        left: parent.left
                        leftMargin:  Theme.paddingMedium * index
                        bottom: parent.bottom
                        }
                    width: 1
                    }
                }
            Column{
                    anchors.fill: parent
                    spacing: Theme.paddingLarge
            Label {
                id:  cid
                text:" <b>" +  nickname + "</b>: <br> " + comment // " <b>" + nickname + "</b><p><i>" + subject + "</i></p>\n" + comment
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                linkColor : Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    leftMargin: Theme.paddingMedium * indent
                    rightMargin: Theme.paddingSmall
                    left: parent.left
                    right: parent.right
                    }
                onLinkActivated: {
                    var dialog = pageStack.push("OpenLinkDialog.qml", {link: link});
                }
                }
            }
        }
        Component.onCompleted: {
            
         commentpage.gettopcomments(storyid, 0);
        }
    }
}


