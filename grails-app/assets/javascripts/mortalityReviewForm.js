var str = '\n'
var FormUpdateSuccessMsg = 'Form has been updated'
var AmendmentSuccessMsg = 'Amendment saved'
var MandatoryErrorMsg = 'Please check mandatory questions.'
var SaveBtnName = 'formSaveInReview'
var AskToAnswer = 'Please answer this question.'
var MANDATORY = 'mandatory'
var ERRORDIV = 'errorDiv'
var ERROR = 'error'
var CheckboxNames = ['majorComorbiditiesOnAdmission', 'complicationAcquiredInHosp', 'majorSupportive', 'majorInvasive', 'procedureRelated', 'cause_Of_Death', 'ContributingFactors']
var SUCCESS = "SUCCESS"
var UPDATED = 'UPDATED'
var ACCEPTED = 'ACCEPTED'
var SUBMITTED = 'SUBMITTED'
var TextAreaClassAdded = ['isPatInfoAccurateNo', 'wasPatTransferredFacilityYes', 'isComorbiditiesOther', 'isMedicalError', 'isHospitalOther', 'isTypeOrLocation', 'isSupportiveOther', 'isSergicalProcedure', 'isInvasiveOther', 'isProcedureCardiac', 'isNeurologicalInjury', 'isProcedurePulmonary', 'isInfection', 'isProcedureOther', 'isDeathCauseOther', 'expectedPatToDieAdmissionNo', 'isContFactOther', 'isHospHospAcqInfection']
var FormSaveErrorMsg = 'There is some problem in saving the form.Please try again.'
var ErrorMsg_ContactAdmin = 'There is some error, please contact your system administrator'
var NoHistory = 'No History to Show'
var ADMIN = 'ADMIN'
var ReviewFormOnSave = "reviewFormOnSave"
var COMMENT = 'Comment'
var CheckComment = 'checkComment'
var SaveAmendmentCommentsURL = 'saveAmendmentComments'
var POST = 'POST'
var SaveMortalityFormURL = 'saveMortalityReviewForm'
var SaveAndReviewBtnIdInReviewForm = 'show-Submit'
var SaveBtnIdInReviewForm = 'watch-Submit'
var SaveBtnIdInReviewFormOnSave = 'showSubmit'
var WarningMsgId = 'warningMsgDivId'
var ShowHistoryURL = 'showHistory'
var _Div = '_div'
var ChangeToStatus = 'statusChangeTo'
var _Error = '_error'
var AMENDED = 'AMENDED'
var Success = 'success'

/**
 * function to display the respective clicked tab information on taking the id (divId) of the tab as argument/parameter
 *
 * @param divId
 */
function divVisibility(obj, divId) {
    $(".innertop_div").removeClass('clicked')
    $(obj).addClass('clicked');
    if (!$("#" + divId).is(":visible")) {
        $(".tabDiv").hide()
        $("#" + divId).show()
    }
    hideShowPrevNextBtn()
}

/**
 * function to display the  respective tab information on clicking Next/Previous buttons  depending on the
 * present visible/active/clicked tab by taking isNext as parameter that tells the clicked buttton is Next or previous
 * @param isNext
 */
function moveTab(isNext) {
    var nextActiveDivId = ''
    if (isNext == 1) {
        var activeDivId = $(".innertop_div.clicked").data('divid')
        $('.inner_div>div').hide()
        nextActiveDivId = $('#' + activeDivId).next().attr('id')
        $('#' + activeDivId).next().show()

    } else {
        var activeDivId = $(".innertop_div.clicked").data('divid')
        $('.inner_div>div').hide()
        nextActiveDivId = $('#' + activeDivId).prev().attr('id')
        $('#' + activeDivId).prev().show()
    }
    $('.star').removeClass('clicked');
    $("[data-divid=" + nextActiveDivId + "]").addClass('clicked')
    hideShowPrevNextBtn()
}

/**
 * function to show and hide previous and next button
 */
