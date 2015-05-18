

$("#progressTimer").progressTimer({
    onFinish: function() {
        stopTimer();
    }
});

$(function () {
    var loading = $('#loadbar').hide();
    timerSound.play();

    $(document)
        .ajaxStart(function () {
            loading.show();
        }).ajaxStop(function () {
            loading.hide();
        });

    $("label.btn").on('click', function () {
        stopTimer();
        var choice = $(this).find('input:radio').val();
        $('#loadbar').show();
        $('#quiz').fadeOut();
        setTimeout(function () {
            $("#answer").html($(this).checking(choice));
            $('#quiz').show();
            $('#loadbar').fadeOut();
        }, 1500);
    });

    $ans = document.getElementById("correct_ans").innerHTML;
    $.fn.checking = function (ck) {
        var game_ID = document.getElementById("game_id").innerHTML;
        var subject = document.getElementById("subject").innerHTML;
        var bonus = document.getElementById("bonus").innerHTML;
        var question_id = document.getElementById("question_id").innerHTML;
        var result = "";
        if (ck != $ans) {
            result = "INCORRECT";
            bonus = "false";
            $('#rate_question').modal('show');
            wrongSound.play();
        }
        else {
            result = "CORRECT";
            $('#rate_question').modal('show');
            rightSound.play();
        }


        $('#rate_question').on('hidden.bs.modal', function () {
            var rating_selection = document.getElementById("rating");
            var question_rating = rating_selection.options[rating_selection.selectedIndex].value;
            var url = '/game/question_results?result=' + result + "&subject_title=" + subject + "&game_id=" + game_ID + "&bonus=" + bonus + "&rating=" + question_rating;
            Turbolinks.visit(url);
        })

    };
});

$('#time').on('click', function () {
    var $btn = $(this).button('loading')
    // business logic...
    $btn.button('reset')
})

$('#half').on('click', function () {
    var $btn = $(this).button('loading')

    var first = document.getElementById("first_answer");
    var second = document.getElementById("second_answer");
    var third = document.getElementById("third_answer");
    var fourth = document.getElementById("fourth_answer");
    var correct_answer_index = document.getElementById("correct_answer_index");

    var wrong1_index = document.getElementById("wrong_answer_1_index").innerHTML;
    var wrong2_index = document.getElementById("wrong_answer_2_index").innerHTML;


    if(wrong1_index == 0 || wrong2_index == 0 && correct_answer_index != 0){
        first.className = "element-animation1 btn btn-lg btn-danger btn-block";
    }
    if(wrong1_index == 1 || wrong2_index == 1 && correct_answer_index != 1){
        second.className = "element-animation1 btn btn-lg btn-danger btn-block";
    }
    if(wrong1_index == 2 || wrong2_index == 2 && correct_answer_index != 2){
        third.className = "element-animation1 btn btn-lg btn-danger btn-block";
    }
    if(wrong1_index == 3 || wrong2_index == 3 && correct_answer_index != 3){
        fourth.className = "element-animation1 btn btn-lg btn-danger btn-block";
    }

    $btn.button('reset');
});

$('#skip').on('click', function () {
    var $btn = $(this).button('loading')
    var game_id = document.getElementById("game_id").innerHTML;
    var subject = document.getElementById("subject").innerHTML;
    var url = '/game/ask_question?game_id=' + game_id + "&subject=" + subject;
    Turbolinks.visit(url);
    $btn.button('reset');
});
