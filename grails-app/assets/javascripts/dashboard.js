var FormAcceptMsg = 'Form Accepted'
var AcceptFormURL = 'acceptReviewForm'
var DisplaySearchURL = 'displaySearchResults'
var SearchEmpURL = 'searchForEmployee'
var UnAssignMSHsUserURL = 'unAssignMSHSUser'
var FetchDeptQLforFacilityURL = 'fetchDeptQlForFacility'
var FetchQLforFacilityURL = 'fetchQlForFacility'
var GetDatForUnassignedUserURL = 'getDataForUnassignUser'
var JsonType = 'json'
var MSHS = 'MSHS'
var HtmlType = 'html'
var UserNameId = 'username'
var EmpError = 'empError'
var ErrorMsg = 'errorMsg'
var Assign = 'assign'
var Unassign = 'unassign'
var Lead = 'lead'
var FacilityId = "facility"
var LeadSelect = 'leadSelect'
var InfoEmpNameMsg = "Please enter Employee Name"
var ValidEmpEmailMsg = "Please enter valid email"
var EmptyStr = " "
var Unassign_Facility = 'unassign_facility'
var Unassign_Department = 'unassign_department'
var Unassign_Email = 'unassign_email'
var Unassign_Speciality = 'unassign_speciality'
var EmpResult = 'employeeResult'
var EmpResultDialog = 'employeeResultDialog'
var Specialty = " Specialty"
var DateFieldWarningMsg = 'Date fields can not be blank'
var FromDateCompleted = 'fromDateCompleted'
var FromDeathDate = 'fromDeathDate'
var DateDeathFirstRadio = 'dateDeathFirstRadio'
var DateDeathSecRadio = 'dateDeathSecRadio'
var DateCompeltedFirstRadio = 'dateCompletedFirstRadio'
var SelectFacilityDeptSpecMSG = "Please select Hospital, Department and Specialty"
var searchEmpAndSelect = "Please search and select employee name"
var emailRequiredError = "Employee Email is required";
var refreshTime = 1000;
/**
 * Action to update the Lead or Reviwer in Mortality Review Form ,if user accepts form.
 * @return
 */
function acceptReviewForm(id, status) {
    $.ajax({
        url: AcceptFormURL,
        cache: false,
        dataType: JsonType,
        data: {reviewId: id, status: status},
        success: function (data) {
            if (data.STATUS == SUCCESS) {
                $(".overlay").hide();
                toastr[Success](FormAcceptMsg)
                setTimeout(function () {
                    location.reload()
                }, refreshTime);
            } else {
                toastr[ERROR](ErrorMsg_ContactAdmin)
            }

        },
        error: function () {
            toastr[ERROR](ErrorMsg_ContactAdmin)
        }
    });
}

function searchEmplList() {

    // var emailReg = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
    var lastName = $('#username').val();
    if (lastName == '') {
        $('#username').addClass('error');
        $("#empError").show().text(searchEmpAndSelect);
    }else{
        $("#empError").text('');
        $.ajax({
                url: SearchEmpURL,
            cache: false,
                dataType: HtmlType,
            data: {lastName: lastName},
            success: function (data) {
                    if(data){
                        $("#" + EmpResult).html(data)
                        $("#" + EmpResultDialog).modal({backdrop: 'static', keyboard: false});
                    }
            },
            error: function () {
                    toastr[ERROR](ErrorMsg_ContactAdmin)
            }
        });
    }


}

function validateEmail() {
    var emailReg = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
    var email = emailReg.test($('#' + UserNameId).val())
    if (!email) {
        $('#' + UserNameId).addClass('error');
        $("#" + EmpError).show().text(ValidEmpEmailMsg);
        $('#searchEmployee').attr('disabled', true)
    } else {
        $('#' + UserNameId).removeClass('error');
        $("#" + EmpError).show().text(EmptyStr);
        $('#searchEmployee').attr('disabled', false)

    }
}

function removeErrorClass() {
    $('#' + UserNameId).removeClass(ERROR);
    $("#" + EmpError).show().text(EmptyStr);

}

function adminSearch(obj) {
    if (validateDates()) {
        return;
    }
    $this = $(obj)
    $.ajax({
        url: DisplaySearchURL,
        cache: false,
        dataType: HtmlType,
        data: $('[name=adminSearchForm]').serialize(),
        success: function (data) {

            $("#adminDashboard").html(data);
            showHideAdminGroup()
            //toastr.success('search success');
        },
        error: function () {
            toastr.error(ErrorMsg_ContactAdmin);
        }
    });
}

