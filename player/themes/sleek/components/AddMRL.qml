import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.1
import QmlVlc 0.1

Rectangle {
	property alias textBox: newURL

	visible: false
	anchors.centerIn: parent
	width: fullscreen ? 450 : (parent.width * 0.9) < 394 ? (parent.width * 0.9) : 394
	height: 80
	color: "transparent"
	focus: true
		
	MouseArea {
		hoverEnabled: true
		anchors.fill: parent
	}
	Rectangle {
		height: 30
		width: parent.width - 20
		anchors.top: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		color: "transparent"
		Text {
			text: "Add Media URL"
			font.weight: Font.DemiBold
			font.pointSize: 10
			anchors.verticalCenter: parent.verticalCenter
			color: "#e5e5e5"
		}
		Rectangle {
			height: 20
			width: 20
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			color: "transparent"
			Text {
				font.pointSize: 10
				color: urlClose.containsMouse ? ui.colors.playlistMenu.closeHover : ui.colors.playlistMenu.close
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
				font.family: fonts.icons.name
				text: settings.glyphsLoaded ? ui.icon.closePlaylist : ""
			}
			MouseArea {
				id: urlClose
				cursorShape: Qt.PointingHandCursor
				hoverEnabled: true
				anchors.fill: parent
				onClicked: {
					mousesurface.forceActiveFocus();
					inputAddBox.visible = false;
				}
			}
		}
	}

	TextField {
    	id: newURL
		readOnly: false
		placeholderText: "Magnet URI or Video URL"
		width: (parent.width - 20) * 0.8
		height: parent.height - 40
		anchors.left: parent.left
		anchors.leftMargin: 10
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
		style: TextFieldStyle {
			font.pixelSize: 14
			background: Rectangle {
				radius: 0
				color: "#e5e5e5"
				anchors.fill: parent
			}
		}
		Keys.onReturnPressed: {
			mousesurface.forceActiveFocus();
			inputAddBox.visible = false;
			vlcPlayer.playlist.add(newURL.text);
			playlist.addPlaylistItems(); // Refresh Playlist GUI
		}
		Keys.onEscapePressed: {
			mousesurface.forceActiveFocus();
			inputAddBox.visible = false;
		}
		Keys.onPressed: {
			if(event.modifiers == Qt.ControlModifier) {
				if (event.key == Qt.Key_D) {
					if (typeof settings.preventKey[Qt.ControlModifier+"+"+Qt.Key_D] === "undefined") {
						if (settings.debugPlaylist) {
							if (inputAddBox.visible) inputAddBox.visible = false;
							settings.selectedItem = vlcPlayer.playlist.currentItem;
							inputBox.textBox.text = vlcPlayer.playlist.items[vlcPlayer.playlist.currentItem].mrl;
							inputBox.textBox.selectAll();
							inputBox.visible = true;
							inputBox.textBox.forceActiveFocus();
							return;
						}
					}
				}
			}
		}
    }
	Rectangle {
		width: (parent.width - 20) * 0.2
		height: parent.height - 40
		anchors.right: parent.right
		anchors.rightMargin: 10
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
		color: submitButton.containsMouse ? "#3D3D3D" : "#363636"
		Text {
			anchors.centerIn: parent
			text: "Add"
			font.pointSize: 12
			color: "#e5e5e5"
		}
		MouseArea {
			id: submitButton
			cursorShape: Qt.PointingHandCursor
			hoverEnabled: true
			anchors.fill: parent
			onClicked: {
				mousesurface.forceActiveFocus();
				inputAddBox.visible = false;
				if (newURL.text.indexOf("magnet:?xt=urn:btih:") == 0) {
					fireQmlMessage("[new-torrent]"+newURL.text);
				} else {
					vlcPlayer.playlist.add(newURL.text);
					playlist.addPlaylistItems(); // Refresh Playlist GUI
				}
			}
		}
	}
}