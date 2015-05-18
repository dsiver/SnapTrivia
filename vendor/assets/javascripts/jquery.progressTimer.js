
var interval;
var pgbar;

(function ($) {
    $.fn.progressTimer = function (options) {
		var settings = $.extend({}, $.fn.progressTimer.defaults, options);

        this.each(function () {
            $(this).empty();
            var barContainer = $("<div>").addClass("progress active progress-striped");
            var bar = $("<div>").addClass("progress-bar").addClass(settings.baseStyle)
                .attr("role", "progressbar")
                .attr("aria-valuenow", "0")
                .attr("aria-valuemin", "0")
                .attr("aria-valuemax", settings.timeLimit);

            bar.appendTo(barContainer);
            barContainer.appendTo($(this));

            pgbar = bar;

            var start = new Date();
            var limit = settings.timeLimit * 1000;
            interval = window.setInterval(function () {
                var elapsed = new Date() - start;
                bar.width(((elapsed / limit) * 100) + "%");

                if (limit - elapsed <= 5000)
                    bar.removeClass(settings.baseStyle)
                       .removeClass(settings.completeStyle)
                       .addClass(settings.warningStyle);

                if (elapsed >= limit) {
                    window.clearInterval(interval);

                    bar.removeClass(settings.baseStyle)
                       .removeClass(settings.warningStyle)
                       .addClass(settings.completeStyle);

                    settings.onFinish.call(this);
                }

            }, 250);

        });

        return this;
    };


    $.fn.progressTimer.defaults = {
        timeLimit: 30,  //total number of seconds
        warningThreshold: 5,  //seconds remaining triggering switch to warning color
        onFinish: function () { resetInterval },  //invoked once the timer expires
		baseStyle: '',  //bootstrap progress bar style at the beginning of the timer
        warningStyle: 'progress-bar-danger',  //bootstrap progress bar style in the warning phase
        completeStyle: 'progress-bar-success'  //bootstrap progress bar style at completion of timer
    };
}(jQuery));

function stopTimer(){
    clearInterval(interval);
}

function resetInterval(){
    interval = window.setInterval(function () {
        var elapsed = new Date() - start;
        pgbar.width(((elapsed / 30000) * 100) + "%");
    }, 250)
}