function hideShowPrevNextBtn() {
    if ($(".innertop_div.clicked").hasClass('first')) {
        $('.prevBtn').addClass('hide')
        $('.nextBtn').removeClass('hide')
    } else if (!$(".innertop_div.clicked").hasClass('first') && !$(".innertop_div.clicked").hasClass('last')) {
        $('.prevBtn').removeClass('hide')
        $('.nextBtn').removeClass('hide')
    } else if ($(".innertop_div.clicked").hasClass('last')) {
        $('.prevBtn').removeClass('hide')
        $('.nextBtn').addClass('hide')
    }
}

/**
 * function to show appropriate rows of the table and adding mandatory class to them
 * @param idToShow : it is the id of the row
 */
function showAppropriateAndAddMandatoryClass(idToShow) {
    $('#' + idToShow).show()
    $('.' + idToShow + 'Option').addClass(MANDATORY)

}

/**
 * function to show appropriate rows of the table and adding mandatory class to them
 * @param idToShow :it is the id of the row
 */
function hideAppropriateAndRemoveMandatoryClass(idToShow) {
    $('#' + idToShow).hide()
    $('#' + idToShow).removeClass(ERRORDIV)
    $('.' + idToShow + 'Option').attr('checked', false)
    $('.' + idToShow + 'Option').removeClass(MANDATORY)
    $('.' + idToShow + 'Option').removeClass(ERROR)
    $('#' + $('.' + idToShow + 'Option').attr('name') + _Error).remove()
}

/**
 *
 *
 */
function disableUnappropriate() {
    $( "#mReviewForm :input" ).not( ".dropReadOnly,.btn,.inputEnable" ).each(function(){
        var thisEle=$(this);
        thisEle.attr('disabled',true)
    })
    $('.prevBtn ,.nextBtn').attr('disabled',true)
}

/**
 *
 */
function showAll() {
    $( ":input" ).not( ".dropReadOnly,.btn" ).each(function(){
        var thisEle=$(this);
        thisEle.attr('disabled',false)
    })
    $('.prevBtn ,.nextBtn').attr('disabled',false)
    $('#' + SaveBtnIdInReviewForm).show();
}
/**
 *
 */
function hospiceOptionClicked(clickedOption,userRole) {
    var clickedOption = $(clickedOption)
    if (clickedOption.hasClass('Yes')) {
        $(".errorDiv").removeClass('errorDiv');
        $(".errorMsg").prev('br').remove();
        $(".errorMsg").remove();
        $(".hideHospiceYes").hide()
        disableUnappropriate()
        if(userRole != ADMIN )
            if(!validateHospiceQuestion()) {
                if ($('#status').val() != SUBMITTED && $('#status').val() != AMENDED && userRole != ADMIN) {
                    $("#hospiceQuesSubmitDialog").modal({backdrop: 'static', keyboard: false});
                    $('#' + SaveAndReviewBtnIdInReviewForm).hide();
                } else {
                    disableUnappropriate()
                    clearHospiceQues()
                    $('#' + SaveAndReviewBtnIdInReviewForm).show();
                }
            }
    }
    else {
        clearHospiceQues()
        $('#' + SaveAndReviewBtnIdInReviewForm).show();
        $(".hideHospiceYes").show()
        $(".errorDiv").removeClass('errorDiv');
        $(".error").removeClass('error')
        $(".errorMsg").hide();
        showAll()
    }

    $('.inputEnable').each(function () {
        var currentElement = $(this)
        currentElement.attr('disabled', false);
    })
    $('.dropReadOnly').each(function () {
        var currentElement = $(this)
        currentElement.attr('disabled', false);
    })
}

function submitThroughHospiceOption() {
    clearUncheckedRespectiveFields();
    $("div.dropReadOnly :input").each(function () {
        $(this).attr('disabled', true)
    });
    $('#reviewId').remove()
    $('#' + ChangeToStatus).val(SUBMITTED)
    return true;
}

