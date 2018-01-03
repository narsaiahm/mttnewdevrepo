<div id="ContributingFactors_div">
    <div class="title">
        <p>
            <span>Contributing Factors (check all that apply)</span>
            <span id="ContributingFactors" style="display: none"
                  class="checkbox-inline errorMsg">Please select at least one checkbox in the section</span>

        </p>
    </div>

    <div class="form-inline row">
        <div class="col-md-5 divContent">
            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isAdverseDrugEvent"
                                value="${mReviewForm?.isAdverseDrugEvent}"/>Adverse Drug Event
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isDelayInTreatment"
                                value="${mReviewForm?.isDelayInTreatment}"/>Delay in Treatement/Intervantion
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isElectronicMedicalRecord"
                                value="${mReviewForm?.isElectronicMedicalRecord}"/>Electronic Medical Record
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isContributingFall"
                                value="${mReviewForm?.isContributingFall}"/>Fall
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isFailureToAftercare"
                                value="${mReviewForm?.isFailureToAftercare}"/>Failure to Aftercare
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isFailureToEscalate"
                                value="${mReviewForm?.isFailureToEscalate}"/>Failure to Escalate
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isHospAcqCondition"
                                value="${mReviewForm?.isHospAcqCondition}"/>Hospital Acquired Condition
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isContributingHospInfection"
                                value="${mReviewForm?.isContributingHospInfection}"/>Hospital Acquired Infection
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isOmissionOfCare"
                                value="${mReviewForm?.isOmissionOfCare}"/>Omission of Care
                </label>
            </div>
        </div>

        <div class="col-md-7 divContent">

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isPatientCompliance"
                                value="${mReviewForm?.isPatientCompliance}"/>Patient Compliance
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isPoorCommunication"
                                value="${mReviewForm?.isPoorCommunication}"/>Communication
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isPoorHandoff"
                                value="${mReviewForm?.isPoorHandoff}"/>Handoff Incomplete
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isPoorDocumentation"
                                value="${mReviewForm?.isPoorDocumentation}"/>Missing Documentation
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isSupervision"
                                value="${mReviewForm?.isSupervision}"/>Lack of Supervision
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isSurgicalError"
                                value="${mReviewForm?.isSurgicalError}"/>Surgical/Procedure Error
                </label>
            </div>

            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors" name="isTechniqueError"
                                value="${mReviewForm?.isTechniqueError}"/>Technique Error
                </label>
            </div>

            <div>
                <label class=" checkbox-inline  checkboxTop">
                    <g:checkBox class="ContributingFactors checkComment" name="isContFactOther"
                                value="${mReviewForm?.isContFactOther}" id="isContFactOther"
                                onclick="showHideTextarea(this)"/>Other
                </label>


                <div id="contFactOtherCommentDivId" ${!mReviewForm?.isContFactOther ? "style=display:none" : ''}
                     class="isContFactOther_div checkbox-inline">
                    <span class="required">*&nbsp;</span>
                    <textarea maxlength="250" name="contFactOtherComment"
                              class="ax_default text_area ${mReviewForm?.isContFactOther ? "mandatory" : ''} isContFactOtherComment"
                              maxlength="250"
                              placeholder="Please specify">${mReviewForm?.contFactOtherComment}</textarea>
                </div>
            </div>
            <div>
                <label class="checkbox-inline">
                    <g:checkBox class="ContributingFactors naCheckbox contrFactors" name="isContFactNA"
                                value="${mReviewForm?.isContFactNA}"/>N/A
                </label>
            </div>
        </div>

    </div>

</div>