function updateDeptQl(obj) {
    var dischargingDivisionLabel
    if($("#facility").val() == ''){
        dischargingDivisionLabel = ''
    }else{
        dischargingDivisionLabel = $("#facility :selected").text().split(" (")[1].split(")")[0];
    }
    $("#speciality").val('');
    $this = $(obj)
    $.ajax({
        url: FetchDeptQLforFacilityURL,
        cache: false,
        dataType: HtmlType,
        data: {facilityId: $this.val()},
        success: function (data) {
            $("#form_dept_ql").html(data)
            if($("#facility").val() == '') {
                $("#dischargeDivisionId").html("MSHS Specialty");
            }else{
                $("#dischargeDivisionId").html(dischargingDivisionLabel + Specialty);
            }
        },
        error: function () {
            toastr.error(ErrorMsg_ContactAdmin);
        }
    });
}

function hideDateOfDeathDatePicker(obj) {
    $this = $(obj);
    $("#dateOfDeath").datepicker('enable');

}

function hideDateCompleteDatePicker(obj) {
    $this = $(obj);
    $("#dateCompleted").datepicker('enable');

}

function updateQl(obj) {
    $this = $(obj);
    var role = $this.val();
    var facilityId = $("#" + FacilityId).val()
    $.ajax({
        url: FetchQLforFacilityURL,
        cache: false,
        dataType: HtmlType,
        dataType: HtmlType,
        data: {facilityId: facilityId, role: role},
        success: function (data) {
            $("#form_ql").html(data)
        },
        error: function () {
            toastr.error(ErrorMsg_ContactAdmin);
        }
    });
}

function validateDates() {
    $(".toast-message").trigger('click')
    var isError = false;
    var countOfError = 0;
    if ($("#dateDeathFirstRadio").is(":checked")) {
        if ($("#dateOfDeath").val() == '') {
            countOfError++;
        }
    }
    if ($("#dateDeathSecRadio").is(":checked")) {
        if ($("#fromDeathDate").val() == '' || $("#toDeathDate").val() == '') {
            countOfError++;
        }
    }

    if ($("#dateCompletedFirstRadio").is(":checked")) {
        if ($("#dateCompleted").val() == '') {
            countOfError++;
        }
    }
    if ($("#dateCompletedSecRadio").is(":checked")) {
        if ($("#fromDateCompleted").val() == '' || $("#toDateCompleted").val() == '') {
            countOfError++;
        }
    }

    if (countOfError > 0) {
        isError = true;
        toastr[ERROR](DateFieldWarningMsg)
    }
    return isError;
}