var ajaxCallSuccess = false
$(document).ready(function () {
    $('.naCheckbox').each(function () {
        var changedCheckbox = $(this)
        if (changedCheckbox.is(':checked')) {
            changedCheckbox.attr('disabled', false).attr('readonly', true);
        }
    });
    // enabling and disabling the Not Applicable (NA) checkbox in all the Tabs on checking other checkboxes in  the Tab

    $('.naCheckbox').each(function () {
        if ($(this).closest('.tabDiv').find('input:checkbox:not(.naCheckbox):checked').length > 0) {
            $(this).attr('disabled', true);
        }
        else {
            $(this).attr('readonly', false).attr('disabled', false);
        }
    })

    //unchecking and disabling the NA checkbox

    $("input:checkbox:not(.naCheckbox)").click(function () {

        if ($(this).is(':checked')) {
            $('.' + $(this).closest('div.tabDiv').attr('id')).attr('checked', false).attr('disabled', true);

        } else {
            if ($(this).closest('div.tabDiv').find('input[type=checkbox]:checked').length == 0) {
                $('.' + $(this).closest('div.tabDiv').attr('id')).attr('disabled', false);
            }
        }
    });


    //enabling the check on NA checkbox
    $('.naCheckbox').click(function () {
        if (this.checked) {
            $(this).prop('checked', true);
        }
    });


    //making save and review button visible if form is updated
    if ($('#status').val() != UPDATED) {

        $('#' + SaveAndReviewBtnIdInReviewForm).hide();
    } else {
        $('#' + SaveAndReviewBtnIdInReviewForm).show();
    }

    //clearing unnecessary fields
    $('#' + SaveAndReviewBtnIdInReviewForm).on("click", function () {
        clearUncheckedRespectiveFields();
        return true;

    });

    //saving the form by ajax call on clearing unnecessary fields
    $("#" + SaveBtnIdInReviewForm).on("click", function () {
        clearUncheckedRespectiveFields();

        ajaxFormDataSave();
        if ($('#isHospiceYes').is((':checked'))) {
            $('#' + SaveAndReviewBtnIdInReviewForm).hide()
        }
        else
            $('#' + SaveAndReviewBtnIdInReviewForm).show()

    });

    //checking the mandatory comment fields for changes to validate
    $('.' + CheckComment).is('change', function () {

        var noString = /^\s*$/;
        var currentElement = $(this)
        if (currentElement.is(':checked')) {
            if ($('.' + currentElement.attr('name') + COMMENT).val().length < 0 && noString.test(currentElement.val())) {
                $('.' + currentElement.attr('name') + COMMENT).addClass(MANDATORY).addClass(ERROR).addClass(ERRORDIV)

                $('.' + currentElement.attr('name') + COMMENT).after("<br/><span class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ");

            }
            else {
                $('.' + currentElement.attr('name') + COMMENT).removeClass(MANDATORY).removeClass(ERROR).removeClass(ERRORDIV)
            }
        }
        else if (!currentElement.is(':checked')) {
            $('.' + currentElement.attr('name') + COMMENT).removeClass(MANDATORY).removeClass(ERROR).removeClass(ERRORDIV)
        }

    });

    if ($('#isHospiceYes').is((':checked'))) {
        hospiceOptionClicked($('#isHospiceYes'),$('#userRole').val())
        $('#' + SaveAndReviewBtnIdInReviewForm).hide();
    }

    if ($('#isFormEditable').val() == 'false') {
        var allInputs = $(":input")
        allInputs.each(function () {
            if (!$(this).is(":button"))
                $(this).attr('disabled', true);
        });
        $('.inputEnable').each(function () {
            var currentElement = $(this)
            currentElement.attr('disabled', false);
        })

    }

    if (!$("#isHospiceNo").is(":checked")) {
        $(".hideHospiceYes").hide()
        disableUnappropriate()
    }

});
//function to show appropriate options and add mandatory class


//showing warning message
function showWarning() {
    $('#' + WarningMsgId).addClass('warningMsg')
    $('#' + WarningMsgId).html(' <b>&nbsp;You are about to submit your review form, please be aware that all submissions are FINAL.&nbsp;</b>')
}

//hiding warning message
function hideWarning() {
    $('#' + WarningMsgId).html('<b>&nbsp;&nbsp;&nbsp;</b>')
    $('#' + WarningMsgId).removeClass('warningMsg')

}

function showInfoMsg(){
    $('#infoMsg').addClass('warningMsg')
    $('#infoMsg').html('<b>&nbsp;Findings from secondary review should be reported to Risk, discussed at department M & M and report to the Quality Alignment Council.&nbsp;</b>')
}

