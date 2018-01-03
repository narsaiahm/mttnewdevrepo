<div id="complicationAcquiredInHosp_div" >
<div class="title">
    <p><span>Complication(s) Acquired in the Hospital (check all that apply)
    </span>
        <span id="complicationAcquiredInHosp" style="display: none"  class="checkbox-inline errorMsg">Please select at least one checkbox in the section</span>
    </p>
</div>

<div class="form-inline row">
    <div class="col-md-5 divContent">
        <div>
            <label class="checkbox-inline">

                <g:checkBox class="complicationAcquiredInHosp" name="isAcuteKidneyInjury" value="${mReviewForm?.isAcuteKidneyInjury}"/>
                Acute Kidney Injury
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isAcuteMyocardialInfraction"
                            value="${mReviewForm?.isAcuteMyocardialInfraction}"/>Acute Myocardial Infraction

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isAlterredMentalStatus"
                            value="${mReviewForm?.isAlterredMentalStatus}"/>Altered Mental Status

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isHospAtrialFibrillation"
                            value="${mReviewForm?.isHospAtrialFibrillation}"/>Atrial Fibrillation

            </label>
        </div>




        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isCVA" value="${mReviewForm?.isCVA}"/>CVA
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isDVTOrVTE" value="${mReviewForm?.isDVTOrVTE}"/>DVT/VTE

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isHospitalFall" value="${mReviewForm?.isHospitalFall}"/>Fall
            </label>
        </div>



        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isGiBleed" value="${mReviewForm?.isGiBleed}"/>GI Bleed
            </label>
        </div>
    </div>

    <div class="col-md-6 divContent">

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isHospitalHeartFailure" value="${mReviewForm?.isHospitalHeartFailure}"/>Heart Failure

            </label>
        </div>

        <div>
            <label class="checkbox-inline checkboxTop">
                <g:checkBox class="complicationAcquiredInHosp" name="isHospHospAcqInfection" id="isHospHospAcqInfection"
                            value="${mReviewForm?.isHospHospAcqInfection}" onclick="showHideTextarea(this)"/>Hospital-acquired infection
            </label>
            <div id="isHospHospAcqInfectionDivId" ${!mReviewForm?.isHospHospAcqInfection ? "style=display:none" : ''}
                 class="isHospHospAcqInfection_div checkbox-inline">
                <span class="required">*&nbsp;</span>
                <textarea maxlength="250" class="ax_default text_area ${mReviewForm?.isHospHospAcqInfection ? "mandatory" : ''} isHospHospAcqInfectionComment"  maxlength="250"  placeholder="Please specify Type and Location"
                          id="hospAcqInfComment"  name="hospAcqInfComment" >${mReviewForm?.hospAcqInfComment}</textarea>
            </div>
        </div>

        <div>
            <label class="checkbox-inline checkboxTop">
                <g:checkBox class="complicationAcquiredInHosp checkComment" name="isMedicalError" id="isMedicalError" value="${mReviewForm?.isMedicalError}"
                            onclick="showHideTextarea(this)" />Medication Error
            </label>

            <div id="medicalErrorCommentDivId" ${!mReviewForm?.isMedicalError ? "style=display:none" : ''}
                 class="isMedicalError_div checkbox-inline">
                <span class="required">*&nbsp;</span>
                <textarea maxlength="250" class="ax_default text_area ${mReviewForm?.isMedicalError ? "mandatory" : ''} isMedicalErrorComment"  maxlength="250" placeholder="Please describe the medication error"
                        id="medicalErrorComment"  name="medicalErrorComment" >${mReviewForm?.medicalErrorComment}</textarea>
            </div>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isPressureUlcer" value="${mReviewForm?.isPressureUlcer}"/>Pressure Ulcer
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isHospitalSepsis" value="${mReviewForm?.isHospitalSepsis}"/>Sepsis

            </label>
        </div>



        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp" name="isSyncope" value="${mReviewForm?.isSyncope}"/>Syncope

            </label>
        </div>



        <div>
            <label class="checkbox-inline checkboxTop">
                <g:checkBox class="complicationAcquiredInHosp" name="isHospitalOther" value="${mReviewForm?.isHospitalOther}"
                         id="isHospitalOther"   onclick="showHideTextarea(this)"/>Other
            </label>

            <div id="hospitalOtherCommentDivId" ${!mReviewForm?.isHospitalOther?"style=display:none":''} class="isHospitalOther_div checkbox-inline">
                <span class="required">*&nbsp;</span>
                <textarea maxlength="250" id="hospitalOtherComment" class="ax_default text_area ${mReviewForm?.isHospitalOther ? "mandatory" : ''} isHospitalOtherComment"  maxlength="250" placeholder="Please specify"   name="hospitalOtherComment" >${mReviewForm?.hospitalOtherComment}</textarea>
            </div>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="complicationAcquiredInHosp naCheckbox compAcqHosp" name="isCompAcqHospNA"  value="${mReviewForm?.isCompAcqHospNA}"/>N/A

            </label>
        </div>

    </div>

</div>
</div>
