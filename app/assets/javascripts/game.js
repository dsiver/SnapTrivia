var colors = ["#00CC00", "#0000FF", "#009999", "#FF7400", "#FFFF00", "#FF0000", "#ffffff"];
var subject = ["Art", "Geography", "History", "Sports", "Entertainment", "Science", "Bonus"];

var startAngle = 0;
var spinAngleStart = 0;
var arc = Math.PI / 3.5;
var spinTimeout = null;

var spinTime = 0;
var spinTimeTotal = 0;

var ctx;
var spinnerCanvas;
var subjectText;

<!-- Spinner Wheel   -->
function drawRouletteWheel() {
    spinnerCanvas = document.getElementById("wheelcanvas");


    function drawBtnPush1() {
        var centerX = spinnerCanvas.width / 2;
        var centerY = spinnerCanvas.height / 2;
        ctx.beginPath();
        ctx.arc(centerX, centerY, insideRadius, 0, 2 * Math.PI, false);
        ctx.fillStyle = "white";
        ctx.fill();
        ctx.lineWidth = 5;
        ctx.strokeStyle = '#003300';
        ctx.stroke();
    }

    if (spinnerCanvas.getContext) {
        var outsideRadius = 200;
        var textRadius = 160;
        var insideRadius = 50;

        ctx = spinnerCanvas.getContext("2d");
        ctx.clearRect(0, 0, 500, 500);


        ctx.strokeStyle = "black";
        ctx.lineWidth = 2;

        ctx.font = 'bold 12px Helvetica, Arial';

        for (var i = 0; i < 7; i++) {
            var angle = startAngle + i * arc;
            ctx.fillStyle = colors[i];

            ctx.beginPath();
            ctx.arc(250, 250, outsideRadius, angle, angle + arc, false);
            ctx.arc(250, 250, insideRadius, angle + arc, angle, true);
            ctx.stroke();
            ctx.fill();

            ctx.save();
            drawBtnPush1();

            ctx.fillStyle = "black";
            ctx.translate(250 + Math.cos(angle + arc / 2) * textRadius,
                250 + Math.sin(angle + arc / 2) * textRadius);
            ctx.rotate(angle + arc / 2 + Math.PI / 2);
            var text = subject[i];
            ctx.fillText(text, -ctx.measureText(text).width / 2, 0);
            ctx.restore();
        }

        ctx.font = 'bold 30px Helvetica, Arial';
        ctx.fillStyle = '#293333';
        //ctx.fillStyle = "white";
        var push = "Push";
        ctx.fillText(push, 215, 260);
        ctx.restore();

//Arrow
        ctx.fillStyle = "black";
        ctx.beginPath();
        ctx.moveTo(250 - 4, 250 - (outsideRadius + 5));
        ctx.lineTo(250 + 4, 250 - (outsideRadius + 5));
        ctx.lineTo(250 + 4, 250 - (outsideRadius - 5));
        ctx.lineTo(250 + 9, 250 - (outsideRadius - 5));
        ctx.lineTo(250 + 0, 250 - (outsideRadius - 13));
        ctx.lineTo(250 - 9, 250 - (outsideRadius - 5));
        ctx.lineTo(250 - 4, 250 - (outsideRadius - 5));
        ctx.lineTo(250 - 4, 250 - (outsideRadius + 5));
        ctx.fill();
    }

}

function spin() {
    spinAngleStart = Math.random() * 10 + 10;
    spinTime = 0;
    spinTimeTotal = Math.random() * 3 + 4 * 1000;
    rotateWheel();
}

function rotateWheel() {
    spinTime += 30;
    if (spinTime >= spinTimeTotal) {
        stopRotateWheel();
        return;
    }
    var spinAngle = spinAngleStart - easeOut(spinTime, 0, spinAngleStart, spinTimeTotal);
    startAngle += (spinAngle * Math.PI / 180);
    drawRouletteWheel();
    spinTimeout = setTimeout('rotateWheel()', 30);
}

function stopRotateWheel() {
    clearTimeout(spinTimeout);
    var degrees = startAngle * 180 / Math.PI + 90;
    var arcd = arc * 180 / Math.PI;
    var index = Math.floor((360 - degrees % 360) / arcd);
    ctx.save();

    subjectText = subject[index];

    if(subjectText == "Bonus"){
        LaunchSubjectModal();
    }
    else
    {
        LaunchQuestion(subjectText);
    }

}

function LaunchQuestion(subject_title) {
    var gameID = document.getElementById("game_id").innerHTML
    var url = '/game/ask_question?subject=' + subject_title + "&game_id=" + gameID + "&bonus=false";
    Turbolinks.visit(url);
}


function LaunchSubjectModal(){
    $('#select_subject').modal('show');
}



function easeOut(t, b, c, d) {
    var ts = (t /= d) * t;
    var tc = ts * t;
    return b + c * (tc + -3 * ts + 3 * t);
}