function hideInfoMsg(){
    $('#infoMsg').html('<b>&nbsp;&nbsp;&nbsp;</b>')
    $('#infoMsg').removeClass('warningMsg')
}

/**
 * function for clearing the un checked fields on depending their controlling checkboxes or radios
 */
function clearUncheckedRespectiveFields() {
    $.each(TextAreaClassAdded, function (index, currentValue) {
        if (!$('#' + currentValue).is(':checked')) {
            $('.' + currentValue + COMMENT).val('')
        }
    });
}


/**
 * function to show amendment div to QL for adding comments
 * @returns {boolean}
 */
function showAmendDiv() {
    $('#amendmentDiv').toggle();
    return false
}

/**
 * function to hide amendment div
 * @returns {boolean}
 */
function closeAmendDiv() {
    $('#amendmentDiv').hide();
    $('#amendErrorId').hide();
    $('#amendmentCommentId').removeClass(ERRORDIV)
    return false
}

/**
 * saving the amendment comment through ajax call after validating
 * @returns {boolean}
 */
function amendmentSave() {
    var amendmentComment = $('#amendmentCommentId');
    var noString = /^\s*$/;
    if (amendmentComment.val().length > 0 && !noString.test(amendmentComment.val())) {
        saveAmendmentComment();
        $("#" + SaveAndReviewBtnIdInReviewForm).hide();
    }
    else {
        amendmentComment.addClass(ERRORDIV);
        $('#amendErrorId').show();
    }
    amendmentComment.focusout(function () {
        if (amendmentComment.val().length > 0 && !noString.test(amendmentComment.val())) {
            $('#amendErrorId').hide();
            amendmentComment.removeClass(ERRORDIV)
        }
        else {
            $('#amendErrorId').show();
            amendmentComment.addClass(ERRORDIV)
        }
    })
    amendmentComment.on('focus', function () {
        $('#amendErrorId').hide();
        amendmentComment.removeClass(ERRORDIV)
    })
    return false
}


/**
 * saving the amendment comment through ajax call
 * @returns {boolean}
 */
function saveAmendmentComment() {
    $('#' + ChangeToStatus).val(AMENDED)
    var dataString = $('#mReviewForm').serialize();
    $.ajax({
        type: POST,
        data: dataString,
        url: SaveAmendmentCommentsURL,

        success: function (data) {
            if (data.STATUS == SUCCESS) {
                $("#" + SaveAndReviewBtnIdInReviewForm).show();
                $(".overlay").hide();
                toastr[Success](AmendmentSuccessMsg)
                setTimeout(function () {
                    location.reload()
                }, refreshTime);
            }
            else {
                toastr[ERROR](FormSaveErrorMsg)
            }
        },
        error: function () {
            ajaxCallSuccess = false
            toastr[ERROR](FormSaveErrorMsg)

        }
    })
}


/**
 * function to save the updated data to the DB through ajax call
 */
function ajaxFormDataSave() {
    clearUncheckedRespectiveFields();
    $('#' + ChangeToStatus).val(UPDATED)
    var dataString = $('#mReviewForm').serialize();
    $.ajax({
        type: POST,
        data: dataString,
        url: SaveMortalityFormURL,
        success: function (data) {
            if (data.STATUS == SUCCESS) {
                if (!$('#isHospiceYes').is((':checked'))) {
                    $("#" + SaveAndReviewBtnIdInReviewForm).show();
                }
                else
                    $("#" + SaveBtnIdInReviewFormOnSave).show();
                toastr[Success](FormUpdateSuccessMsg)
            }
            else {
                toastr[ERROR](FormSaveErrorMsg)
                $("#" + SaveBtnIdInReviewFormOnSave).hide();
            }
        },
        error: function () {
            toastr[ERROR](FormSaveErrorMsg)
        }
    })

}

$('#' + SaveAndReviewBtnIdInReviewForm).on('click', function () {

    ajaxFormDataSave();
})

/**
 * function to respective comment field
 * @param obj
 */
