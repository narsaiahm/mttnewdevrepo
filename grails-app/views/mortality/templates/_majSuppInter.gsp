<div id="majorSupportive_div"><div class="title">
    <p><span>Major Supportive Interventions (check all that apply)
    </span>
        <span id="majorSupportive" style="display: none"  class="checkbox-inline errorMsg">Please select at least one checkbox in the section</span>
    </p>
</div>

<div class="form-inline row">
    <div class="col-md-5 divContent">

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorSupportive" name="isCentralLine" value="${mReviewForm?.isCentralLine}"/>Central Line

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorSupportive" name="isCPR" value="${mReviewForm?.isCPR}"/>CPR

            </label>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorSupportive" name="isSupportiveHemodialysis"
                            value="${mReviewForm?.isSupportiveHemodialysis}"/>Hemodialysis
            </label>
        </div>


    </div>

    <div class="col-md-7 divContent">

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorSupportive" name="isIntubation" value="${mReviewForm?.isIntubation}"/>Intubation
            </label>
        </div>


        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorSupportive" name="isSupportiveVasopressors"
                            value="${mReviewForm?.isSupportiveVasopressors}"/>Vasopressors
            </label>
        </div>

        <div>
            <label class="checkbox-inline checkboxTop">
                <g:checkBox class="majorSupportive checkComment" name="isSupportiveOther" value="${mReviewForm?.isSupportiveOther}"
                            onclick="showHideTextarea(this)"/>Other &nbsp;&nbsp;&nbsp;&nbsp;
            </label>
            <div id="supportiveOtherCommentDivId" ${!mReviewForm?.isSupportiveOther ? "style=display:none" : ''}
                 class="isSupportiveOther_div checkbox-inline">
                <span class="required">*&nbsp;</span>
                <textarea maxlength="250" class="ax_default text_area ${mReviewForm?.isSupportiveOther ? "mandatory" : ''} isSupportiveOtherComment"  maxlength="250"
                          placeholder="Please specify" name="supportiveOtherComment">${mReviewForm?.supportiveOtherComment}</textarea>
            </div>
        </div>

        <div>
            <label class="checkbox-inline">
                <g:checkBox class="majorSupportive naCheckbox majSuppInter" name="isMajSuppInterNA"  value="${mReviewForm?.isMajSuppInterNA}"/>N/A
            </label>
        </div>
    </div>

</div>
</div>