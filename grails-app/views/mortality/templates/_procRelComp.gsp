<div id="procedureRelated_div">
    <div class="title">
        <p><span >Procedure‐Related Complication(s) (check all that apply)
            <span id="procedureRelated" style="display: none"  class="checkbox-inline errorMsg">Please select at least one checkbox in the section</span>

        </span>
        </p>
    </div>

    <div class="form-inline row">
        <div class="col-md-5 divContent">

            <div>
                <label class="checkbox-inline checkboxTop">
                    <g:checkBox class="procedureRelated checkComment" name="isProcedureCardiac" value="${mReviewForm?.isProcedureCardiac}"
                                id="isProcedureCardiac"    onclick="showHideTextarea(this)"/>Cardiac arrest
                </label>

                <div id="cardiacCommentDivId" ${!mReviewForm?.isProcedureCardiac ? "style=display:none" : ''}
                     class="isProcedureCardiac_div checkbox-inline">
                    <span class="required">*&nbsp;</span>
                    <g:textArea name="cardiacComment" class="ax_default text_area ${mReviewForm?.isProcedureCardiac ? "mandatory" : ''} isProcedureCardiacComment"  maxlength="250"
                                placeholder="Please specify" >${mReviewForm?.cardiacComment}</g:textArea>
                </div>

            </div>

            <div>
                <label class="checkbox-inline ">
                    <g:checkBox class="procedureRelated" name="isDeadWithin72HoursOfProc"
                                value="${mReviewForm?.isDeadWithin72HoursOfProc}"/>Death within 72 hours of a procedure
                </label>
            </div>



            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="procedureRelated" name="isExcessiveBleeding"
                                value="${mReviewForm?.isExcessiveBleeding}"/>Excessive or unexpected Bleeding
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="procedureRelated" name="isProcedureHepatic" value="${mReviewForm?.isProcedureHepatic}"/>Hepatic Injury
                </label>
            </div>
            <div>
                <label class="checkbox-inline ">
                    <g:checkBox class="procedureRelated"  name="isHypotension" value="${mReviewForm?.isHypotension}"/>Hypotension

                </label>
            </div>

            <div>
                <label class="checkbox-inline checkboxTop">
                    <g:checkBox class="procedureRelated checkComment" name="isInfection" value="${mReviewForm?.isInfection}" id="isInfection"
                                onclick="showHideTextarea(this)"/>Infection
                </label>

                <div id="infectionCommentDivId" ${!mReviewForm?.isInfection ? "style=display:none" : ''}
                     class="isInfection_div checkbox-inline">
                    <span class="required">*&nbsp;</span>
                    <textarea maxlength="250" name="infectionComment" class="ax_default text_area ${mReviewForm?.isInfection ? "mandatory" : ''} isInfectionComment" maxlength="250"
                              placeholder="Please specify" >${mReviewForm?.infectionComment}</textarea>
                </div>
            </div>

        </div>

        <div class="col-md-7 divContent">
            <div>
                <label class="checkbox-inline checkboxTop">
                    <g:checkBox class="procedureRelated checkComment"  name="isNeurologicalInjury" value="${mReviewForm?.isNeurologicalInjury}"
                                onclick="showHideTextarea(this)"/>Neurological Injury
                </label>

                <div id="neuroInjuryCommentDivId" ${!mReviewForm?.isNeurologicalInjury ? "style=display:none" : ''}
                     class="isNeurologicalInjury_div checkbox-inline ">
                    <span class="required">*&nbsp;</span>
                    <textarea maxlength="250" name="neuroInjuryComment" class="ax_default text_area ${mReviewForm?.isNeurologicalInjury ? "mandatory" : ''} isNeurologicalInjuryComment" maxlength="250"
                              placeholder="Please specify" >${mReviewForm?.neuroInjuryComment}</textarea>
                </div>
            </div>

            <div>
                <label class="checkbox-inline ">
                    <g:checkBox class="procedureRelated"  name="isPneumothoraxRate" value="${mReviewForm?.isPneumothoraxRate}"/>PSI 06- Iatrogenic Pneumothorax


                </label>
            </div>

            <div>
                <label class="checkbox-inline ">
                    <g:checkBox class="procedureRelated"  name="isHemhgeOrHematRate" value="${mReviewForm?.isHemhgeOrHematRate}"/>PSI 09- Postoperative Hemorrhage or Hematoma


                </label>
            </div>
            <div>
                <label class="checkbox-inline ">
                    <g:checkBox class="procedureRelated"  name="isPeOrDeVenThrbRate" value="${mReviewForm?.isPeOrDeVenThrbRate}"/>PSI 12- Postoperative PE or Deep Vein Thrombosis


                </label>
            </div>

            <div>
                <label class="checkbox-inline checkboxTop">
                    <g:checkBox class="procedureRelated checkComment" name="isProcedurePulmonary" value="${mReviewForm?.isProcedurePulmonary}"
                                id="isProcedurePulmonary"   onclick="showHideTextarea(this)"/>Pulmonary
                </label>



            </div>


            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="procedureRelated"  name="isRenalFailure" value="${mReviewForm?.isRenalFailure}"/>Renal Failure

                </label>
            </div>
            <div>
                <label class="checkbox-inline ">
                    <g:checkBox class="procedureRelated"  name="isStroke" value="${mReviewForm?.isStroke}"/>Stroke

                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="procedureRelated"  name="isUnanticipatedTransfusion"
                                value="${mReviewForm?.isUnanticipatedTransfusion}"/>Unanticipated Transfusion
                </label>
            </div>
            <div>
                <label class="checkbox-inline checkboxTop">
                    <g:checkBox class="procedureRelated checkComment" name="isProcedureOther" value="${mReviewForm?.isProcedureOther}"
                                id="isProcedureOther"   onclick="showHideTextarea(this)"/>Other
                </label>

                <div id="procedureOtherCommentDivId" ${!mReviewForm?.isProcedureOther ? "style=display:none" : ''}
                     class="isProcedureOther_div checkbox-inline">
                    <span class="required">*&nbsp;</span>
                    <textarea maxlength="250" name="procedureOtherComment" class="ax_default text_area ${mReviewForm?.isProcedureOther ? "mandatory" : ''} isProcedureOtherComment" maxlength="250"
                              placeholder="Please specify" >${mReviewForm?.procedureOtherComment}</textarea>
                </div>
            </div>
            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="procedureRelated naCheckbox procRelComp" name="isProcRelCompNA"
                                value="${mReviewForm?.isProcRelCompNA}"/> N/A
                </label>
            </div>


        </div>
    </div>

    <div class="form-inline row ">
        <label class="checkbox-inline checkboxTop">Post Op Summary
        </label>
        <textarea maxlength="250" name="postOpSummary" class="ax_default text_area" maxlength="250">${mReviewForm?.postOpSummary}</textarea>
    </div>
</div>

