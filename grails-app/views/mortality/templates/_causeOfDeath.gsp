<div id="cause_Of_Death_div">
    <div class="title">
        <p>
            <span>Cause of Death</span>
            <span id="cause_Of_Death" style="display: none"
                  class="checkbox-inline errorMsg">Please select at least one checkbox in the section</span>
        </p>
    </div>

    <div class="form-inline row">
        <div class="col-md-5 divContent">

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="cause_Of_Death " name="isBleeding" value="${mReviewForm?.isBleeding}"/>Bleeding
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="cause_Of_Death " name="isDeathCauseCardiac"
                                value="${mReviewForm?.isDeathCauseCardiac}"/>Cardiac</label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="cause_Of_Death " name="isDeathCauseHepatic"
                                value="${mReviewForm?.isDeathCauseHepatic}"/>Hepatic</label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="cause_Of_Death " name="isDeathCausePulmonary"
                                value="${mReviewForm?.isDeathCausePulmonary}"/>Pulmonary</label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="cause_Of_Death " name="isDeathCauseRenal"
                                value="${mReviewForm?.isDeathCauseRenal}"/>Renal</label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="cause_Of_Death " name="isDeathCauseSepsis"
                                value="${mReviewForm?.isDeathCauseSepsis}"/>Sepsis</label>

            </div>

            <div>
                <label class="checkbox-inline checkboxTop ">
                    <g:checkBox class="cause_Of_Death checkComment" name="isDeathCauseOther"
                                value="${mReviewForm?.isDeathCauseOther}" onclick="showHideTextarea(this)"
                                id="isDeathCauseOther"/>Other
                </label>

                <div id="deathCauseOtherCommentDivId" ${!mReviewForm?.isDeathCauseOther ? "style=display:none" : ''}
                     class="isDeathCauseOther_div checkbox-inline">
                    <span class="required">*&nbsp;</span>
                    <textarea maxlength="250" name="deathCauseOtherComment"
                              class="ax_default text_area  ${mReviewForm?.isDeathCauseOther ? "mandatory" : ''} isDeathCauseOtherComment"
                              maxlength="250"
                              placeholder="Please specify">${mReviewForm?.deathCauseOtherComment}</textarea>
                </div>
            </div>
        </div>
        <div class="col-md-7 divContent">
        </div>
        <div class="form-inline row">
            <div class="col-md-12">
                <table class="leftAlign tableAlign">
                    <tr>
                        <td class="col-md-5">
                            <label><span class="required">*&nbsp;</span> Was Patient admitted to ICU at time of admission?
                            </label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input type="radio" class="mandatory" name="wasPatICUTimeAdmission"
                                       value="true" ${mReviewForm?.wasPatICUTimeAdmission == true ? 'checked="checked"' : ''}>Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio" class="mandatory" name="wasPatICUTimeAdmission"
                                       value="false" ${mReviewForm?.wasPatICUTimeAdmission == false ? 'checked="checked"' : ''}>No
                            </label>
                        </td>
                    </tr>

                    <tr>
                        <td class="col-md-5">
                            <label>
                                <span class="required checkboxTop">*&nbsp;</span>
                                Would you have expected the patient to die during this admission?
                            </label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input type="radio" class="mandatory"
                                       name="expectedPatToDieAdmission"
                                       value="true" ${mReviewForm?.expectedPatToDieAdmission == true ? 'checked="checked"' : ''} onclick="showAppropriateAndAddMandatoryClass('expectedPatToDieAdmissionYesTr');hideAppropriateAndRemoveMandatoryClass('expectedPatToDieAdmissionNoTr')">Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio" class="mandatory"
                                       name="expectedPatToDieAdmission"
                                       value="false" ${mReviewForm?.expectedPatToDieAdmission == false ? 'checked="checked"' : ''} onclick="hideAppropriateAndRemoveMandatoryClass('expectedPatToDieAdmissionYesTr');showAppropriateAndAddMandatoryClass('expectedPatToDieAdmissionNoTr')">No
                            </label>
                        </td>

                    </tr>
                    <tr id="expectedPatToDieAdmissionYesTr" ${(mReviewForm?.expectedPatToDieAdmission) ? '' : "style=display:none"}>

                        <td class="col-md-5">
                            <label>
                                <span class="required checkboxTop">*&nbsp;</span>
                                Was it due to:
                            </label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input type="radio"
                                       class="expectedPatToDieAdmissionYesTrOption ${mReviewForm?.expectedPatToDieAdmission ? 'mandatory' : ''}"
                                       name="isNaturalCoursePatIllness"
                                       value="true" ${mReviewForm?.isNaturalCoursePatIllness == true ? 'checked="checked"' : ''} " >Natural Course of Patient Illness
                            </label><br/>
                            <label class="radio-inline">
                                <input type="radio"
                                       class="expectedPatToDieAdmissionYesTrOption ${mReviewForm?.expectedPatToDieAdmission ? 'mandatory' : ''}"
                                       name="isNaturalCoursePatIllness"
                                       value="false" ${mReviewForm?.isNaturalCoursePatIllness == false ? 'checked="checked"' : ''} " >Related to Underlying Conditions
                            </label>
                        </td>

                    </tr>
                    <tr id="expectedPatToDieAdmissionNoTr" ${mReviewForm?.expectedPatToDieAdmission != false ? "style=display:none" : ''}>
                        <td class="col-md-5"></td>
                        <td class="col-md-7">
                            <span class="required">*&nbsp;</span>
                            <textarea maxlength="250"
                                      class="ax_default text_area ${mReviewForm?.expectedPatToDieAdmission == false ? "mandatory" : ''} expectedPatToDieAdmissionNoTrOption"
                                      maxlength="250" placeholder="Please elaborate" id="expPatDieAdmissionComment"
                                      name="expPatDieAdmissionComment">${mReviewForm?.expPatDieAdmissionComment}</textarea>
                        </td>

                    </tr>
                    <tr>
                        <td class="col-md-5">
                            <span class="required">*&nbsp;</span>
                            <label>Was Palliative Care Service Consulted?</label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input  type="radio" name="isPalliativeCare" class="mandatory"
                                       value="true" ${mReviewForm?.isPalliativeCare == true ? 'checked="checked"' : ''} onclick="hideAppropriateAndRemoveMandatoryClass('isPalliativeCareNoTr')">Yes
                            </label>
                            <label class="radio-inline">
                                <input  type="radio" name="isPalliativeCare" class="mandatory"
                                       value="false" ${mReviewForm?.isPalliativeCare == false ? 'checked="checked"' : ''} onclick="showAppropriateAndAddMandatoryClass('isPalliativeCareNoTr')">No
                            </label>

                        </td>
                    </tr>
                    <tr id="isPalliativeCareNoTr"  ${mReviewForm?.isPalliativeCare == false? "" : 'style=display:none'}>
                        <td class="col-md-5">
                            <span class="required">*&nbsp;</span>
                            <label>Should they've been contacted?</label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input type="radio" name="havePalliativeCareContacted" class="${mReviewForm?.isPalliativeCare? "mandatory" : ''} isPalliativeCareNoTrOption"
                                       value="true" ${mReviewForm?.havePalliativeCareContacted == true ? 'checked="checked"' : ''}>Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="havePalliativeCareContacted" class="${mReviewForm?.isPalliativeCare? "mandatory" : ''} isPalliativeCareNoTrOption"
                                       value="false" ${mReviewForm?.havePalliativeCareContacted == false ? 'checked="checked"' : ''}>No
                            </label>

                        </td>
                    </tr>
                    <tr>
                        <td class="col-md-5">
                            <label>
                                <span class="required checkboxTop">*&nbsp;</span>
                                Did the patient have an active DNR status at the time of admission?
                            </label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input  type="radio" class="mandatory"
                                       name="wasDnrPriorToAdmission"
                                       value="true" ${mReviewForm?.wasDnrPriorToAdmission == true ? 'checked="checked"' : ''} onclick="showAppropriateAndAddMandatoryClass('wasDnrPriorToAdmissionYesTr');hideAppropriateAndRemoveMandatoryClass('wasDnrPriorToAdmissionNoTr')">Yes
                            </label>
                            <label class="radio-inline">
                                <input  type="radio" class="mandatory"
                                       name="wasDnrPriorToAdmission"
                                       value="false" ${mReviewForm?.wasDnrPriorToAdmission == false ? 'checked="checked"' : ''} onclick="hideAppropriateAndRemoveMandatoryClass('wasDnrPriorToAdmissionYesTr');showAppropriateAndAddMandatoryClass('wasDnrPriorToAdmissionNoTr')">No
                            </label>
                        </td>

                    </tr>
                    <tr id="wasDnrPriorToAdmissionYesTr"  ${mReviewForm?.wasDnrPriorToAdmission == true? "" : 'style=display:none'}>
                        <td class="col-md-5">
                            <label>
                                <span class="required checkboxTop">*&nbsp;</span>
                                Was DNR appropriately applied?
                            </label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input type="radio"
                                       name="wasDnrAppliedAtAdmission" class="wasDnrPriorToAdmissionYesTrOption ${mReviewForm?.wasDnrPriorToAdmission? "mandatory" : ''} "
                                       value="true" ${mReviewForm?.wasDnrAppliedAtAdmission == true ? 'checked="checked"' : ''} >Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio"
                                       name="wasDnrAppliedAtAdmission" class="wasDnrPriorToAdmissionYesTrOption ${mReviewForm?.wasDnrPriorToAdmission? "mandatory" : ''} "
                                       value="false" ${mReviewForm?.wasDnrAppliedAtAdmission == false ? 'checked="checked"' : ''}>No
                            </label>
                        </td>
                    </tr>
                    <tr id="wasDnrPriorToAdmissionNoTr"  ${mReviewForm?.wasDnrPriorToAdmission == false? "" : 'style=display:none'}>
                        <td class="col-md-5">
                            <label>
                                <span class="required checkboxTop">*&nbsp;</span>
                                Did the patient become DNR after admission?
                            </label>
                        </td>
                        <td class="col-md-7">
                            <label class="radio-inline">
                                <input type="radio"
                                       name="didDnrAfterToAdmission" class="wasDnrPriorToAdmissionNoTrOption ${mReviewForm?.wasDnrPriorToAdmission == false? "mandatory" : ''} "
                                       value="true" ${mReviewForm?.didDnrAfterToAdmission == true ? 'checked="checked"' : ''} >Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio"
                                       name="didDnrAfterToAdmission" class="wasDnrPriorToAdmissionNoTrOption ${mReviewForm?.wasDnrPriorToAdmission == false? "mandatory" : ''} "
                                       value="false" ${mReviewForm?.didDnrAfterToAdmission == false ? 'checked="checked"' : ''}>No
                            </label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

    </div>
</div>