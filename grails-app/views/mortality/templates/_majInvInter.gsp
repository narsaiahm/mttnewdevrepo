<div id="majorInvasive_div">
<div class="title">
    <p><span>
        Major Invasive Interventions

    </span>
        <span id="majorInvasive" style="display: none"  class="checkbox-inline errorMsg">Please select at least one checkbox in the section</span>
    </p>
</div>

<div class="form-inline row">
    <div class="col-md-5 divContent">

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorInvasive" name="isBronchoscopy" value="${mReviewForm?.isBronchoscopy}"/>Bronchoscopy
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorInvasive" name="isCardiacCatheterization"
                            value="${mReviewForm?.isCardiacCatheterization}"/>Cardiac Catheterization
            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorInvasive" name="isInvasiveHemodialysis" value="${mReviewForm?.isInvasiveHemodialysis}"/>Hemodialysis
            </label>
        </div>
    </div>

    <div class="col-md-7 divContent">

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorInvasive" name="isInterventionalRadioProc"
                            value="${mReviewForm?.isInterventionalRadioProc}"/>Interventional Radiologocal Procedure
            </label>
        </div>

        <div>
            <label class="checkbox-inline checkboxTop ">
                <g:checkBox class="majorInvasive checkComment" name="isSergicalProcedure" value="${mReviewForm?.isSergicalProcedure}"
                        id="isSergicalProcedure"    onclick="showHideTextarea(this)"/>Surgical Procedure
            </label>

            <div id="sergicalProcedureCommentDivId" ${!mReviewForm?.isSergicalProcedure ? "style=display:none" : ''}
                 class="isSergicalProcedure_div checkbox-inline">
                <span class="required">*&nbsp;</span>
               <textarea maxlength="250" class="ax_default text_area ${mReviewForm?.isSergicalProcedure ? "mandatory" : ''} isSergicalProcedureComment"  maxlength="250" placeholder="Please specify"
                          name="sergicalProcedureComment" >${mReviewForm?.sergicalProcedureComment}</textarea>
            </div>

        </div>

        <div>
            <label class="checkbox-inline checkboxTop">
                <g:checkBox class="majorInvasive checkComment" name="isInvasiveOther" value="${mReviewForm?.isInvasiveOther}"
                            onclick="showHideTextarea(this)"/>Other (e.g., bedside paracentesis, lumbar puncture, etc)
            </label>

            <div id="invasiveOtherCommentDivId" ${!mReviewForm?.isInvasiveOther ? "style=display:none" : ''}
                 class="isInvasiveOther_div checkbox-inline">
                <span class="required">*&nbsp;</span>
               <textarea maxlength="250" class="ax_default text_area ${mReviewForm?.isInvasiveOther ? "mandatory" : ''} isInvasiveOtherComment" maxlength="250" placeholder="Please specify"
                          name="invasiveOtherComment" >${mReviewForm?.invasiveOtherComment}</textarea>
            </div>

        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorInvasive naCheckbox majInvInter" name="isMajInvInterNA"
                            value="${mReviewForm?.isMajInvInterNA}"/>N/A
            </label>
        </div>
    </div>

</div>
</div>