function showHideTextarea(obj) {
    $this = $(obj)
    var prefix = $this.attr('name')
    $('.' + prefix + _Div).toggle();
    if ($this.is(':checked')) {
        $('.' + prefix + _Div).find('textarea').addClass(MANDATORY);
    }
    else {
        $('.' + prefix + _Div).find('textarea').removeClass(MANDATORY);
        $('.' + prefix + _Div).find('textarea').removeClass(ERROR);
    }

}

/**
 * function to show the history of for particular form by getting it from DB through ajax call to grails action
 * @param reviewId is th e id to the particular form
 * @param obj is the element that is clicked
 */
function showHistory(reviewId, obj) {
    $this = $(obj)
    $.ajax({
        type: POST,
        data: {reviewId: reviewId},
        url: ShowHistoryURL,
        success: function (data) {
            if (data == '') {
                $("#dialog").html(NoHistory);
            } else {
                $("#dialog").html(data);
            }
            updateDialog($this.attr('id'))
        },
        error: function () {
            toastr[ERROR](ErrorMsg_ContactAdmin)
        }
    });
}

/**
 * updating the dailog box with the history fetched from the ajax call
 * @param id
 */
function updateDialog(id) {
    $("#dialog").dialog({
        position: {
            my: 'right-50 top-100',
            at: 'center bottom',
            of: '#' + id
        },
        draggable: false,
        resizable: false,
        height: 300,
        width: 360,
        modal: true,
    });
}

/**
 * function to check for mandatory fields answering and add error class if not answered and give error message to the user
 * @param data
 * @returns {boolean}
 */
function reviewAndSubmit(data) {
    var hasError = false
    var isSubmitVisible = $('#' + SaveBtnIdInReviewFormOnSave).is(':visible')
    var clickedElement = $(data)


    validateReviewForm(); //Validating the form and adding error class
    $('.' + MANDATORY).on('change', function () {
        var currentElement = $(this);
        var noString = /^\s*$/;
        if (currentElement.is('textarea') && currentElement.val().length > 0) {
            currentElement.removeClass(ERROR)
            //      currentElement.removeClass(MANDATORY)
            $('.' + currentElement.attr('name')).remove();
        }
        else if (currentElement.is('textarea') && noString.test(currentElement.val()) && currentElement.is(':visible')) {
            if (!$('#' + currentElement.attr('name') + _Error).is(':visible')) {
                currentElement.addClass(ERROR)
                currentElement.after("<br/><span   class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ");

            }
        }
    });
    var allInputs = $(":input")
    allInputs.each(function () {
        var currentInput = $(this)
        if (currentInput.hasClass(MANDATORY) && currentInput.hasClass(ERROR) && currentInput.is(':visible')) {
            hasError = true

        }
    });

    $('.' + ERROR).on('change', function () {
        var allInputs = $(":input")
        allInputs.each(function () {

            var currentInput = $(this)
            if (currentInput.hasClass(MANDATORY) && currentInput.hasClass(ERROR))
                hasError = true
        });
    });
    $('.' + ERROR).focusout(function () {
        var currentInput = $(this)
        if (currentInput.hasClass(MANDATORY) && currentInput.hasClass(ERROR) && currentInput.is(':visible')) {
            hasError = true

        }
    });
    $('.errorDiv').each(function () {
        hasError = true
        return false;
    });
    $('.' + ERROR).each(function () {
        hasError = true
        return false;
    });
    if (hasError) { // checking for errors and scroll to the first error field
        $('.' + ERROR).each(function () {
            var thisEle = $(this)
            $('html, body').animate({
                scrollTop: ($(thisEle).offset().top - 120)
            }, 1000);
            return false;
        });

        $('#' + SaveBtnIdInReviewFormOnSave).hide()
        $('#' + ChangeToStatus).val('');
        toastr[ERROR](MandatoryErrorMsg)
        return false;
    }
    else {
        $("#" + SaveBtnIdInReviewFormOnSave).show(); //if no errors submit button is shown.
        hasError = false
        if (clickedElement.attr('name') == SaveBtnName) {
            clearUncheckedRespectiveFields();
            ajaxFormDataSave();
            return false
        }
        else if (clickedElement.attr('id') == SaveBtnIdInReviewFormOnSave) {
            clearUncheckedRespectiveFields();
            $('#reviewId').remove()
            $('#' + ChangeToStatus).val(SUBMITTED)
            return true;
        }
    }
}

