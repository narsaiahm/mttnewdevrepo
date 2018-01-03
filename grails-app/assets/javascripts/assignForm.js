var ADMIN = 'ADMIN'
var UNASSIGNED = 'UNASSIGNED'
var QUALITY_LEAD = 'QUALITY_LEAD'
var ADHOC = 'ADHOC'
var AssignQLMsg ='Please assign CQL or Clinical Reviewer'
var InvalidReviewerMsg = 'Invalid Clinical Reviewer'
var REVIEWER = 'reviewer'
var REVIEWERSELECT = 'reviewerSelect'
var searchEmpAndSelect = "Please search and select employee name"
var emailRequiredError = "Employee Email is required"
var sameLeadErrorMsg = "Selected Clinical Quality Lead/Reviewer is already assigned to this form. Please select different Clinical Quality Lead/Reviewer";
$(document).ready(function () {

    $('.table tbody tr').click(function (event) {
        if (event.target.type !== 'radio') {
            $(':radio', this).trigger('click');
        }
    });

    if ($('#status').val() != 'UNASSIGNED') {
        var leadId = $('#leadId').val()
        if ($('#role').val() == QUALITY_LEAD) {
            $('input:radio[name="lead"]').filter('[value="' + leadId + '"]').attr('checked', true);
        } else if ($('#role').val() == ADHOC) {
            $("#"+REVIEWERSELECT).val(leadId);
            $("#"+REVIEWER).val($("#"+REVIEWERSELECT+" option:selected").text())

        }
    }

    if ($('#status').val() != UNASSIGNED) {
        $('#assignReviewForm')
            .each(function () {
                $(this).data('serialized', $(this).serialize())
            })
            .on('change input', function () {
                $(this)
                    .find('input:submit')
                    .attr('disabled', $(this).serialize() == $(this).data('serialized'));
            })
            .find('input:submit')
            .attr('disabled', true);
    }
});

/*
 *Action to validate assignReviewForm and set selected user to hidden field
 */
function assignedUserNameValidation() {

    var reviewInput = $("#"+REVIEWER).val()
    var empName = $('#empName').val();
    var empEmail = $("#empEmail").val();
    var leadName = $("input[name='lead']:checked").data('leadname');
    var selectedLeadId = $("input[name='lead']:checked").data('leadid');
    var currentLeadId = $("#leadId").val();
    $("#userEmailId").val(empEmail);
    var assignedUserName = $('#assignedUserName').val();

    if (leadName == null && empName == '') {
        toastr["error"](AssignQLMsg)
        return false
    }
    if ((leadName == '' || leadName == null) && empName != '') {
        if (empName == '') {
            $("#empError").text(searchEmpAndSelect);
            return false
        } else if (empEmail == '') {
            $("#empError").text(emailRequiredError);
            return false
        }
    }
    else if(selectedLeadId == currentLeadId){
        $("#empError").text(sameLeadErrorMsg);
        $('#submitReviewLead').attr('disabled',true)
        return false
    }

    if (assignedUserName != '' && empName !='' && assignedUserName.trim() == empName.trim()){
        $("#empError").text(sameLeadErrorMsg);
        return false
    }
    if (leadName) {
        $("#assignedUser").val(leadName);
        return true
    } else if (empName) {
        $("#assignedUser").val(empName);
        return true
    }
}
/*
 *Action to clear lead selection if user selects reviwer
 */
function clearLead() {
    $('input[name="lead"]').prop('checked', false);

}
/*
 *Action to clear reviwer selection if user selects lead
 */
function clearReview() {
    $("#"+REVIEWER).val('')
    $("#"+REVIEWERSELECT).val('');
    $("#empName").val('');
    $("#assignEmailId").val('');
    $("#empError").text('');
}

function searchReviewerList() {

    var reviewer=$('#reviewer').val();
    if ( reviewer == '') {
        $('#reviewer').addClass('error');
        $("#empError").show().text(searchEmpAndSelect);
    }else{
        $("#empError").text('');
        $.ajax({
            url: SearchEmpURL,
            cache: false,
            dataType: HtmlType,
            data: {lastName: reviewer},
            success: function (data) {
                if(data){
                    $("#employeeResult").html(data)
                    $("#employeeResultDialog").modal({backdrop: 'static', keyboard: false});
                }
            },
            error: function () {
                toastr[ERROR](ErrorMsg_ContactAdmin)
            }
        });
    }
}

function removeErrorClass(){
    $('#reviewer').removeClass(ERROR);
    $("#" + EmpError).show().text(EmptyStr);
}





