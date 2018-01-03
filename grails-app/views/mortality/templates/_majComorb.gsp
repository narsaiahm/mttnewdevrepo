<div id="majorComorbiditiesOnAdmission_div">
    <div class="title">
    <p><span>Major Comorbidities Present on Admission (check all that apply)
    </span>
        <span id="majorComorbiditiesOnAdmission" style="display: none"  class="checkbox-inline errorMsg">Please select at least one checkbox in the section</span>
    </p>
</div>

<div class="form-inline row">
    <div class="col-md-5 divContent">
        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isComorbAtrialFibrillation"
                            value="${mReviewForm?.isComorbAtrialFibrillation}"/>Atrial Fibrillation
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isCerebrovascularAccident"
                            value="${mReviewForm?.isCerebrovascularAccident}"/>Cerebrovascular Accident
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isChronicKidneyDisease"
                            value="${mReviewForm?.isChronicKidneyDisease}"/>Chronic/End Stage Kidney Disease
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isCirrhosis" value="${mReviewForm?.isCirrhosis}"/>Cirrhosis
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isCognitiveImpairment"
                            value="${mReviewForm?.isCognitiveImpairment}"/>Cognitive Impairment
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isAsthma" value="${mReviewForm?.isAsthma}"/>COPD/Asthma
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isCoronaryArteryDisease"
                            value="${mReviewForm?.isCoronaryArteryDisease}"/>Coronary Artery Disease
            </label>
        </div>

        <div class="">
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isDiabetes" value="${mReviewForm?.isDiabetes}"/>Diabetes
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isDementia" value="${mReviewForm?.isDementia}"/>Dementia
            </label>
        </div>
    </div>

    <div class="col-md-7 divContent">
        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isComorbHeartFailure" value="${mReviewForm?.isComorbHeartFailure}"/>Heart Failure
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isHyperTension" value="${mReviewForm?.isHyperTension}"/>Hypertension
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isMalignancy" value="${mReviewForm?.isMalignancy}"/>Malignancy
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isMorbidObesity" value="${mReviewForm?.isMorbidObesity}"/>Morbid Obesity

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isNeurologicalDisorders"
                            value="${mReviewForm?.isNeurologicalDisorders}"/>Neurological Disorders

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isObstructiveSleepApnea"
                            value="${mReviewForm?.isObstructiveSleepApnea}"/>Obstructive Sleep Apnea

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isPeripheralVascularDisease"
                            value="${mReviewForm?.isPeripheralVascularDisease}"/>Peripheral Vascular Disease

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission" name="isValvularHeartDisease"
                            value="${mReviewForm?.isValvularHeartDisease}"/>Valvular Heart Disease

            </label>
        </div>

        <div>
            <label class="checkbox-inline checkboxTop ">
                <g:checkBox class="majorComorbiditiesOnAdmission " name="isComorbiditiesOther" id="isComorbiditiesOther" value="${mReviewForm?.isComorbiditiesOther}"
                            onclick="showHideTextarea(this)"/>Other

            </label>

            <div id="comorbiditiesOtherCommentDivId" ${!mReviewForm?.isComorbiditiesOther ? "style=display:none" : ''}
                 class="isComorbiditiesOther_div checkbox-inline">
                <span class="required">*&nbsp;</span>
                <textarea maxlength="250" class="ax_default text_area ${mReviewForm?.isComorbiditiesOther ? "mandatory" : ''} isComorbiditiesOtherComment"  id="comorbiditiesOtherComment" maxlength="250" placeholder="Please specify"
                          name="comorbiditiesOtherComment">${mReviewForm?.comorbiditiesOtherComment}</textarea>
            </div>

        </div>



        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorComorbiditiesOnAdmission naCheckbox majComorb" name="isMajComorbNa"
                            value="${mReviewForm?.isMajComorbNa}"/>N/A
            </label>
        </div>
    </div>

</div>
</div>