function assignValToStatusChangeTo() {
    $('#' + ChangeToStatus).val(UPDATED);
    $('#reqFormEditableStatus').val('true');
    $("#mReviewForm").attr("action", ReviewFormOnSave)
    return true;
}

/**
 * function to validate mandatory fields answering and add error class if not answered and give error message to the user
 * and on change of these fields re-validated
 * @param data
 * @returns {boolean}
 */

function validateReviewForm() {//start of validation
    $('.' + MANDATORY).each(function () {
        var currentElement = $(this);
        var noString = /^\s*$/;
        if (currentElement.is('textarea') && currentElement.val().length > 0 && !noString.test(currentElement.val())) {
            currentElement.removeClass(ERROR)
            //     currentElement.removeClass(MANDATORY)
            $('.' + currentElement.attr('name')).remove();
        }
        else if (currentElement.is('textarea') && noString.test(currentElement.val()) && currentElement.is(':visible')) {
            if (!$('#' + currentElement.attr('name') + _Error).is(':visible')) {
                currentElement.addClass(ERROR)
                currentElement.after("<br/><span   class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ");
            }
        }
    });

    //on focus of error fields error class is removed
    $('.' + ERROR).on('focus', function () {
        var currentElement = $(this);
        currentElement.removeClass(ERROR)
        $('.' + currentElement.attr('name')).hide();
        $('#' + currentElement.attr('name') + _Error).hide();

    });

    //on change of the error fields re-validation is done
    $('.' + ERROR).focusout(function () {
        var currentElement = $(this);
        var noString = /^\s*$/;
        if (currentElement.is('textarea') && currentElement.val().length > 0 && !noString.test(currentElement.val())) {
            currentElement.removeClass(ERROR)
            //       currentElement.removeClass(MANDATORY)
            $('.' + currentElement.attr('name')).remove();
        }
        else if (currentElement.is('textarea') && noString.test(currentElement.val())) {
            if (!$('#' + currentElement.attr('name') + _Error).is(':visible')) {
                currentElement.addClass(ERROR)
                currentElement.after("<br/><span   class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ");

            }

        }
    });

    //Radio buttons being validated
    var previousEle = $("isPatInfoAccurateYesDiv")
    $("input[type='radio']").click(function () {
        var previousEle = $("isPatInfoAccurateYesDiv")
        $("input[type='radio']").each(function () {
            var currentElement = $(this);
            if (previousEle == currentElement) {
            }
            else {
                if (currentElement.attr('name') == previousEle.attr('name') && currentElement.hasClass(MANDATORY) && previousEle.hasClass(MANDATORY)) {
                    if (currentElement.is(':checked') || previousEle.is(':checked')) {
                        currentElement.removeClass(ERROR)
                        //              previousEle.removeClass(MANDATORY)
                        previousEle.removeClass(ERROR)
                        previousEle.closest('tr').removeClass(ERRORDIV)
                        $('.' + currentElement.attr('name')).remove();
                    }
                }
            }
            previousEle = currentElement;
        });
    });

    $("input[type='radio']").each(function () {
        var currentElement = $(this);
        if (previousEle != currentElement) {
            if (currentElement.attr('name') == previousEle.attr('name') && currentElement.hasClass(MANDATORY) && previousEle.hasClass(MANDATORY)) {
                if (currentElement.is(':checked') || previousEle.is(':checked')) {
                    currentElement.removeClass(ERROR)
                    //         previousEle.removeClass(MANDATORY)
                    previousEle.removeClass(ERROR)
                    previousEle.closest('tr').removeClass(ERRORDIV)
                    $('.' + currentElement.attr('name')).hide();
                }
                else {
                    if (currentElement.is(':visible')) {
                        currentElement.addClass(ERROR)
                        previousEle.closest('tr').addClass(ERRORDIV)
                        if (!$('.' + currentElement.attr('name')).is(':visible')) {
                            currentElement.parent().after("<span class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ")
                        }
                    }
                }
            }
        }
        previousEle = currentElement;
    });

    //validation for tabs that checks for at least one check box to be checked
    $.each(CheckboxNames, function (index, currentValue) {
        var checkedAtleastOne = false;
        checkedAtleastOne = $('#isHospiceYes').is((':checked'));
        $('.' + currentValue).each(function () {
            var currentElement = $(this);
            if (currentElement.is(':checked')) {
                checkedAtleastOne = true;
                return false;
            }
        });
        if (checkedAtleastOne) {
            $('#' + currentValue).hide();
            $('#' + currentValue + _Div).removeClass(ERRORDIV);
        }
        else {
            $('#' + currentValue).show();
            $('#' + currentValue + _Div).addClass(ERRORDIV);
        }
    });

    //on change of the check boxes,validation for tabs is done and particular tab is highlighted
    $("input[type='checkbox']").on('change', function () {
        var checkedAtleastOne = false;
        var clickedElement = $(this);
        $('.' + clickedElement.attr('class').split(' ')[0]).each(function () {
            var currentElement = $(this);
            if (currentElement.is(':checked')) {
                checkedAtleastOne = true;
            }
        });
        if (checkedAtleastOne) {
            $('#' + clickedElement.attr('class').split(' ')[0]).hide();
            $('#' + clickedElement.attr('class').split(' ')[0] + _Div).removeClass(ERRORDIV);
        }
        else {
            $('#' + clickedElement.attr('class').split(' ')[0] + _Div).addClass(ERRORDIV);
            $('#' + clickedElement.attr('class').split(' ')[0]).show();
        }
    });
}

