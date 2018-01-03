// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.
//
//= require jquery-2.2.0.min
//= require jquery-ui-1.8.24.min
//= require bootstrap
//= require toastr
//= require_tree .
//= require_self

toastr.options = {
    "closeButton": false,
    "debug": false,
    "newestOnTop": true,
    "progressBar": false,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "slideDown",
    "hideMethod": "fadeOut"
}

if (typeof jQuery !== 'undefined') {
    (function($) {
        $(document).ajaxStart(function() {
            $('#processing:hidden').show();
            $(".overlay").show();
        }).ajaxStop(function() {
            $("#processing").fadeOut();
            $(".overlay").hide();
        });
    })(jQuery);
}
$(document).ready(function() {
    if(!$('#facility').is(':visible')){
       $('.onlyOnAdminPage').hide();
    }
    $('form input').on('keypress', function(e) {
        return e.which !== 13;
    });
});
