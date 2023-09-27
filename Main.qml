import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: root
    property int rectSize: 10
    property var snake: [0]
    property int direction: Qt.Key_Right
    property int maxX: 50
    property int foodIdx: Math.floor(Math.random() * maxX * maxX)
    width: maxX * rectSize
    height: width
    visible: true
    title: qsTr("Hello World")

    GridLayout {
        anchors.fill: root
        rows: maxX
        columns: rows
        columnSpacing: 0
        rowSpacing: 0
        focus: true
        Repeater {
            id: repeater
            model: 2500
            Rectangle {
                required property int index
                width: rectSize
                height: rectSize
                border.color: Qt.black
                border.width: 0
                color: "yellow"
            }
        }
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Up) {
                direction = Qt.Key_Up;
            } else if (event.key === Qt.Key_Down) {
                direction = Qt.Key_Down;
            } else if (event.key === Qt.Key_Right) {
                direction = Qt.Key_Right;
            }else if (event.key === Qt.Key_Left) {
                direction = Qt.Key_Left;
            }
        }
    }

    function restart() {
        for (const oldId of snake) {
            repeater.itemAt(oldId).color = "yellow"
        }
        snake.splice(1, snake.length - 1);
        snake[0] = 0;
        direction = Qt.Key_Right;
        update();
    }

    function update() {
        let last = snake[snake.length - 1];
        let x = last % maxX;
        let y = Math.floor(last / maxX);
        if (direction === Qt.Key_Right) {
            x = x == maxX - 1 ? 0 : x + 1;
        } else if (direction === Qt.Key_Left) {
            x = x == 0 ? maxX - 1 : x - 1;
        } else if (direction === Qt.Key_Up) {
            y = y == 0 ? maxX - 1 : y - 1;
        } else if (direction === Qt.Key_Down) {
            y = y == maxX - 1 ? 0 : y + 1;
        }
        let newIdx = y * maxX + x;
        if (newIdx === foodIdx) {
            foodIdx = Math.floor(Math.random() * maxX * maxX);
            repeater.itemAt(foodIdx).color = "green"
        } else {
            for (const id of snake) {
                if (newIdx === id) {
                    restart();
                    return;
                }
            }

            repeater.itemAt(snake[0]).color = "yellow";
            snake.splice(0, 1);
        }
        snake.push(newIdx);

        repeater.itemAt(newIdx).color = "red";
        repeater.itemAt(foodIdx).color = "green";
    }


    Timer {
        id: timer
        interval: 100
        repeat: true
        running: true

        onTriggered: {
           update()
        }
    }
}