function addErrorClassToRadio() {
    if ($('#expectedPatToDieAdmissionYes').is(':checked')) {
        $('#expectedPatToDieAdmissionYesDiv').show();
        $('.expectedPatToDieAdmissionYesOption').addClass(MANDATORY);
        $('.expectedPatToDieAdmissionYesOption').addClass(ERROR);
        if (!$('#expectedPatToDieAdmissionYesErrorSpan').is(':visible') && !$('#isRelUnderlyingConditionsId').is(':checked') && !$('#isNaturalCoursePatIllnessId').is(':checked')) {
            $('#isRelUnderlyingConditionsId').parent().after("<span class='errorMsg\t checkbox-inline isNaturalCoursePatIllness' " + "id='expectedPatToDieAdmissionYesErrorSpan'>\t\t" + AskToAnswer + "</span> ")
            $('#isRelUnderlyingConditionsId').parent().parent().parent().addClass(ERRORDIV)
        }
        $('#expectedPatToDieAdmissionNoDiv').hide();
        $('#expPatDieAdmissionComment').removeClass(ERROR);
    }
    else {
        $('#expectedPatToDieAdmissionYesDiv').hide();
    }
    $('.expectedPatToDieAdmissionYesOption').click(function () {

        if (!$('#isRelUnderlyingConditionsId').is(':checked') && !$('#isNaturalCoursePatIllnessId').is(':checked')) {
            $('#expectedPatToDieAdmissionYesErrorSpan').show();
            return false;
        }
        else {
            $('#expectedPatToDieAdmissionYesErrorSpan').hide();
        }
    })
}