$(document).ready(function () {
    jQuery.browser = {};
    (function () {
        jQuery.browser.msie = false;
        jQuery.browser.version = 0;
        if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
            jQuery.browser.msie = true;
            jQuery.browser.version = RegExp.$1;
        }
    })();


    //Validation for from and to date
    $(function () {
        $("#fromDateCompleted, #dateCompleted, #fromDeathDate , #dateOfDeath, #toDateCompleted, #toDeathDate").datepicker({
            numberOfMonths: 1,
            maxDate: 0,
            onSelect: function (selected) {
                var dt = new Date(selected);
                dt.setDate(dt.getDate() + 1);
                if ($(this).attr('id') == FromDateCompleted) {
                    $("#toDateCompleted").datepicker("option", "minDate", dt);
                } else if ($(this).attr('id') == FromDeathDate) {
                    $("#toDeathDate").datepicker("option", "minDate", dt);
                }
                autoSearchCondition()
            }
        });
    });

    var reviewers = [];

    /*$("#reviewerSelect option").each(function () {
        reviewers.push({
                'value': $(this).val(),
                'label': $(this).text()
            }
        )
    });*/

    /*$("#reviewer").autocomplete({
        minLength: 0,
        source: reviewers,
        focus: function (event, ui) {
            $("#reviewer").val(ui.item.label)
            $("#reviewer").trigger('change');
            return false;
        },
        select: function (event, ui) {
            $("#reviewer").val(ui.item.label);
            $("#reviewer").trigger('change');
            $("#reviewerSelect").val(ui.item.value);
            return false;
        }
    });
*/
    var ads = [];

    $("#adSelect option").each(function () {
        ads.push({
                'value': $(this).val(),
                'label': $(this).text()
            }
        )
    });

    /* $("#username").autocomplete({
     minLength: 0,
     source: ads,
     focus: function (event, ui) {
     $("#username").val(ui.item.label);
     return false;
     },
     select: function (event, ui) {
     $("#username").val(ui.item.label);
     $("#adSelect").val(ui.item.value);
     return false;
     }
     });*/

    var leads = [];

    $("#leadSelect option").each(function () {
        leads.push({
                'value': $(this).val(),
                'label': $(this).text()
            }
        )
    });

    $("#" + Lead).autocomplete({
        minLength: 0,
        source: leads,
        focus: function (event, ui) {
            $("#lead").val(ui.item.label);
            return false;
        },
        select: function (event, ui) {
            $("#lead").val(ui.item.label);
            $("#" + LeadSelect).val(ui.item.value);
            return false;
        },
        change: function (event, ui) {
            showUnassignData()
        }
    });

    automaticSearch();
    showHideAdminGroup();

    if( $('input:radio[id="dateDeathFirstRadio"]').is(":checked")){
        $('#dateOfDeathFirstDiv').show();
        $('#dateOfDeathSecondDiv').hide();
        $("#dateDeathSecRadio input:radio").attr('checked', false);

    }
   if( $('input:radio[id="dateDeathSecRadio"]').is(":checked")){
       $('#dateOfDeathFirstDiv').hide();
       $('#dateOfDeathSecondDiv').show();
         }

    if($('input:radio[id="dateCompletedFirstRadio"]').is(":checked")){
        $('#dateCompletedFirstDiv').show();
        $('#dateCompletedSecDiv').hide();

    }
   if($('input:radio[id="dateCompletedSecRadio"]').is(":checked")){
       $('#dateCompletedFirstDiv').hide();
       $('#dateCompletedSecDiv').show();
   }

    $('.onlyOnReportPage').hide();

    // Admin screen From date and to date hide and show fields
    $('input[type="radio"]').click(function () {
        if ($(this).attr('id') == DateDeathFirstRadio) {
            $('#dateOfDeathFirstDiv').show();
            $('#dateOfDeathSecondDiv').hide();
            $("#dateDeathSecRadio input:radio").attr('checked', false);
            $("#fromDeathDate").val("")
            $("#toDeathDate").val("")
        } else if ($(this).attr('id') == DateDeathSecRadio) {
            $('#dateOfDeathFirstDiv').hide();
            $('#dateOfDeathSecondDiv').show();
            $("#dateOfDeath").val("")
        } else if ($(this).attr('id') == DateCompeltedFirstRadio) {
            $('#dateCompletedFirstDiv').show();
            $('#dateCompletedSecDiv').hide();
            $("#dateCompletedSecRadio input:radio").attr('checked', false);
            $("#fromDateCompleted").val("")
            $("#toDateCompleted").val("")
        } else if ($(this).attr('id') == 'dateCompletedSecRadio') {
            $('#dateCompletedFirstDiv').hide();
            $('#dateCompletedSecDiv').show();
            $("#dateCompleted").val("")
        }
    });

    $('#showreport').hide();
    $("#watch_showreport").click(function () {
        $("#showreport").show();
    });

    $("#assignQl").show();
    $("#unassignQl").hide();

    if($("#facility").length>0 && $("#facility").val() != ''){
        dischargingDivisionLabel = $("#facility :selected").text().split(" (")[1].split(")")[0];
        $("#dischargeDivisionId").html(dischargingDivisionLabel + Specialty);
    }
});

// Run Report to show Mortality Trigger Tool Summary Report/Time to Completion Divs

/* var divs = ["mortalityTriggerToolSummary", "timeToCompletion"];
 var visibleDivId = null;

 function divVisibility(divId) {
 if (visibleDivId === divId) {
 visibleDivId = null;
 } else {
 visibleDivId = divId;
 }
 hideNonVisibleDivs();
 }

 function hideNonVisibleDivs() {
 var i, divId, div;
 for (i = 0; i < divs.length; i++) {
 divId = divs[i];
 div = document.getElementById(divId);
 if (visibleDivId === divId) {
 div.style.display = "block";
 } else {
 div.style.display = "none";
 }
 }
 }*/

$('a').on('click', function () {
    var target = $(this).attr('rel');
    $("#" + target).show().siblings("div").hide();
});

