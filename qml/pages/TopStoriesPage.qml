/*
  The MIT License (MIT)
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
//import harbour.sailhn 1.0
Page {
property string topurl: "https://hacker-news.firebaseio.com/v0/topstories.json"
property string itemurl: "https://hacker-news.firebaseio.com/v0/item/"


function getstories(){
            var xhr = new XMLHttpRequest;
        xhr.open("GET", topurl);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText);

                for (var i=0;i<=50;i++){
                    getitem(data[i]);
                }
        }
        }
            xhr.send();
        }
function getitem(i){
            var xhr = new XMLHttpRequest;
        xhr.open("GET", itemurl + i + ".json");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText);
                

      listView.model.append({ttitle: data.title, storyid: data.id, descendants: data.descendants});
           
        }
        }
            xhr.send();
    }


    property bool storiesLoadedOnce: false

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        anchors.fill: parent
            header: PageHeader {
                title: 'Top stories'
            }
            anchors.top: header.bottom

            model: ListModel { id: model}
         delegate: ListItem {
                width: parent.width
                height: Theme.itemSizeMedium
                
                Label {
                    text: ttitle
                }
            
                    onClicked: {
                     pageStack.push("Story.qml", {ttitle: ttitle, storyid: storyid, descendants: descendants});
                    
                }
            }
                
            }

    Component.onCompleted: {
                getstories();
    }
        
}