function validateHospiceQuestion() {

    var previousEle = $("isPatInfoAccurateYesDiv")
    $("input[type='radio']:visible").each(function () {
        var currentElement = $(this);
        if (previousEle != currentElement) {
            if (currentElement.attr('name') == previousEle.attr('name') && currentElement.hasClass(MANDATORY) && previousEle.hasClass(MANDATORY)) {
                if (currentElement.is(':checked') || previousEle.is(':checked')) {
                    currentElement.removeClass(ERROR)
                    //previousEle.removeClass(MANDATORY)
                    previousEle.removeClass(ERROR)
                    previousEle.closest('tr').removeClass(ERRORDIV)
                    $('.' + currentElement.attr('name')).hide();
                }
                else {
                    if (currentElement.is(':visible')) {
                        currentElement.addClass(ERROR)
                        previousEle.closest('tr').addClass(ERRORDIV)
                        if (!$('.' + currentElement.attr('name')).is(':visible')) {
                            currentElement.parent().after("<span class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ")
                        }
                    }
                }
            }
        }
        previousEle = currentElement;
    });

    $('.' + MANDATORY + ':visible').each(function () {
        var currentElement = $(this);
        var noString = /^\s*$/;
        if (currentElement.is('textarea') && currentElement.val().length > 0 && !noString.test(currentElement.val())) {
            currentElement.removeClass(ERROR)
            //     currentElement.removeClass(MANDATORY)
            $('.' + currentElement.attr('name')).remove();
        }
        else if (currentElement.is('textarea') && noString.test(currentElement.val()) && currentElement.is(':visible')) {
            if (!$('#' + currentElement.attr('name') + _Error).is(':visible')) {
                currentElement.addClass(ERROR)
                currentElement.after("<br/><span   class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ");
            }
        }
    });

    $('.' + MANDATORY + ":visible").on('change', function () {
        var currentElement = $(this);
        var noString = /^\s*$/;
        if (currentElement.is('textarea') && currentElement.val().length > 0) {
            currentElement.removeClass(ERROR)
            //      currentElement.removeClass(MANDATORY)
            $('.' + currentElement.attr('name')).remove();
        }
        else if (currentElement.is('textarea') && noString.test(currentElement.val()) && currentElement.is(':visible')) {
            if (!$('#' + currentElement.attr('name') + _Error).is(':visible')) {
                currentElement.addClass(ERROR)
                currentElement.after("<br/><span   class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ");

            }
        }
    });
    $('.' + ERROR + ":visible").on('focus', function () {
        var currentElement = $(this);
        currentElement.removeClass(ERROR)
        $('.' + currentElement.attr('name')).hide();
        $('#' + currentElement.attr('name') + _Error).hide();

    });
    $('.' + ERROR).focusout(function () {
        var currentElement = $(this);
        var noString = /^\s*$/;
        if (currentElement.is('textarea') && currentElement.val().length > 0 && !noString.test(currentElement.val())) {
            currentElement.removeClass(ERROR)
            //       currentElement.removeClass(MANDATORY)
            $('.' + currentElement.attr('name')).remove();
        }
        else if (currentElement.is('textarea') && noString.test(currentElement.val())) {
            if (!$('#' + currentElement.attr('name') + _Error).is(':visible')) {
                currentElement.addClass(ERROR)
                currentElement.after("<br/><span   class='errorMsg\t" + currentElement.attr('name') + "\t checkbox-inline' id='" + currentElement.attr('name') + _Error + "'>" + AskToAnswer + "</span> ");

            }

        }
    });


    $("input[type='radio']:visible").click(function () {
        var previousEle = $("isPatInfoAccurateYesDiv")
        $("input[type='radio']").each(function () {
            var currentElement = $(this);
            if (previousEle == currentElement) {
            }
            else {
                if (currentElement.attr('name') == previousEle.attr('name') && currentElement.hasClass(MANDATORY) && previousEle.hasClass(MANDATORY)) {
                    if (currentElement.is(':checked') || previousEle.is(':checked')) {
                        currentElement.removeClass(ERROR)
                        //              previousEle.removeClass(MANDATORY)
                        previousEle.removeClass(ERROR)
                        previousEle.closest('tr').removeClass(ERRORDIV)
                        $('.' + currentElement.attr('name')).remove();
                    }
                }
            }
            previousEle = currentElement;
        });
    });
    var isError = false;
    if ($(".errorMsg:visible").length > 0) {
        isError = true;
        clearHospiceQues()
    }
    else{
        $('#' + SaveBtnIdInReviewForm).show();
        $('#' + SaveAndReviewBtnIdInReviewForm).show();
    }
    return isError;
}

function clearHospiceQues(){
    if ($('#status').val() != UPDATED) {
        $('#' + SaveAndReviewBtnIdInReviewForm).hide();
    }
    else {
        $('#' + SaveAndReviewBtnIdInReviewForm).show();
    }
    if ($('#status').val() != SUBMITTED && $('#status').val() != AMENDED) {
        $("#isHospiceYes").attr("checked", false)
    }
    $('#' + SaveBtnIdInReviewFormOnSave).hide();

}