$(document).on("click", ".datePicker", function () {
    var clickedBtnID = $(this); // or var clickedBtnID = this.id

    clickedBtnID.datepicker();
    clickedBtnID.datepicker("show");
    // alert('you clicked on button #' + clickedBtnID);
});

    function showUnassignChange(obj) {
        $("#assignQl").hide();
        $("#unassignQl").show();
        $("#error").text('');
        $("#"+ErrorMsg).text('');
        $("#"+EmpError).text('');
        $("#empReq").text('');
        $("#"+UserNameId).val('');
        $("#"+FacilityId).val('');
        $("#department").val('');
        $("#speciality").val('');
        $("#"+Unassign).prop('checked', true);
        $("#"+Assign).prop('checked', false);
        $("#empName").val('');
        $("#assignEmailId").val('');
    }

function showAssignChange(obj) {
    $("#assignQl").show();
    $("#unassignQl").hide();
    $("#error").text('');
    $("#" + ErrorMsg).text('');
    $("#" + EmpError).text('');
    $("#empReq").text('');
    $('#' + Unassign_Facility).val('');
    $('#' + Unassign_Department).val('');
    $('#' + Unassign_Speciality).val('');
    $('#' + Unassign_Email).val('');
    $("#" + Lead).val('');
    $("#" + Unassign).prop('checked', false);
    $("#" + Assign).prop('checked', true);
}

function getDepartmentList(obj) {
    $this = $(obj);
    var facility = $("#" + FacilityId).val();
    var username = $("#username").val();
    var empName = $("#empName").val();
    var assignEmailId = $("#assignEmailId").val();
    $.ajax({
        url: 'getDataForAssignUser',
        cache: false,
        dataType: 'html',
        data: {facility: facility},
        success: function (data) {
            $("#assignQl").html(data);
            $('#facility').prop('selectedIndex', facility);
            $("#username").val(username);
            $("#empName").val(empName);
            $("#assignEmailId").val(assignEmailId);
           },
        error: function () {
            $("#assignQl").html(data);
            toastr.error(ErrorMsg_ContactAdmin);
        }

    });
}

function getSepcialityList(obj) {
    $this = $(obj);
    var department = $("#department").val();
    var facility = $("#" + FacilityId).find("option:selected").prop("value");
    var username = $("#username").val();
    var empName = $("#empName").val();
    var assignEmailId = $("#assignEmailId").val();
    $.ajax({
        url: 'getDataForAssignUser',
        cache: false,
        dataType: 'html',
        data: {department: department, facility: facility},
        success: function (data) {
            $("#assignQl").html(data);
            $('#facility').val(facility);
            $('#department').val(department);
            $("#username").val(username);
            $("#empName").val(empName);
            $("#assignEmailId").val(assignEmailId);
          },
        error: function () {
            toastr.error(ErrorMsg_ContactAdmin);

            }
        });
    }

function showUnassignData() {

    $("#error").text('');
    $("#" + ErrorMsg).text('');
    $("#" + EmpError).text('');
    $("#empReq").text("")
    var leadId = $("#" + LeadSelect).val();
    if ($("#" + Lead).val() != '' && $('#' + Unassign_Facility) != '') {

        $.ajax({
                url: GetDatForUnassignedUserURL ,
            cache: false,
                dataType: JsonType,
            data: {leadId: leadId},
            success: function (data) {
                    $('#'+Unassign_Facility).val(data.facility);
                    $('#'+Unassign_Department).val(data.department);
                    $('#'+Unassign_Speciality).val(data.speciality);
                    $('#'+Unassign_Email).val(data.emailId);
            },
            error: function () {
                    toastr.error(ErrorMsg_ContactAdmin);

            }
        });
    } else {
            $('#'+Unassign_Facility).val('');
            $('#'+Unassign_Department).val('');
            $('#'+Unassign_Speciality).val('');
            $('#'+Unassign_Email).val('');
            $("#"+Lead).val('')
    }
}

function assignQl() {

    $("#error").text('');
    var username = $("#empName").val();
    var empEmail = $("#assignEmailId").val();
    var facility = $("#"+FacilityId).val();
    var department = $("#department").val();
    var speciality = $("#speciality").val();

    if(username !='' && facility != '' && department != '' &&  speciality != '' && empEmail != '') {
        $.ajax({
            url: 'assignMSHSUserAsQL',
            cache: false,
            dataType: JsonType,
            data: {
                username: username,
                email: empEmail,
                facility: facility,
                department: department,
                speciality: speciality
            },
            success: function (data) {
                    if (data.STATUS == SUCCESS) {
                        toastr[Success](data.MESSAGE)

                } else {
                    $("#error").text(data.MESSAGE)
                }
                    $("#"+Assign).prop('checked', true);
                    $("#"+Unassign).prop('checked', false);
            },
            error: function () {
                    $("#"+Assign).prop('checked', true);
                    $("#"+Unassign).prop('checked', false);
                    toastr.error(ErrorMsg_ContactAdmin);

            }
        });
    } else {
        $("#empError").text('');
        if(username == ''){
                $("#empError").text(searchEmpAndSelect)
        } else if(empEmail == '') {
                $("#empError").text(emailRequiredError )
        }else if(facility == '' || department == '' || speciality == '') {
            $("#error").text(SelectFacilityDeptSpecMSG )
        }
    }
}


function submitUnAssignUser() {
        $("#"+ErrorMsg).text('');
        $("#"+EmpError).text('');
        $("#empReq").text('');

    var username = $("#" + LeadSelect).find("option:selected").prop("text");
    var userId = $("#" + LeadSelect).find("option:selected").prop("value");
    var facility = $("#" + Unassign_Facility).val();
    var department = $("#" + Unassign_Department).val();
    var speciality = $("#" + Unassign_Speciality).val();
    if (userId != '' && facility != '') {
        $.ajax({
            url: UnAssignMSHsUserURL,
            cache: false,
            dataType: JsonType,
            data: {
                username: username,
                userId: userId,
                facility: facility,
                department: department,
                speciality: speciality
            },
            success: function (data) {
                if (data.STATUS == SUCCESS) {
                    $(".overlay").hide();
                    toastr[Success](data.MESSAGE)
                    setTimeout(function () {
                        location.reload()
                    }, refreshTime);
                    $('#' + Unassign_Facility).val('');
                    $('#' + Unassign_Department).val('');
                    $('#' + Unassign_Speciality).val('');
                    $('#' + Unassign_Email).val('');
                    $("#" + Lead).val('')
                    $("#" + Assign).prop('checked', false);
                    $("#" + Unassign).prop('checked', true);

                    } else {
                    $("#"+ErrorMsg).text(data.MESSAGE)
                    $("#"+Assign).prop('checked', false);
                    $("#"+Unassign).prop('checked', true);
                }

                },
            error: function () {
                $("#" + Assign).prop('checked', false);
                $("#" + Unassign).prop('checked', true);
                toastr.error(ErrorMsg_ContactAdmin);

            }
        });
    } else {
        $("#empReq").text(InfoEmpNameMsg)
    }
}

function showReport(reportDiv) {
    $(".iframeDiv").hide()
    $("#" + reportDiv).show()
}

function setEmpInfo() {
    $('input[name="lead"]').prop('checked', false);
    var empSelected = $("#selectedEmployee:checked")
    $("#empName").val($(empSelected).data("empname"))
    $("#assignEmailId").val($(empSelected).data("empemail"))
    $("#empEmail").val($(empSelected).data("empemail"))
}


function showUnassignWarning() {
    $('#unassignWarningMsgId').show();
}

function hideUnassignWarning() {
    $('#unassignWarningMsgId').hide();
}

function automaticSearch(){
    $("#adminSearchForm").on("change",function(){
        autoSearchCondition()
    });
}

function autoSearchCondition(){
    if($("#dateDeathFirstRadio").is(":checked") && ($("#dateOfDeath").val()=='')){
        return
    }
    else if($("#dateDeathSecRadio").is(":checked") && ($("#fromDeathDate").val() =='' || $("#toDeathDate").val()=='')){
        return
    }
    else if($("#dateCompletedFirstRadio").is(":checked") && ($("#dateCompleted").val()=='')){
        return
    }
    else if($("#dateCompletedSecRadio").is(":checked") && ($("#fromDateCompleted").val()=='' || $("#toDateCompleted").val()=='')){
        return
    }
    else{
        adminSearch()
    }
}

function showHideAdminGroup(){
    var formStatus = $("input[name='formStatus']:checked").val();
    if (formStatus == UNASSIGNED) {
        $("#complete_div").hide()
    } else if (formStatus == SUBMITTED || formStatus == AMENDED) {
        $("#unassigned_div").hide()
        $("#incomplete_div").hide()
    }
}

function sendReminderNotification(reviewId,status) {

    $.ajax({
        url: 'sendReminder',
        cache: false,
        dataType: JsonType,
        data: {reviewId: reviewId,status:status},
        success: function (data) {
            if (data.STATUS == SUCCESS) {
                toastr[Success](data.MESSAGE)
            } else {
                toastr[ERROR](data.MESSAGE)
            }
        },
        error: function () {
            toastr[ERROR](ErrorMsg_ContactAdmin);
        }
    });
}